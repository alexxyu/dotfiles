"""Exercise vipe with a controlling terminal and a noninteractive fake editor."""

import fcntl
import json
import os
import pty
import signal
import subprocess
import sys
import tempfile
import termios
import time
import unittest
from pathlib import Path

VIPE = Path(__file__).resolve().parents[1] / "home/localbin/vipe/vipe"


class VipeTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.log = self.root / "editor.json"
        self.editor = self.root / "vi"
        self.editor.write_text(
            f"#!{sys.executable}\n"
            "import json, os, pathlib, stat, sys, time\n"
            "path = pathlib.Path(sys.argv[-1])\n"
            "with open(os.environ['VIPE_TEST_LOG'], 'w') as log:\n"
            "    json.dump({'path': str(path), 'mode': stat.S_IMODE(path.stat().st_mode),\n"
            "               'content': path.read_text(), 'args': sys.argv[1:-1]}, log)\n"
            "mode = os.environ.get('VIPE_TEST_MODE')\n"
            "if mode == 'fail': sys.exit(23)\n"
            "if mode == 'wait': time.sleep(30)\n"
            "path.write_text(path.read_text() + 'edited\\n')\n"
        )
        self.editor.chmod(0o755)
        self.env = os.environ.copy()
        self.env.update(
            TMPDIR=str(self.root),
            VISUAL=f"{self.editor} --test-argument",
            VIPE_TEST_LOG=str(self.log),
        )

    def start(self, *args):
        master, slave = pty.openpty()
        self.addCleanup(os.close, master)

        def claim_terminal():
            os.setsid()
            fcntl.ioctl(slave, termios.TIOCSCTTY, 0)

        try:
            process = subprocess.Popen(
                ["bash", str(VIPE), *args],
                stdin=subprocess.PIPE,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                env=self.env,
                preexec_fn=claim_terminal,
                pass_fds=(slave,),
            )
        finally:
            os.close(slave)
        self.addCleanup(self.stop, process)
        return process

    @staticmethod
    def stop(process):
        if process.poll() is None:
            os.killpg(process.pid, signal.SIGKILL)
        process.communicate()

    def assert_cleaned_up(self):
        self.assertEqual(list(self.root.glob("vipe.*")), [])

    def test_pipe_extension_permissions_and_editor_arguments(self):
        process = self.start("-e=json")
        stdout, stderr = process.communicate(b'{"key": true}\n', timeout=10)
        self.assertEqual(process.returncode, 0, stderr)
        self.assertEqual(stdout, b'{"key": true}\nedited\n')
        record = json.loads(self.log.read_text())
        self.assertTrue(record["path"].endswith(".json"))
        self.assertEqual(record["mode"], 0o600)
        self.assertEqual(record["args"], ["--test-argument"])
        self.assert_cleaned_up()

    def test_editor_failure_propagates_without_output_or_leftovers(self):
        self.env["VIPE_TEST_MODE"] = "fail"
        process = self.start()
        stdout, _ = process.communicate(b"input\n", timeout=10)
        self.assertEqual(process.returncode, 23)
        self.assertEqual(stdout, b"")
        self.assert_cleaned_up()

    def test_editor_falls_back_to_vi(self):
        self.env.pop("VISUAL", None)
        self.env.pop("EDITOR", None)
        self.env["PATH"] = str(self.root) + os.pathsep + self.env["PATH"]
        process = self.start()
        stdout, stderr = process.communicate(b"input\n", timeout=10)
        self.assertEqual(process.returncode, 0, stderr)
        self.assertEqual(stdout, b"input\nedited\n")
        self.assert_cleaned_up()

    def test_extension_cannot_escape_temporary_directory(self):
        process = self.start("-e=../../escaped")
        stdout, stderr = process.communicate(b"input", timeout=10)
        self.assertNotEqual(process.returncode, 0)
        self.assertIn(b"invalid extension", stderr)
        self.assertEqual(stdout, b"")
        self.assertFalse(self.log.exists())
        self.assert_cleaned_up()

    def test_interrupt_cleans_up(self):
        self.env["VIPE_TEST_MODE"] = "wait"
        process = self.start()
        process.stdin.close()
        process.stdin = None
        deadline = time.monotonic() + 10
        while not self.log.exists() and time.monotonic() < deadline:
            time.sleep(0.02)
        self.assertTrue(self.log.exists(), "editor did not start")
        os.killpg(process.pid, signal.SIGINT)
        stdout, _ = process.communicate(timeout=10)
        self.assertNotEqual(process.returncode, 0)
        self.assertEqual(stdout, b"")
        self.assert_cleaned_up()


if __name__ == "__main__":
    unittest.main()

"""Check fuzzy-search state and quoting without launching an interactive picker."""

import os
import subprocess
import tempfile
import unittest
from pathlib import Path

ZSHRC = Path(__file__).resolve().parents[1] / "home/shell/zshrc"


class SearchTests(unittest.TestCase):
    def test_query_round_trip_isolated_state_and_cancellation(self):
        with tempfile.TemporaryDirectory(prefix="shell tests ") as directory:
            root = Path(directory)
            env = os.environ.copy()
            env.update(
                HOME=directory,
                TMPDIR=directory,
                TERMBG="dark",
                TEST_ZSHRC=str(ZSHRC),
                TEST_LOG=str(root / "paths"),
                TEST_QUERY="quotes ' \" [x] $(touch should-not-exist)",
            )
            script = r'''
                vivid() { :; }
                compdef() { :; }
                source "$TEST_ZSHRC" || true
                fzf() {
                  local arg transform action restored
                  for arg in "$@"; do
                    if [[ "$arg" == ctrl-t:transform:* ]]; then
                      transform="${arg#ctrl-t:transform:}"
                    fi
                  done
                  [[ -d "$RG_FZF_STATE_DIR" ]] || return 1
                  print -r -- "$RG_FZF_STATE_DIR" >> "$TEST_LOG"
                  local -x FZF_PROMPT='1. ripgrep> ' FZF_QUERY="$TEST_QUERY"
                  action=$(eval "$transform") || return 2
                  eval "${action#*transform-query:}" > /dev/null || return 3
                  [[ "$(cat "$RG_FZF_STATE_DIR/ripgrep")" == "$TEST_QUERY" ]] || return 4
                  FZF_PROMPT='2. fzf> '
                  FZF_QUERY='second query'
                  action=$(eval "$transform") || return 5
                  restored=$(eval "${action#*transform-query:}") || return 6
                  [[ "$restored" == "$TEST_QUERY" ]] || return 7
                  return "$picker_status"
                }
                RG_PREFIX=sentinel INITIAL_QUERY=sentinel
                picker_status=0
                sg first || exit 10
                picker_status=130
                sg second
                [[ $? == 130 ]] || exit 11
                [[ "$RG_PREFIX" == sentinel && "$INITIAL_QUERY" == sentinel ]] || exit 12
                [[ -z ${RG_FZF_STATE_DIR+x} ]] || exit 13
            '''
            result = subprocess.run(
                ["zsh", "-f", "-c", script],
                cwd=root,
                env=env,
                capture_output=True,
                text=True,
                timeout=10,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            paths = (root / "paths").read_text().splitlines()
            self.assertEqual(len(set(paths)), 2)
            self.assertTrue(all(not Path(path).exists() for path in paths))
            self.assertFalse((root / "should-not-exist").exists())


if __name__ == "__main__":
    unittest.main()

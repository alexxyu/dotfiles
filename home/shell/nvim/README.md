# Neovim

## Configuration

This directory is symlinked to `~/.config/nvim`.

- **Lua changes:** restart Neovim; no Nix rebuild needed.
- **Nix wrapper changes:** rebuild after editing [`../neovim.nix`](../neovim.nix).

The symlink points directly into this checkout, so restore Lua settings through
Git when rolling back. Nix generation rollbacks do not restore plugins or
Mason-installed tools; use the plugin and tool managers for those.

## Requirements

- Neovim **0.12+**.
- The `tree-sitter` CLI, included in the Nix Neovim wrapper, to compile parsers.
- A C compiler is also included in the wrapper. Node.js/npm, Python, Go, and
  unzip are installed by Home Manager for Mason and shell helpers. Mise can
  override runtime versions in individual projects; Rust toolchains remain
  managed by rustup.

Tree-sitter uses its maintained `main` branch.

## Plugins

Plugins are managed by lazy.nvim. Leap comes from its maintained Codeberg repository.

| Command | Purpose |
| --- | --- |
| `:Lazy restore` | Install versions recorded in `lazy-lock.json`. |
| `:Lazy update` | Update plugins and the lockfile. |
| `:Lazy clean` | Delete installed copies of plugins removed from the configuration. |
| `:TSUpdate` | Update syntax parsers to match Tree-sitter's queries. |

Tree-sitter runs `:TSUpdate` automatically when the plugin updates.
Run it manually after restoring older plugin versions as well.

## Manual checks

After applying the configuration and installing plugins, run a quick startup
smoke check with the installed Neovim configuration:

```sh
NVIM_LOG_FILE="$(mktemp "${TMPDIR:-/tmp}/nvim-check.XXXXXXXXXX")" nvim --headless +qa
```

Inspect any startup errors printed to the terminal. The log goes to a temporary
file rather than the repository. The flake checks do not launch Neovim.
Use `:checkhealth` interactively for plugin and tool diagnostics.

To check formatting, save a scratch file with trailing whitespace, toggle
formatting off with `<Space>xf`, and confirm saving preserves that whitespace.
Also check that intentional two-space Markdown line breaks survive formatting.

## Formatting

Conform chooses a formatter by filetype:

| Filetypes | Formatter |
| --- | --- |
| JavaScript, TypeScript, JSX, TSX | Prettier |
| CSS, SCSS, Less, HTML | Prettier |
| JSON, JSONC, YAML, Markdown | Prettier |
| Bash, sh | shfmt |
| Other filetypes | LSP formatting, when available |

Prettier and shfmt are installed through Mason. Project formatter configuration
is respected.

Formatting on save is **enabled by default**, with a two-second timeout.
Buffers without a configured filetype formatter use LSP formatting when available,
otherwise Conform's whitespace cleanup.
Markdown uses Prettier so intentional two-space line breaks are preserved.
Disabling formatting on save also disables this whitespace cleanup.

| Shortcut / command | Action |
| --- | --- |
| `<Space>cf` | Format the current buffer manually. |
| `<Space>xf` | Toggle formatting on save for the current buffer. |
| `:ConformInfo` | Inspect formatter availability and logs. |

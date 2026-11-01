# Neovim

## Configuration

This directory is symlinked to `~/.config/nvim`.

- **Lua changes:** restart Neovim; no Nix rebuild needed.
- **Nix wrapper changes:** rebuild after editing [`../neovim.nix`](../neovim.nix).

## Requirements

- Neovim **0.12+**.
- The `tree-sitter` CLI, included in the Nix Neovim wrapper, to compile parsers.

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

| Shortcut / command | Action |
| --- | --- |
| `<Space>cf` | Format the current buffer manually. |
| `<Space>xf` | Toggle formatting on save for the current buffer. |
| `:ConformInfo` | Inspect formatter availability and logs. |

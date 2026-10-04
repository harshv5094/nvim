# My neovim config

Lightweight version of my neovim configuration.

## Requirements

- **Neovim >= 0.12** (uses the native LSP API: `vim.lsp.config` / `vim.lsp.enable`)
- `git` (for plugin bootstrapping)
- A C compiler / `unzip` (for some treesitter parsers and mason tools)

## Install

```bash
git clone <your-repo-url> ~/.config/nvim
nvim
```

On first launch, [lazy.nvim](https://github.com/folke/lazy.nvim) bootstraps itself and
installs all plugins. Mason then auto-installs the LSP servers and tools declared in `lsp.lua`.

## Structure

```
init.lua                 -> entry point, loads config.lazy
lua/
  config/
    lazy.lua             -> bootstraps lazy.nvim and imports plugin specs
    options.lua          -> vim options
    keymaps.lua          -> global + LSP keymaps
    autocmds.lua         -> autocommands (incl. LSP auto-enable)
    diagnostics.lua      -> vim.diagnostic config + virtual text toggle
  plugins/               -> plugin specs (one file per concern: lsp, ui, format, ...)
  utils/                 -> small helper modules
lsp/                     -> per-server LSP configs (vim.lsp.Config), auto-loaded
```

## Plugins at a glance

Plugins are split into focused specs under `lua/plugins/`:

- `lsp.lua` — `lazydev.nvim`, `blink.cmp` completion, Mason + tool installer
- `format.lua` — `conform.nvim` (stylua for lua, shfmt for shell)
- `lint.lua` — `nvim-lint` (luacheck for lua, shellcheck for shell)
- `git.lua` — `gitsigns.nvim` + `vim-fugitive`
- `editor.lua` — `telescope.nvim`, `oil.nvim`, `grug-far.nvim`, undotree, sessions, dial, lazygit
- `ui.lua`, `00-colorscheme.lua`, `treesitter.lua`, `mini.lua`, `coding.lua` — UI, treesitter,
  colorscheme, and editing conveniences

Open `:Lazy` to see everything installed and `:Lazy help` for usage.

# My neovim config

Lightweight version of my neovim configuration. Inspired but not dependent on [LazyVim](https://lazyvim.org)

## Requirements

- **Neovim >= 0.12** (uses the native LSP API: `vim.lsp.config` / `vim.lsp.enable`)
- `git` (for plugin bootstrapping)
- A C compiler / `unzip` (for some treesitter parsers and mason tools)

## Install

```bash
git clone https://github.com/harshv5094/nvim ~/.config/nvim
nvim
```

On first launch, [lazy.nvim](https://github.com/folke/lazy.nvim) bootstraps itself and
installs all plugins. Mason then auto-installs the LSP servers and tools declared in `lsp.lua`.

If you want to use as an another neovim setup, I'll suggest you to set an `NVIM_APPNAME` alias for that, so you can experience this setup without removing your previous setup.

To do this just run below commands

> [!NOTE]
> Just make sure the folder name and alias name is same, it's necessary for `NVIM_APPNAME` to work.

```bash
git clone https://github.com/harshv5094/nvim ~/.config/mnvim
alias mnvim="NVIM_APPNAME=mnvim nvim"
```


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
  plugins/               -> plugin specs (one file per concern: lsp, ui, format, etc)
  utils/                 -> small helper modules
lsp/                     -> per-server LSP configs (vim.lsp.Config), auto-loaded
```

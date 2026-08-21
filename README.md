# My neovim config

Lightweight version of my neovim configuration.

## Requirements

- **Neovim >= 0.12** (uses the native LSP API: `vim.lsp.config` / `vim.lsp.enable`)
- `git` (for plugin bootstrapping)
- A C compiler / `unzip` (for some treesitter parsers and mason tools)

## Install

```sh
git clone <your-repo-url> ~/.config/mnvim
nvim
```

On first launch, [lazy.nvim](https://github.com/folke/lazy.nvim) bootstraps itself and
installs all plugins. Mason then auto-installs the LSP servers and tools listed below.

## Structure

```
init.lua                 -> entry point, loads config.lazy
lua/
  config/
    lazy.lua             -> bootstraps lazy.nvim and imports plugin specs
    options.lua          -> vim options
    keymaps.lua          -> global + LSP keymaps
    autocmds.lua         -> autocommands (incl. LSP auto-enable, see below)
  plugins/               -> plugin specs (one file per concern: lsp, ui, format, ...)
  utils/                 -> small helper modules
lsp/                     -> per-server LSP configs (vim.lsp.Config), auto-loaded
```

## LSP & Mason

Language servers are configured with the **native LSP API** (no `nvim-lspconfig`).
Each server lives in its own file under `lsp/` and returns a `vim.lsp.Config` table,
e.g. `lsp/lua_ls.lua`, `lsp/bashls.lua`, `lsp/yamlls.lua`, `lsp/taplo.lua`.

They are enabled automatically by an autocommand in `lua/config/autocmds.lua`, which
scans every `lsp/*.lua` on the runtime path and calls `vim.lsp.enable(servers)` once on
the first buffer open. It also merges blink.cmp's capabilities into every client.

[Mason](https://github.com/mason-org/mason.nvim) is used purely as a **binary provider**.
On `setup()` it prepends `~/.local/share/nvim/mason/bin` to `$PATH`, so the bare command
names used in `lsp/*.lua` (e.g. `"lua-language-server"`) resolve to Mason-managed binaries
with **no changes** to the server configs.

Setup lives in `lua/plugins/mason.lua` and uses two plugins:

- `mason-org/mason.nvim` — the core (UI + PATH wiring). The `version = "v2.0.0"` pin is
  intentional: it keeps you on the v2 line and away from the old archived fork / unstable
  default branch.
- `WhoIsSethDaniel/mason-tool-installer.nvim` — ensures the following are installed
  automatically on startup (`automatic_installation = true`):

  | Kind      | Packages                                                       |
  | --------- | -------------------------------------------------------------- |
  | LSP       | `lua-language-server`, `bash-language-server`, `yaml-language-server`, `taplo` |
  | Formatter | `stylua`                                                       |
  | Linter    | `shellcheck`, `shfmt`                                          |

`bashls` additionally relies on `shellcheck` (diagnostics) and `shfmt` (formatting), both
provided by Mason. `yamlls` uses `SchemaStore.nvim` (already a plugin) for schemas.

### Verify

- `:Mason` — the six packages should reach **Installed**.
- `:checkhealth mason` — no errors.
- Open a `.lua` file and run `:lua print(vim.lsp.get_clients({name="lua_ls"})[1].config.cmd[1])`
  — it should print a path under the Mason `bin/` directory.
- `:LspLog` opens the LSP log if a server fails to spawn.

## Plugins at a glance

Plugins are split into focused specs under `lua/plugins/`:

- `lsp.lua` — `lazydev.nvim` + `blink.cmp` completion
- `format.lua` — `conform.nvim` (stylua for lua)
- `ui.lua`, `colorscheme.lua`, `treesitter.lua`, `mini.lua`, `gitsigns.lua`, `coding.lua`,
  `editor.lua` — UI, treesitter, git, and editing conveniences

Open `:Lazy` to see everything installed and `:Lazy help` for usage.

## Keybindings

Defined in `lua/config/keymaps.lua`. Highlights:

- `<leader>e` — netrw explorer
- `<leader>l` — `:Lazy`
- `<leader>ca` — code action, `<leader>cr` — rename, `K` — hover, `gd` — definition
- `<leader>xx` — Trouble diagnostics
- `<leader>gi` — custom git init
- `<leader>t` — toggle terminal

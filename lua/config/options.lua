local discipline = require("utils.discipline")
local g = vim.g
local opt = vim.opt

-- A discipline blocker for better horizontal / vertical navigation
discipline.cowboy()

-- Setting leader and localleader keys
g.mapleader = " "
g.maplocalleader = "\\"

-- netrw options
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.netrw_liststyle = 3 -- Tree View
g.netrw_banner = 1 -- hide the top banner
g.netrw_winsize = 25 -- Fix the left space width
g.netrw_browse_split = 0 -- Open files in the previous window
g.netrw_altfile = 1 -- keep the alternate file correct

local has = function(x)
	return vim.fn.has(x) == 1
end

if has("win32") then
	opt.shell = "pwsh"
	opt.clipboard:prepend({ "unnamed", "unnamedplus" })
	g.nofsync = true
end

if has("macunix") then
	opt.clipboard:append({ "unnamedplus" })
end

vim.scriptencoding = "utf-8"
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.title = true
opt.relativenumber = true
opt.termguicolors = true
opt.autoindent = true
opt.smartindent = true
opt.autoread = true
opt.hlsearch = true
opt.backup = false
opt.showcmd = true
opt.cmdheight = 1
opt.laststatus = 3
opt.expandtab = true
opt.scrolloff = 10
opt.backupskip = { "/tmp/*", "/private/tmp/*" }
opt.inccommand = "split"
opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
opt.smarttab = true
opt.breakindent = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.wrap = false -- No Wrap lines
opt.swapfile = true -- Toggle swap files
opt.undofile = true -- Toggle undofile
opt.backspace = { "start", "eol", "indent" }
opt.path:append({ "**" }) -- Finding files - Search down into subfolders
opt.wildignore:append({ "*/node_modules/*" })
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.splitkeep = "cursor"
-- Setting up basic options
opt.cursorline = true --Highlighted cursorline
-- opt.mouse = "a"

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Add asterisks in block comments
opt.formatoptions:append({ "r" })

-- LSP folding: open all folds when a buffer is loaded
opt.foldlevelstart = 99

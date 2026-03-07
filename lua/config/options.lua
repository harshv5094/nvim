local g = vim.g
local opt = vim.o

-- Setting leader and localleader keys
g.mapleader = " "
g.maplocalleader = "\\"

-- Setting up basic options
opt.cursorline = true --Highlighted cursorline
opt.tabstop = 2 -- 2 space for tabs
opt.shiftwidth = 2 
opt.relativenumber = true -- Relative Line number
opt.clipboard = "unnamedplus" -- Enable global clipboard
opt.autoindent = true -- Indent automatically
opt.ignorecase = true -- Ignore case while searching
opt.smartcase = true -- Smart case while searching
opt.hlsearch = false -- Disable highlight search
opt.wrap = false -- Turn off wrapping lines (I don't like it)
opt.splitright = true -- Split window on right
opt.splitbelow = true -- Split window on below
opt.swapfile = true -- Use swap file to save unsave backup
opt.undofile = true -- Enable persistant undo
opt.backup = false  -- Disable neovim backup functionality
opt.writebackup = false -- Disable neovim backup functionality
opt.scrolloff = 3 -- Set line scrolling to 3 lines
opt.pumheight = 5 -- Popup Items height

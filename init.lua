-- Setting leader and localleader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setting up basic options
local opt = vim.o

opt.cursorline = true --Highlighted cursorline
opt.relativenumber = true -- Relative Line number
opt.clipboard = "unnamedplus" -- Enable global clipboard
opt.autoindent = true -- Indent automatically
opt.ignorecase = true -- Ignore case while searching
opt.wrap = false -- Turn off wrapping lines (I don't like it)
opt.splitright = true -- Split window on right
opt.splitbelow = true -- Split window on below
opt.swapfile = true -- Use swap file to save unsave backup

-- Netrw Explorer keymap
vim.keymap.set("n", "<leader>e", "<CMD>Explore<CR>", { desc = "Explore" })

-- Split screen keymaps
vim.keymap.set("n", "ss", "<CMD>split<CR>")
vim.keymap.set("n", "sv", "<CMD>vsplit<CR>")

-- Split screen focus navigation
vim.keymap.set("n", "sh", "<C-W>h")
vim.keymap.set("n", "sj", "<C-W>j")
vim.keymap.set("n", "sk", "<C-W>k")
vim.keymap.set("n", "sl", "<C-W>l")

-- Setting leader and localleader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setting up basic options
local opt = vim.o

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

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

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

-- Split screen resize
vim.keymap.set("n", "<C-h>", "<C-w><")
vim.keymap.set("n", "<C-j>", "<C-w>+")
vim.keymap.set("n", "<C-k>", "<C-w>-")
vim.keymap.set("n", "<C-l>", "<C-w>>")

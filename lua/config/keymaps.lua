local keymap = vim.keymap
local git = require("utils.git")

-- Netrw Explorer keymap
keymap.set("n", "<leader>e", "<CMD>Explore<CR>", { desc = "Explore" })

-- Split screen keymaps
keymap.set("n", "ss", "<CMD>split<CR>")
keymap.set("n", "sv", "<CMD>vsplit<CR>")

-- Lazy.nvim keymap
keymap.set("n", "<leader>l", "<CMD>Lazy<CR>", { desc = "Lazy" })

-- Split screen focus navigation
keymap.set("n", "sh", "<C-W>h")
keymap.set("n", "sj", "<C-W>j")
keymap.set("n", "sk", "<C-W>k")
keymap.set("n", "sl", "<C-W>l")

-- Split screen resize
keymap.set("n", "<C-h>", "<C-w><")
keymap.set("n", "<C-j>", "<C-w>+")
keymap.set("n", "<C-k>", "<C-w>-")
keymap.set("n", "<C-l>", "<C-w>>")

-- My custom git initialization function
keymap.set("n", "<leader>gi", git.init, { desc = "Git init" } )

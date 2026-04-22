local map = vim.keymap.set
local git = require("utils.git")
local hex2rgba = require("utils.hex2rgba")
local base = require("utils.base")

local opts = { noremap = true, silent = true }

-- Netrw Explorer keymap
map("n", "<leader>e", "<CMD>Explore<CR>", { desc = "Explore", noremap = true })

-- Split screen keymaps
map("n", "ss", "<CMD>split<CR>", opts)
map("n", "sv", "<CMD>vsplit<CR>", opts)

-- Split screen keymaps (leader key edition)
map("n", "<leader>-", "<CMD>split<CR>", opts)
map("n", "<leader>|", "<CMD>vsplit<CR>", opts)

-- Lazy.nvim keymap
map("n", "<leader>l", "<CMD>Lazy<CR>", { desc = "Lazy", noremap = true })

-- Split screen focus navigation
map("n", "sh", "<C-W>h", opts)
map("n", "sj", "<C-W>j", opts)
map("n", "sk", "<C-W>k", opts)
map("n", "sl", "<C-W>l", opts)

-- Split screen resize
map("n", "<C-h>", "<C-w><", opts)
map("n", "<C-j>", "<C-w>+", opts)
map("n", "<C-k>", "<C-w>-", opts)
map("n", "<C-l>", "<C-w>>", opts)

-- Major Navigation
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "<C-d>", "<C-d>zz", opts)

-- My custom git initialization function
map("n", "<leader>gi", git.init, { desc = "Git init", noremap = true })

-- String auto replace
map(
	"n",
	"<localleader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "String auto replace", noremap = true }
)

-- Adding executable permission to script
map("n", "<localleader>x", "<cmd>!chmod +x %<CR>", { desc = "chmod +x <current-buffer>", silent = true })
map("n", "<localleader>X", "<cmd>!chmod -x %<CR>", { desc = "chmod -x <current-buffer>", silent = true })

-- Custom utility to convert hex to rgba
map("n", "<localleader>cs", function()
	hex2rgba.Set()
end, { desc = "Convert Hex to RGBA", silent = true, noremap = true })

-- Rename whole variables in the buffer
map("n", "rn", function()
	vim.lsp.buf.rename()
end, { desc = "rename buffer", silent = true })

map({ "n", "t" }, "<C-/>", base.toggle_terminal, { desc = "Toggle Terminal" })

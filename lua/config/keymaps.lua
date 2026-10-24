-- Custom Utility Function
local git = require("utils.git")
local base = require("utils.base")
local discipline = require("utils.discipline")

discipline.cowboy()

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Clear search and stop snippet on escape
map({ "i", "n", "s" }, "<esc>", function()
	vim.cmd("noh")
	if vim.snippet and vim.snippet.active() then
		vim.snippet.stop()
	end
	return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Delete a word backwards
map("n", "dw", 'vb"_d', opts)

-- Save - Save from any mode
map({ "i", "n", "v" }, "<C-s>", "<ESC><CMD>w<CR>", { desc = "Save" })

-- Split screen keymaps
map("n", "ss", "<CMD>split<CR>", opts)
map("n", "sv", "<CMD>vsplit<CR>", opts)

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

-- Open the current file/line or the repository in the browser
map({ "n", "v" }, "<leader>gB", function()
	git.browse()
end, { desc = "Git Browse (file/line)" })

map("n", "<leader>gb", function()
	git.browse({ what = "repo" })
end, { desc = "Git Browse (repo)" })

-- String auto replace
map(
	"n",
	"<localleader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Search and Replace (Buffer)", noremap = true }
)

-- Keymaps for tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Toggle Keymaps
map("n", "<leader>uh", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hint" })

map("n", "<leader>uc", function()
	vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())
end, { desc = "Toggle Codelens" })

-- Special chmod keymaps for windows and mac only
if vim.fn.has("linux") == 1 or vim.fn.has("mac") == 1 then
	-- chmod +x <current-buffer>
	map("n", "<leader>fx", function()
		base.chmod()
	end, { desc = "chmod +x <current-buffer>" })

	-- chmod -x <current-buffer>
	map("n", "<leader>fX", function()
		base.chmod("-")
	end, { desc = "chmod -x <current-buffer>" })
end

-- Quit while asking
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Terminal toggle keymaps
map({ "n", "t" }, "<leader>ft", base.toggle_terminal, { desc = "Toggle Terminal" })

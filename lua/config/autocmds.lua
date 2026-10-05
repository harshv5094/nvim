-- A small function to quickly create a augroup
local function augroup(name)
	return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("HighlightOnYank"),
	pattern = "*",
	callback = function()
		if vim.fn.has("nvim-0.13") == 1 then
			vim.hl.hl_op()
		else
			(vim.hl or vim.highlight).on_yank()
		end
	end,
})

-- Set up LSP servers.
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	once = true,
	callback = function()
		local capabilities = {
			workspace = {
				fileOperations = {
					didRename = true,
					willRename = true,
				},
			},
		}

		-- Extend neovim's client capabilities with the completion ones.
		vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(capabilities, true) })

		local servers = vim
			.iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
			:map(function(file)
				return vim.fn.fnamemodify(file, ":t:r")
			end)
			:totable()
		vim.lsp.enable(servers)

		-- Enable inlay hints globally by default (toggle with <leader>uh)
		vim.lsp.inlay_hint.enable(true)
	end,
})

-- Move LSP keymaps into an LspAttach autocmd
vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup("UserLspAttach"),
	callback = function(ev)
		local function keymap(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
		end
		-- LSP keymaps
		keymap("n", "<leader>ca", vim.lsp.buf.code_action, "Code Actions")
		keymap("n", "<leader>cr", vim.lsp.buf.rename, "Code Rename")
		keymap({ "n", "x" }, "<leader>cc", vim.lsp.codelens.run, "Run Codelens")
		keymap("n", "gd", vim.lsp.buf.definition, "Goto Definition")

		-- Toggle inlay hints globally (on by default; no-op on servers without support)
		keymap("n", "<leader>uh", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end, "Toggle inlay hints")

		-- Toggle codelens (global)
		keymap("n", "<leader>uc", function()
			vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())
		end, "Toggle Codelens")
	end,
})

-- Auto clear prompt message after moving the cursor
vim.api.nvim_create_autocmd("CursorMoved", {
	group = augroup("ClearPrompt"),
	callback = function()
		vim.cmd("echo ''")
	end,
})

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

-- Turn on wrap for specific files only
vim.api.nvim_create_autocmd({ "BufNew", "BufReadPre", "BufNewFile" }, {
	pattern = { "*.md", "*.markdown" },
	command = "set wrap",
})

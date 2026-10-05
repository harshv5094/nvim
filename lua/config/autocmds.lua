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
		-- Extend neovim's client capabilities with the completion ones,
		-- but only when blink.cmp is actually available (e.g. not when
		-- plugin install was declined).
		local capabilities
		local ok, blink = pcall(require, "blink.cmp")
		if ok then
			capabilities = blink.get_lsp_capabilities(nil, true)
		else
			capabilities = vim.lsp.protocol.make_client_capabilities()
		end
		vim.lsp.config("*", { capabilities = capabilities })

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

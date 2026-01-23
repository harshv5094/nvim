-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

-- Disable the concealing in some file format
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc" },
	callback = function()
		vim.opt.conceallevel = 0
	end,
})

-- Set up LSP servers.
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	once = true,
	callback = function()
		local server_configs = vim
			.iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
			:map(function(file)
				return vim.fn.fnamemodify(file, ":t:r")
			end)
			:totable()
		vim.lsp.enable(server_configs)
	end,
})

local ns = vim.api.nvim_create_namespace("toggle_hlsearch")
vim.on_key(function(char)
	if vim.fn.mode() == "n" then
		local key = vim.fn.keytrans(char)
		if vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, key) then
			vim.opt.hlsearch = true
		elseif key == "<Esc>" then
			vim.opt.hlsearch = false
		end
	end
end, ns)

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local bufnr = args.buf
		local ft = vim.bo[bufnr].filetype

		-- Check if we have a parser for this filetype
		local lang = vim.treesitter.language.get_lang(ft) or ft
		if lang and #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) > 0 then
			-- Start Highlighting
			vim.treesitter.start(bufnr, lang)
			-- Enable Indentation
			vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

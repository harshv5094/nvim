-- NOTE: Setting up diagnostics config

---@type vim.diagnostic.Opts.VirtualText
local virtual_text_opts = {
	spacing = 4,
	prefix = "●",
	-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
	-- prefix = "icons",
}
local virtual_text_on = true

---@type vim.diagnostic.Opts
local opts = {
	underline = true,
	update_in_insert = false,
	virtual_text = virtual_text_on and virtual_text_opts or false,
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "\u{f057} ",
			[vim.diagnostic.severity.WARN] = "\u{f071} ",
			[vim.diagnostic.severity.HINT] = "\u{f0eb} ",
			[vim.diagnostic.severity.INFO] = "\u{f05a} ",
		},
	},
}

-- Importing opts
vim.diagnostic.config(opts)

-- Toggle virtual text (keeps the custom spacing/source/prefix settings intact)
vim.keymap.set("n", "<leader>ut", function()
	virtual_text_on = not virtual_text_on
	vim.diagnostic.config({ virtual_text = virtual_text_on and virtual_text_opts or false })
end, { desc = "Toggle Virtual Text", noremap = true })

---@type vim.lsp.Config
return {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	init_options = { provideFormatter = true },
	settings = {
		json = {
			schemas = require("schemastore").json.schemas({
				select = {
					".eslintrc",
					"package.json",
				},
			}),
			validate = { enable = true },
		},
	},
}

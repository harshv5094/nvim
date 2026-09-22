local schemas = {}
local ok, store = pcall(require, "schemastore")
if ok then
	schemas = store.json.schemas({
		select = {
			".eslintrc",
			"package.json",
		},
	})
end

---@type vim.lsp.Config
return {
	settings = {
		json = {
			schemas = schemas,
			validate = { enable = true },
		},
	},
}

-- Binary (yaml-language-server) installed by mason (see plugins/mason.lua).

local schemas = {}
local ok, store = pcall(require, "schemastore")
if ok then
	schemas = store.yaml.schemas()
end

---@type vim.lsp.Config
return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml" },
	settings = {
		yaml = {
			-- Using the schemastore plugin for schemas.
			schemastore = { enable = false, url = "" },
			schemas = schemas,
		},
	},
}

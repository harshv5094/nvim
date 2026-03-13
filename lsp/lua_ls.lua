-- NOTE: To enable it run `:lua vim.lsp.enable('lua_ls')`
-- TODO: Learn how to auto-enable it dynamically without using the above command

---@type vim.lsp.Config
return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
		},
	},
}

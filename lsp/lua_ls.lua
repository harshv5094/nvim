-- Install with
-- mac: brew install lua-language-server
-- Arch: pacman -S lua-language-server

---@type vim.lsp.Config
return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { { ".luarc.json", ".luarc.jsonc" } },
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "Snacks" },
			},
			-- Disable telemetry files
			telemetry = {
				enable = false,
			},
			runtime = {
				version = "LuaJIT",
			},
		},
	},
}

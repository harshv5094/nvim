-- Binary (bash-language-server) installed by mason (see plugins/mason.lua).
-- Also uses shellcheck for diagnostics and shfmt for formatting (both via mason).

---@type vim.lsp.Config
return {
	cmd = { "bash-language-server", "start" },
	filetypes = { "bash", "sh", "zsh" },
}

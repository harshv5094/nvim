return {
	"mbbill/undotree",
	event = { "BufReadPre" },
	config = function()
		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, {
			desc = "Toggle Undotree",
		})
	end,
}

-- NOTE: Key Highlighter
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		-- Define your groups here
		wk.add({
			{ "<leader>q", group = "quit/session" },
			{ "<leader>b", group = "buffer" },
			{ "<leader>x", group = "diagnostics" },
			{ "<leader>f", group = "file/find" },
			{ "<leader>g", group = "git" },
			{ "<leader>s", group = "search" },
			{ "<leader>w", group = "windows" },
			{ "<leader>c", group = "code" },
			{ "<leader>l", group = "lazy" },
		})
	end,
}

-- NOTE: Collection of mini.nvim plugins
-- https://nvim-mini.org
return {
	-- Matching pairs for coding
	{
		"nvim-mini/mini.pairs",
		event = { "BufReadPre", "BufNewFile" },
		version = false,
		config = function()
			require("mini.pairs").setup({})
		end,
	},
}

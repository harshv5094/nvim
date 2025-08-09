return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "moon",
			light_style = "day",
			transparent = true,
			terminal_colors = true,
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
			},
			lualine_bold = true,
			-- For better performance
			cache = true,
			on_highlights = function(hl)
				local fgcolor = "#636da6"
				local bgcolor = "none"
				local colors = require("tokyonight.colors").setup()
				hl.MsgArea = { fg = colors.fg_float }
				hl.CursorLineNr = { fg = colors.orange }
				hl.LineNrAbove = { fg = fgcolor, bg = bgcolor }
				hl.LineNrBelow = { fg = fgcolor, bg = bgcolor }
				hl.Comment = { fg = fgcolor, bg = bgcolor }
				hl.TreesitterContextLineNumber = { fg = fgcolor, bg = bgcolor }
			end,
		},
	},

  -- Custom Status Line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'echasnovski/mini.icons' },
    config = function()
      local lualine = require('lualine')
      lualine.setup({
        theme = 'tokyonight'
      })
    end
  }
}

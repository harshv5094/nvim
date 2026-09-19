return {

	-- NOTE: Git Symbols show
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end
				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, "Next hunk")
				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, "Prev hunk")
				-- Actions (prefix: <leader>gh)
				map("n", "<leader>ghs", gs.stage_hunk, "Stage hunk")
				map("n", "<leader>ghr", gs.reset_hunk, "Reset hunk")
				map("v", "<leader>ghs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage hunk")
				map("v", "<leader>ghr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Reset hunk")
				map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
				map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo stage hunk")
				map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
				map("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
				map("n", "<leader>ghb", function()
					gs.blame_line({ full = true })
				end, "Blame line")
				map("n", "<leader>ghd", gs.diffthis, "Diff this")
				map("n", "<leader>ghD", function()
					gs.diffthis("~")
				end, "Diff this (~)")
				-- Toggles
				map("n", "gtb", gs.toggle_current_line_blame, "Toggle line blame")
				map("n", "gtd", gs.toggle_deleted, "Toggle deleted")
				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
				-- quit/close in normal mode
				map("n", "q", "<cmd>close<CR>", "Close window")
			end,
		},
	},

	-- NOTE: Git wrapper for vim/neovim
	{
		"tpope/vim-fugitive",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{
				"<leader>gss",
				"<CMD>Git status<CR>",
				desc = "Git status",
			},
			{
				"<leader>gsq",
				"<CMD>Git status --short<CR>",
				desc = "Git status (short)",
			},
			{
				"<leader>gab",
				"<CMD>Git add %<CR>",
				desc = "Git add (Current Buffer)",
			},
			{
				"<leader>gaa",
				"<CMD>Git add *<CR>",
				desc = "Git add (All)",
			},
			{
				"<leader>gaf",
				":Git add ",
				desc = "Git add (Manual)",
			},
			{
				"<leader>gce",
				"<CMD>Git commit --edit<CR>",
				desc = "Git commit (edit)",
			},
			{
				"<leader>gca",
				"<CMD>Git commit --amend<CR>",
				desc = "Git commit (amend)",
			},
			{
				"<leader>gp",
				"<CMD>Git pull --no-edit<CR>",
				desc = "Git pull (no-edit)",
			},
			{
				"<leader>gr",
				"<CMD>Git reset --hard HEAD<CR>",
				desc = "Git reset (--hard) HEAD",
			},
			{
				"<leader>gP",
				"<CMD>Git push --force-with-lease<CR>",
				desc = "Git push (force-with-lease)",
			},
		},
	},
}

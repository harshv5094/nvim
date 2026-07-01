return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "│" },
			change = { text = "│" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signcolumn = true,
		numhl = false,
		linehl = false,
		word_diff = false,
		watch_gitdir = {
			follow_files = true,
		},
		current_line_blame = false,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 300,
		},
		current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
		sign_priority = 6,
		update_debounce = 100,
		max_file_length = 40000,
		preview_config = {
			border = "single",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
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
		end,
	},
}

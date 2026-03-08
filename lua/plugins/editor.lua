return {
	-- NOTE: Telescope.nvim (finder, picker etc)
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "nvim-telescope/telescope-file-browser.nvim", build = "make" },
		},
		config = function()
			local keymap = vim.keymap
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			local actions = require("telescope.actions")
			local fb_actions = telescope.extensions.file_browser.actions

			-- Builtin keymaps
			keymap.set("n", "<leader><space>", builtin.find_files, { desc = "Telescope find files" })
			keymap.set("n", "<leader>.", builtin.live_grep, { desc = "Telescope live grep" })
			keymap.set("n", "<leader>,", builtin.buffers, { desc = "Telescope buffers" })
			keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Telescope help tags" })
			keymap.set("n", "<leader>sm", builtin.man_pages, { desc = "Telescope man pages" })
			keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Telescope keymaps" })


			-- Neovim Config file keymap
			keymap.set("n", "<leader>fc", function()
				require("telescope.builtin").find_files({
					prompt_title = "Neovim Config Files",
					cwd = vim.fn.stdpath("config"),
				})
			end, { desc = "Neovim Config Files" })

			-- Telescope file browser
			keymap.set("n", "sf", function()
				local telescope = require("telescope")
				local function telescope_buffer_dir()
					return vim.fn.expand("%:p:h")
				end

				telescope.extensions.file_browser.file_browser({
					path = "%:p:h",
					cwd = telescope_buffer_dir(),
					respect_gitignore = true,
					hidden = true,
					follow_symlinks = true,
					grouped = true,
					previewer = true,
					initial_mode = "normal",
					-- layout_config = {
					-- 	height = 0.60,
					-- },
				})
			end, { desc = "Telescope file browser" })

			telescope.setup({
				defaults = {
					file_ignore_patterns = {
						"%.git/",
						"node_modules",
						-- "%.git$",
					},
					wrap_results = true,
					layout_stategy = "horizontal",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							previewer_width = 0.55,
						},
						width = 0.87,
						height = 0.80,
					},
					sorting_strategy = "ascending",
					winblend = 0,
					mappings = {
						n = {
							["q"] = actions.close,
						},
					},
				},
				extensions = {
					file_browser = {
						-- theme = "ivy",
						-- disables netrw and use telescope-file-browser in its place
						hijack_netrw = false,
						mappings = {
							-- your custom insert mode mappings
							["n"] = {
								-- your custom normal mode mappings
								["N"] = fb_actions.create,
								["h"] = fb_actions.goto_parent_dir,
								["q"] = actions.close,
								["H"] = fb_actions.toggle_hidden,
								["/"] = function()
									vim.cmd("startinsert")
								end,
								["<C-u>"] = function(prompt_bufnr)
									for i = 1, 10 do
										actions.move_selection_previous(prompt_bufnr)
									end
								end,
								["<C-d>"] = function(prompt_bufnr)
									for i = 1, 10 do
										actions.move_selection_next(prompt_bufnr)
									end
								end,
								["<PageUp>"] = actions.preview_scrolling_up,
								["<PageDown>"] = actions.preview_scrolling_down,
							},
						},
					},
				},
			})

			require("telescope").load_extension("fzf")
			require("telescope").load_extension("file_browser")
		end,
	},

	-- NOTE: Buffer closing plugin
	{
		"kazhala/close-buffers.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>bh",
				function()
					require("close_buffers").delete({ type = "hidden" })
				end,
				desc = "Close Hidden Buffers",
			},
			{
				"<leader>bd",
				function()
					require("close_buffers").delete({ type = "this" })
				end,
				desc = "Close Current Buffer",
			},
			{
				"<leader>bu",
				function()
					require("close_buffers").delete({ type = "nameless" })
				end,
				desc = "Close Nameless Buffers",
			},
		},
	},

	-- NOTE: Pairing plugin for [], {} and ()
	{
		"nvim-mini/mini.pairs",
		version = false,
		config = function()
			require('mini.pairs').setup()
		end
	},
}

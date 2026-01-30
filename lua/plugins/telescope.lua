return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	dependencies = {
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{
			"<leader>fc",
			function()
				require("telescope.builtin").find_files({
					prompt_title = "Neovim Config Files",
					cwd = vim.fn.stdpath("config"),
					hidden = true,
				})
			end,
			desc = "Find config files",
		},
		{
			"<leader>fP",
			function()
				require("telescope.builtin").find_files({
					cwd = require("lazy.core.config").options.root,
				})
			end,
			desc = "Lazy Config (Root)",
		},
		{
			"<leader>ci",
			function()
				local builtin = require("telescope.builtin")
				builtin.lsp_incoming_calls()
			end,
			desc = "LSP incoming calls",
		},
		{
			"<leader>sr",
			function()
				require("telescope.builtin").resume()
			end,
			desc = "Telescope -> Resume",
		},
		{
			"<leader><space>",
			function()
				local builtin = require("telescope.builtin")
				builtin.find_files({
					no_ignore = false,
					follow = true,
					hidden = true,
				})
			end,
			desc = "Find Files",
		},
		{
			"<leader>:",
			function()
				require("telescope.builtin").command_history()
			end,
			desc = "Command History",
		},
		{
			"<leader>,",
			function()
				local builtin = require("telescope.builtin")
				builtin.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>/",
			function()
				local builtin = require("telescope.builtin")
				builtin.live_grep()
			end,
			desc = "Live Grep",
		},
		{
			"<leader>sh",
			function()
				local builtin = require("telescope.builtin")
				builtin.help_tags()
			end,
			desc = "Help Tags",
		},
		{
			"sf",
			function()
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
					layout_config = {
						-- height = default_height,
					},
				})
			end,
			desc = "Browse Files",
		},
		{
			"<leader>sk",
			function()
				require("telescope.builtin").keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"<leader>sm",
			function()
				require("telescope.builtin").man_pages()
			end,
			desc = "Man Pages",
		},
		{
			"<leader>cd",
			function()
				require("telescope.builtin").diagnostics()
			end,
			desc = "Diagnostics",
		},
	},
	config = function(_, opts)
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local fb_actions = require("telescope").extensions.file_browser.actions

		opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
			file_ignore_patterns = {
				"%.git/",
				"node_modules",
				"%.git$",
			},
			wrap_results = true,
			layout_strategy = "horizontal",
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
		})

		opts.extensions = {
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
		}
		telescope.setup(opts)
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("file_browser")
	end,
}

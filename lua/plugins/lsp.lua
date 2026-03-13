return {
	{
		"saghen/blink.cmp",
    dependencies = { 'L3MON4D3/LuaSnip', version = 'v2.*' },
		opts = {
			keymap = {
				preset = 'default',
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
    		['<CR>'] = { 'accept_and_enter', 'fallback' },
			},
  		sources = {
      	default = { 'lsp', 'path', 'snippets', 'buffer' },
    	},
			cmdline = {
					enabled = false
			},
			completion = {
				trigger = {
					prefetch_on_insert = true
				},
				ghost_text = {
					enabled = true
				},
				list = {
					selection = {
						preselect = true,
						auto_insert = true
					}
				}
			},
    	fuzzy = { implementation = "lua" }
		}
	}
}

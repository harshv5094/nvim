-- Experimental core messages + cmdline UI (:h ui2)
require("vim._core.ui2").enable({
	msg = {
		targets = "cmd", -- Default: messages shown in the cmdline area, collapse with [+x]
		msg = { timeout = 4000 }, -- Time a message is visible in the msg window
		pager = { height = 1 }, -- Max height of the :messages pager window
	},
})

-- Keep { title = ... } passed to vim.notify (replaces mini.notify behavior)
-- Messages still flow through the message system, so ui2 renders them
vim.notify = function(msg, level, opts)
	if type(opts) == "table" and opts.title then
		msg = ("[%s] %s"):format(opts.title, msg)
	end
	local hl = level == vim.log.levels.ERROR and { "ErrorMsg" } or nil
	vim.api.nvim_echo({ { tostring(msg), hl } }, false, {})
end

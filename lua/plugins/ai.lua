return {
	"nickvandyke/opencode.nvim",
	event = "VeryLazy",
	config = function()
		vim.keymap.set({ "n", "x" }, "<leader>aa", function()
			require("opencode").ask("@this: ", { submit = true })
		end, { desc = "Ask opencode…" })
		vim.keymap.set({ "n", "x" }, "<leader>as", function()
			require("opencode").select()
		end, { desc = "Execute opencode action…" })
		vim.keymap.set({ "n", "t" }, "<leader>at", function()
			require("opencode").toggle()
		end, { desc = "Toggle opencode" })

		vim.keymap.set({ "n", "x" }, "<leader>ao", function()
			return require("opencode").operator("@this ")
		end, { desc = "Add range to opencode", expr = true })
		vim.keymap.set("n", "<leader>al", function()
			return require("opencode").operator("@this ") .. "_"
		end, { desc = "Add line to opencode", expr = true })

		vim.keymap.set("n", "<leader>ak", function()
			require("opencode").command("session.half.page.up")
		end, { desc = "Scroll opencode up" })
		vim.keymap.set("n", "<leader>aj", function()
			require("opencode").command("session.half.page.down")
		end, { desc = "Scroll opencode down" })

		vim.keymap.set("n", "<leader>a+", "<C-a>", { desc = "Increment under cursor", noremap = true })
		vim.keymap.set("n", "<leader>a-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
	end,
}

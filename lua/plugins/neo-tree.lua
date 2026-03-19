return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	event = "VimEnter",
	config = function()
		require("neo-tree").setup({
			close_if_last_window = false, -- if true, closes nvim when alpha is last window
			window = { position = "left", width = 30 },
		})

		vim.keymap.set("n", "<C-n>", function()
			local manager = require("neo-tree.sources.manager")
			local renderer = require("neo-tree.ui.renderer")
			local state = manager.get_state("filesystem")
			if state and renderer.window_exists(state) then
				vim.cmd("Neotree close")
			else
				vim.cmd("Neotree filesystem reveal left")
			end
		end, { silent = true })

		-- Only auto-open neo-tree when opening a file, not on dashboard
		vim.api.nvim_create_autocmd("BufEnter", {
			once = true,
			callback = function()
				local buf = vim.api.nvim_get_current_buf()
				local ft = vim.bo[buf].filetype
				local name = vim.api.nvim_buf_get_name(buf)

				-- Don't open on alpha/dashboard or empty buffers
				if ft == "alpha" or ft == "dashboard" or name == "" then
					return
				end

				vim.cmd("Neotree show")
				vim.cmd("wincmd p")
			end,
		})
	end,
}

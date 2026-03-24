return {
	{
		"lewis6991/gitsigns.nvim",
		lazy = true,
		event = "BufReadPost",
		keys = {
			{ "]c", "<cmd>Gitsigns next_hunk<CR>", desc = "Next hunk" },
			{ "[c", "<cmd>Gitsigns prev_hunk<CR>", desc = "Prev hunk" },
			{ "<leader>gb", "<cmd>Gitsigns blame_line<CR>", desc = "Blame line" },
			{ "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview hunk" },
			{ "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reset hunk" },
			{ "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", desc = "Stage hunk" },
			{ "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", desc = "Undo stage hunk" },
			{ "<leader>gtb", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle blame" },
		},
		opts = {
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			current_line_blame = false,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 500,
			},
		},
	},
	{
		"tpope/vim-fugitive",
		lazy = true,
		cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
	},
	{
		"sindrets/diffview.nvim",
		lazy = true,
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diff open" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "File history" },
			{ "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", desc = "Current file history" },
			{ "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "Diff close" },
		},
		opts = {
			enhanced_diff_hl = true,
		},
	},
}

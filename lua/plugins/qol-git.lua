return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 500,
        },
      })
      -- keymaps
      vim.keymap.set('n', ']c', ':Gitsigns next_hunk<CR>')
      vim.keymap.set('n', '[c', ':Gitsigns prev_hunk<CR>')
      vim.keymap.set('n', '<leader>gb', ':Gitsigns blame_line<CR>')
      vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>')
      vim.keymap.set('n', '<leader>gr', ':Gitsigns reset_hunk<CR>')
      vim.keymap.set('n', '<leader>gs', ':Gitsigns stage_hunk<CR>')
      vim.keymap.set('n', '<leader>gu', ':Gitsigns undo_stage_hunk<CR>')
      vim.keymap.set('n', '<leader>gtb', ':Gitsigns toggle_current_line_blame<CR>')
    end
  },
  {
    "tpope/vim-fugitive"
  },
  {
    "sindrets/diffview.nvim",
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
      })
      -- keymaps
      vim.keymap.set('n', '<leader>gd', ':DiffviewOpen<CR>')
      vim.keymap.set('n', '<leader>gh', ':DiffviewFileHistory<CR>')
      vim.keymap.set('n', '<leader>gf', ':DiffviewFileHistory %<CR>')
      vim.keymap.set('n', '<leader>gc', ':DiffviewClose<CR>')
    end
  }
}

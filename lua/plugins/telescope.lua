return {
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    lazy = true,
    cmd = { "Telescope" },
    keys = {
      { '<C-p>',      '<cmd>Telescope find_files<cr>',  desc = 'Find Files' },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>',   desc = 'Live Grep' },
    },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()

    end
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    lazy = true,
    event = "VeryLazy",                             -- load after startup
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
          }
        }
      })
      require("telescope").load_extension("ui-select")
    end
  }
}

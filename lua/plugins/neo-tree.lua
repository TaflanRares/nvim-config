return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  config = function()
    local neotree = require("neo-tree")
    neotree.setup({
      close_if_last_window = true,
      window = { position = "left", width = 30, },
    })

    vim.keymap.set('n', '<C-n>', function()
      local manager = require("neo-tree.sources.manager")
      local renderer = require("neo-tree.ui.renderer")
      local state = manager.get_state("filesystem")
      if state and renderer.window_exists(state) then
        vim.cmd("Neotree close")
      else
        vim.cmd("Neotree filesystem reveal left")
      end
    end, { silent = true })

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        vim.cmd("Neotree show")
        if vim.fn.argc() > 0 then
          vim.cmd("wincmd p")
        end
      end
    })
  end
}

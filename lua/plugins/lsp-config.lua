local langs = { "lua_ls", "rust_analyzer", "clangd" }
return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "mason-org/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = langs
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.set_log_level("ERROR")
      local servers = langs
      vim.lsp.enable(servers)

      -- keymaps
      local bufopts = { noremap=true, silent=true }
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set({'n','v'}, '<leader>ca', vim.lsp.buf.code_action, bufopts)
      vim.keymap.set('n', '<C-e>', function()
        vim.diagnostic.open_float({ scope = "buffer" })
      end, bufopts)
      vim.keymap.set('i', '<C-e>', function()
        vim.diagnostic.open_float({ scope = "line" })
      end, bufopts)
    end
  }
}


return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      local ibl = require("ibl")
      ibl.setup({
        indent = {
          char = "┊",
          highlight = { "IblIndent" },
        },
        scope = {
          char = "▏",  -- Slightly thicker for current scope
          highlight = { "IblScope" },
        },
      })
    end
  }
}

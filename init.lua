local config_root = vim.fn.stdpath("config")
vim.opt.rtp:prepend(config_root)
package.path = package.path .. ";" .. config_root .. "/lua/?.lua;" .. config_root .. "/lua/?/init.lua"

local modules = {
  "config.general",
  "config.keymaps",
  "config.terminal",
  "config.statusline",
  "config.dashboard",
  "config.lsp",
}

for _, module in ipairs(modules) do
  local ok, err = pcall(require, module)
  if not ok then
    vim.notify(("Failed to load %s: %s"):format(module, err), vim.log.levels.ERROR)
  end
end

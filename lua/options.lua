vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.opt.number = true
vim.opt.wrap = false
vim.opt.linebreak = false
vim.opt.breakindent = false
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.clipboard = "unnamedplus"
vim.opt.background = "dark"

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    vim.cmd("silent !cls")
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      vim.cmd("Alpha")
    end
  end,
})

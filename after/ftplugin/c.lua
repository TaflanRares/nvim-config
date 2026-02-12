vim.opt_local.makeprg = 'gcc "%" -o "%:r.exe" && "%:r.exe"'
vim.keymap.set('n', '<F5>', '<cmd>!gcc "%" -o "%:r.exe" && "%:r.exe"<CR>')

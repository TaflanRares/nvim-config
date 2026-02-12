vim.opt_local.makeprg = 'g++ "%" -o "%:r.exe" && "%:r.exe"'
vim.keymap.set('n', '<F5>', '<cmd>!g++ "%" -o "%:r.exe" && "%:r.exe"<CR>')

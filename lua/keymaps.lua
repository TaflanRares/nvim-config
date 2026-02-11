local keymap = vim.keymap

--TODO: improve keymap layout

keymap.set('i', '<C-u>', '<Esc>u a', { silent = true, noremap = true })

keymap.set('n', '<leader>w', '<C-w>w', { silent = true, noremap = true })
keymap.set('n', '<leader><Up>', '<C-w>k', { silent = true, noremap = true })
keymap.set('n', '<leader><Left>', '<C-w>h', { silent = true, noremap = true })
keymap.set('n', '<leader><Down>', '<C-w>j', { silent = true, noremap = true })
keymap.set('n', '<leader><Right>', '<C-w>l', { silent = true, noremap = true })

keymap.set('i', '<leader>x', '<C-x><C-l>', { silent = true })
keymap.set('v', '<C-c>', '"+y', { noremap = true, silent = true })

keymap.set({ 'n', 'v' }, '<C-v>', '"+p', { noremap = true, silent = true })
keymap.set('i', '<C-v>', '<C-r>+', { noremap = true, silent = true })
keymap.set({ 'n', 'i' }, '<C-a>', function()
  vim.cmd('normal! ggVG')
end, { noremap = true, silent = true })
keymap.set({ 'n', 'i', 'v' }, '<C-s>', function()
  vim.cmd('write')
end, { noremap = true, silent = true })

vim.keymap.set('i', '<C-H>', '<C-w>', { noremap = true })
keymap.set('n', '<C-z>', 'u', { silent = true, noremap = true })
keymap.set('i', '<C-z>', '<C-o>u', { silent = true, noremap = true })

vim.keymap.set("n", "<leader>cd", function()
  vim.cmd("cd %:p:h")
  require("neo-tree.command").execute({ action = "refresh" })
end)


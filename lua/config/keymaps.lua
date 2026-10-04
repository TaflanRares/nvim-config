vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map("n", "<C-a>", "ggVG", { desc = "Select all" })
map("v", "<C-a>", "<Esc>ggVG", { desc = "Select all" })
map("i", "<C-a>", "<Esc>ggVG", { desc = "Select all" })
map("i", "<C-p>", "<C-r>+", { desc = "Paste from system clipboard" })
map("n", "Y", "y$", { desc = "Yank to end of line" })
map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
map("n", "<C-j>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-k>", "<C-u>zz", { desc = "Half page up (centered)" })

map({ "n", "x" }, "d", '"_d', { desc = "Delete without yanking" })
map("n", "D", '"_D', { desc = "Delete to EOL without yanking" })
map({ "n", "x" }, "c", '"_c', { desc = "Change without yanking" })
map("n", "C", '"_C', { desc = "Change to EOL without yanking" })
map({ "n", "x" }, "x", '"_x', { desc = "Delete char without yanking" })
map("n", "X", '"_X', { desc = "Delete char back without yanking" })
map({ "n", "x" }, "s", '"_s', { desc = "Substitute without yanking" })
map("n", "S", '"_S', { desc = "Substitute line without yanking" })
map({ "n", "x" }, "<leader>d", "d", { desc = "Cut (delete and yank)" })
map("x", "p", "P", { desc = "Paste without yanking replaced text" })

map("n", "<leader><Left>", "<C-w>h", { desc = "Move to left window" })
map("n", "<leader><Down>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<leader><Up>", "<C-w>k", { desc = "Move to top window" })
map("n", "<leader><Right>", "<C-w>l", { desc = "Move to right window" })

map("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })

map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

map("n", "<leader>ff", ":find ", { desc = "Find file" })

map("n", "<leader>fg", function()
  require("telescope.builtin").live_grep()
end, { desc = "Live grep" })

map("n", "<leader>fb", function()
  require("telescope.builtin").buffers()
end, { desc = "Find Buffers" })

map("n", "<leader>bc", function()
  require("config.buffer").clean_empty_bufs()
end, { desc = "Clean empty buffers" })

map("n", "<leader>cd", function()
  local file = vim.api.nvim_buf_get_name(0)

  if file == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end

  local dir = vim.fn.fnamemodify(file, ":p:h")
  vim.cmd("lcd " .. vim.fn.fnameescape(dir))
  vim.notify("Directory: " .. dir)
end, { desc = "Change directory to current file" })

map("n", "<leader>pa", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("file:", path)
end)

local map = vim.keymap.set
local WARN, ERR = vim.log.levels.WARN, vim.log.levels.ERROR

-- Settings
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 0
vim.g.netrw_winsize = 15
vim.g.netrw_altv = 1
vim.g.netrw_hide = 0
-- vim.g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]
vim.g.netrw_keepdir = 1
vim.g.netrw_browse_split = 0

-- Open / toggle
map("n", "<leader>e", function()
  vim.g.netrw_chgwin = -1
  vim.cmd("Explore")
end, { desc = "Open file explorer" })

map("n", "<leader>le", "<cmd>Lexplore<cr>", { desc = "Toggle sidebar explorer" })

-- Fixes Lexplore error when the original window is closed
vim.api.nvim_create_autocmd("WinClosed", {
  group = vim.api.nvim_create_augroup("NetrwChgwinReset", { clear = true }),
  callback = function()
    vim.schedule(function()
      local w = vim.g.netrw_chgwin
      if w and w > vim.fn.winnr("$") then
        vim.g.netrw_chgwin = -1
      end
    end)
  end,
})

-- Helpers
local function marked()
  if vim.fn.exists("*netrw#Expose") == 0 then return {} end
  local list = vim.fn["netrw#Expose"]("netrwmarkfilelist")
  return type(list) == "table" and list or {}
end

local function under_cursor()
  if vim.fn.exists("*netrw#Call") == 0 then return nil end
  local word = vim.fn["netrw#Call"]("NetrwGetWord")
  return vim.fn["netrw#Call"]("NetrwFile", word)
end

-- Selecting marked files or cursor
local function selection()
  local files = marked()
  if #files == 0 then
    local f = under_cursor()
    files = f and { f } or {}
  end
  return files
end

local function run(cmd)
  local res = vim.system(cmd):wait()
  return res.code == 0, vim.trim(res.stderr or "")
end

local function finish()
  vim.cmd("silent! normal mF") -- unmark
  vim.cmd.normal(vim.api.nvim_replace_termcodes("<C-l>", true, false, true)) -- refresh
end

local function wipe_buf(path)
  local b = vim.fn.bufnr(path)
  if b ~= -1 then pcall(vim.api.nvim_buf_delete, b, { force = true }) end
end

-- Clipboard
local clip = { paths = {}, op = nil }
local stash_root = vim.fn.stdpath("state") .. "/netrw-stash"

local function yank()
  local files = selection()
  if #files == 0 then return end
  clip = { paths = files, op = "copy" }
  vim.notify(("Yanked %d item(s)"):format(#files))
  finish()
end

-- Yank and delete
local function cut()
  local files = selection()
  if #files == 0 then return end
  local dir = ("%s/%s-%d"):format(stash_root, os.date("%Y%m%d-%H%M%S"), vim.uv.hrtime() % 100000)
  vim.fn.mkdir(dir, "p")
  local staged = {}
  for _, src in ipairs(files) do
    local dst = dir .. "/" .. vim.fs.basename(src)
    local ok, err = run({ "mv", "--", src, dst })
    if ok then
      staged[#staged + 1] = dst
      wipe_buf(src)
    else
      vim.notify("cut failed: " .. err, ERR)
    end
  end
  clip = { paths = staged, op = "move" }
  vim.notify(("Cut %d item(s), stashed in %s"):format(#staged, dir))
  finish()
end

local function paste()
  if #clip.paths == 0 then return vim.notify("Clipboard empty", WARN) end
  local dir, left = vim.b.netrw_curdir, {}
  for _, src in ipairs(clip.paths) do
    local dst = dir .. "/" .. vim.fs.basename(src)
    if vim.uv.fs_stat(dst) then
      vim.notify("Skipped, already exists: " .. dst, WARN)
      left[#left + 1] = src
    else
      local cmd = clip.op == "copy" and { "cp", "-r", "--", src, dst } or { "mv", "--", src, dst }
      local ok, err = run(cmd)
      if not ok then
        vim.notify(clip.op .. " failed: " .. err, ERR)
        left[#left + 1] = src
      end
    end
  end
  if clip.op == "move" then clip.paths = left end
  finish()
end

-- File operations
local function delete()
  local files = selection()
  if #files == 0 then return end
  local names = table.concat(vim.tbl_map(vim.fs.basename, files), "\n")
  if vim.fn.confirm("Delete permanently?\n" .. names, "&Yes\n&No", 2) ~= 1 then return end
  for _, f in ipairs(files) do
    local ok, err = run({ "rm", "-rf", "--", f })
    if not ok then vim.notify("delete failed: " .. err, ERR) end
    wipe_buf(f)
  end
  finish()
end

local function rename()
  local old = under_cursor()
  if not old then return end
  local new = vim.fn.input("New name: ", vim.fs.basename(old))
  if new == "" then return end
  local dst = vim.fs.dirname(old) .. "/" .. new
  if vim.uv.fs_stat(dst) then return vim.notify("Already exists: " .. dst, WARN) end
  local ok, err = run({ "mv", "--", old, dst })
  if not ok then vim.notify("rename failed: " .. err, ERR) end
  finish()
end

-- Buffer-local keymaps
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  group = vim.api.nvim_create_augroup("NetrwMaps", { clear = true }),
  callback = function(ev)
    local function m(lhs, rhs, desc)
      map("n", lhs, rhs, { buffer = ev.buf, silent = true, remap = true, desc = desc })
    end

    -- navigation
    for _, k in ipairs({ "h", "<Left>" }) do m(k, "-", "Up a directory") end
    for _, k in ipairs({ "l", "<Right>" }) do m(k, "<CR>", "Enter / open") end

    -- marks, clipboard, operations
    m("v", "mf", "Mark file")
    m("y", yank, "Yank (copy on paste)")
    m("X", cut, "Cut into stash (move on paste)")
    m("p", paste, "Paste here")
    m("D", delete, "Delete permanently")
    m("r", rename, "Rename")
  end,
})

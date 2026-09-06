local M = {}

local cached_branch = ""
local last_check = 0

local function git_branch()
  local now = vim.loop.now()

  if now - last_check > 5000 then
    cached_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
    last_check = now
  end

  if cached_branch ~= "" then
    return "  " .. cached_branch .. " "
  end

  return ""
end

local function file_type()
  local ft = vim.bo.filetype

  local icons = {
    lua = " ", python = " ", javascript = " ", typescript = " ", javascriptreact = " ", typescriptreact = " ", html = " ", css = " ", scss = " ", json = " ", markdown = " ", vim = " ", sh = " ", bash = " ", zsh = " ", rust = " ", go = " ", c = " ", cpp = " ", java = " ", php = " ", ruby = " ", swift = " ", kotlin = " ", dart = " ", elixir = " ", haskell = " ", sql = " ", yaml = " ", toml = " ", xml = " ", dockerfile = " ", gitcommit = " ", gitconfig = " ", vue = " ", svelte = " ", astro = " ",
  }

  if ft == "" then
    return "  "
  end

  return icons[ft] or ("  " .. ft)
end

local function file_size()
  local size = vim.fn.getfsize(vim.fn.expand("%"))

  if size < 0 then
    return ""
  end

  local size_str
  if size < 1024 then
    size_str = size .. "B"
  elseif size < 1024 * 1024 then
    size_str = string.format("%.1fK", size / 1024)
  else
    size_str = string.format("%.1fM", size / 1024 / 1024)
  end

  return "  " .. size_str .. " "
end

local function mode_icon()
  local mode = vim.fn.mode()

  local modes = {
    n = "  NORMAL ",
    no = "  NORMAL ",
    nov = "  NORMAL ",
    noV = "  NORMAL ",
    ["no\22"] = "  NORMAL ",
    i = "  INSERT ",
    ic = "  INSERT ",
    ix = "  INSERT ",
    v = "  VISUAL ",
    V = "  V-LINE ",
    ["\22"] = "  V-BLOCK ",
    c = "  COMMAND ",
    R = "  REPLACE ",
    Rc = "  REPLACE ",
    Rv = "  REPLACE ",
    s = "  SELECT ",
    S = "  S-LINE ",
    ["\19"] = "  S-BLOCK ",
    t = "  TERMINAL ",
  }

  return modes[mode] or ("  " .. mode:upper() .. " ")
end

local function mode_highlight()
  local mode = vim.fn.mode()

  if mode == "n" or mode == "no" or mode == "nov" or mode == "noV" or mode == "no\22" then
    return "StatusModeNormal"
  elseif mode == "i" or mode == "ic" or mode == "ix" then
    return "StatusModeInsert"
  elseif mode == "v" or mode == "V" or mode == "\22" then
    return "StatusModeVisual"
  elseif mode == "R" or mode == "Rc" or mode == "Rv" then
    return "StatusModeReplace"
  elseif mode == "c" then
    return "StatusModeCommand"
  elseif mode == "t" then
    return "StatusModeTerminal"
  elseif mode == "s" or mode == "S" or mode == "\19" then
    return "StatusModeVisual"
  end

  return "StatusModeNormal"
end

vim.api.nvim_set_hl(0, "StatusModeNormal", { fg = "#000000", bg = "#a6e3a1", bold = true })
vim.api.nvim_set_hl(0, "StatusModeInsert", { fg = "#000000", bg = "#89b4fa", bold = true })
vim.api.nvim_set_hl(0, "StatusModeVisual", { fg = "#000000", bg = "#cba6f7", bold = true })
vim.api.nvim_set_hl(0, "StatusModeReplace", { fg = "#000000", bg = "#f38ba8", bold = true })
vim.api.nvim_set_hl(0, "StatusModeCommand", { fg = "#000000", bg = "#f9e2af", bold = true })
vim.api.nvim_set_hl(0, "StatusModeTerminal", { fg = "#000000", bg = "#fab387", bold = true })

_G.mode_icon = mode_icon
_G.mode_highlight = mode_highlight
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size

local augroup = vim.api.nvim_create_augroup("UserStatusline", { clear = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = augroup,
  callback = function()
    vim.opt_local.statusline = table.concat({
      " ",
      "%#%{v:lua.mode_highlight()}#",
      "%{v:lua.mode_icon()}",
      "%#StatusLine#",
      " %f %h%m%r ",
      "%{v:lua.git_branch()}",
      " ",
      "%{v:lua.file_type()}",
      " ",
      "%{v:lua.file_size()}",
      "%=",
      "  %l:%c  %P ",
    })
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = augroup,
  callback = function()
    vim.opt_local.statusline = "  %f %h%m%r  %{v:lua.file_type()} %=  %l:%c   %P "
  end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
  group = augroup,
  callback = function()
    vim.cmd("redrawstatus")
  end,
})

return M

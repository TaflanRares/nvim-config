-- ============================================================================
-- NEOVIM CONFIG
-- ============================================================================

-- Theme & transparency
vim.cmd.colorscheme("unokai")
vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
vim.api.nvim_set_hl(0, "NormalNC", {bg = "none"})
vim.api.nvim_set_hl(0, "EndOfBuffer", {bg = "none"})
vim.api.nvim_set_hl(0, "Visual", { bg = "#0b2818" })

-- Visuals
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.showmatch = true
vim.opt.cmdheight = 1
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.showmode = false
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 0
vim.opt.lazyredraw = true
vim.opt.fillchars = { eob = " " }

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8

-- Indent
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Search
vim.opt.ignorecase = true  -- normally case insensitive
vim.opt.smartcase  = true  -- case sensitive if upparcase in search
vim.opt.incsearch  = true  -- show matches as you type

-- Files
local undodirPath = vim.fn.expand("~/.nvim/undodir")
if vim.fn.isdirectory(undodirPath) == 0 then
  vim.fn.mkdir(undodirPath, "p")
end

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = undodirPath
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0
vim.opt.autoread = true
vim.opt.autowrite = false

-- Behaviour
vim.opt.backspace = "indent,eol,start"
vim.opt.autochdir = false
vim.opt.iskeyword:append("-")
vim.opt.path:append("**")
vim.opt.clipboard:append("unnamedplus")

-- Cursor
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Split behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

-- ============================================================================
-- KEY MAP
-- ============================================================================

-- Misc
vim.g.mapleader = " "         -- leader
vim.g.maplocalleader = " "

vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })
vim.keymap.set("v", "<C-a>", "<Esc>ggVG", { desc = "Select all" })
vim.keymap.set("i", "<C-a>", "<Esc>ggVG", { desc = "Select all" })
vim.keymap.set('i', '<C-p>', '<C-r>+', { desc = "Paste from system clipboard" })
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

vim.keymap.set("n", "<C-j>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-k>", "<C-u>zz", { desc = "Half page up (centered)" })

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Better window navigation
vim.keymap.set("n", "<leader><Left>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<leader><Down>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<leader><Up>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<leader><Right>", "<C-w>l", { desc = "Move to right window" })

-- Splitting & Resizing
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
--vim.keymap.set("n", " ", ":resize +2<CR>", { desc = "Increase window height" })
--vim.keymap.set("n", " ", ":resize -2<CR>", { desc = "Decrease window height" })
--vim.keymap.set("n", " ", ":vertical resize -2<CR>", { desc = "Decrease window width" })
--vim.keymap.set("n", " ", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Quick file navigation
-- Open ntree in current dir
vim.keymap.set("n", "<leader>e", function()
  vim.cmd("cd " .. vim.fn.fnameescape(vim.fn.expand("%:p:h")))
  vim.cmd("Ntree")
end, { desc = "Open file explorer" })

vim.keymap.set("n", "<leader>ff", ":find ", { desc = "Find file" })

-- Change dir to current file
vim.keymap.set("n", "<leader>cd", function()
  local file = vim.api.nvim_buf_get_name(0)

  if file == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end

  local dir = vim.fn.fnamemodify(file, ":p:h")
  vim.cmd("lcd " .. vim.fn.fnameescape(dir))

  vim.notify("Directory: " .. dir)
end, {
  desc = "Change directory to current file",
})

-- ============================================================================
-- USEFUL FUNCTIONS
-- ============================================================================

-- Copy Full File-Path
vim.keymap.set("n", "<leader>pa", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end)

-- Basic autocommands
local augroup = vim.api.nvim_create_augroup("UserConfig", {})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    local line = mark[1]
    local ft = vim.bo.filetype
    if line > 0 and line <= lcount
      and vim.fn.index({ "commit", "gitrebase", "xxd" }, ft) == -1
      and not vim.o.diff then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Command-line completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- Better diff options
vim.opt.diffopt:append("linematch:60")

-- Performance improvements
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

-- ============================================================================
-- FLOATING TERMINAL
-- ============================================================================

-- terminal
local terminal_state = {
  buf = nil,
  win = nil,
  is_open = false
}

local function FloatingTerminal()
  -- If terminal is already open, close it (toggle behavior)
  if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
    return
  end

  -- Create buffer if it doesn't exist or is invalid
  if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
    terminal_state.buf = vim.api.nvim_create_buf(false, true)
    -- Set buffer options for better terminal experience
    vim.bo[terminal_state.buf].bufhidden = 'hide'
  end

  -- Calculate window dimensions
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create the floating window
  terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'single',
  })

  -- Set transparency for the floating window
  vim.wo[terminal_state.win].winblend = 0
  vim.wo[terminal_state.win].winhighlight = 'Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder'

  -- Define highlight groups for transparency
  vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none", })

  -- Start terminal if not already running
  local has_terminal = false
  local lines = vim.api.nvim_buf_get_lines(terminal_state.buf, 0, -1, false)
  for _, line in ipairs(lines) do
    if line ~= "" then
      has_terminal = true
      break
    end
  end

  if not has_terminal then
    vim.fn.termopen(os.getenv("SHELL"))
  end

  terminal_state.is_open = true
  vim.cmd("startinsert")

  -- Set up auto-close on buffer leave 
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = terminal_state.buf,
    callback = function()
      if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
        vim.api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
      end
    end,
    once = true
  })
end

-- Function to explicitly close the terminal
local function CloseFloatingTerminal()
  if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
  end
end

-- Key mappings
vim.keymap.set("n", "<leader>t", FloatingTerminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
vim.keymap.set("t", "<Esc>", CloseFloatingTerminal, { noremap = true, silent = true, desc = "Close floating terminal from terminal mode" })

-- ============================================================================
-- STATUSLINE
-- ============================================================================

-- Git branch function with caching
local cached_branch = ""
local last_check = 0

local function git_branch()
  local now = vim.loop.now()

  if now - last_check > 5000 then
    cached_branch = vim.fn.system(
      "git branch --show-current 2>/dev/null | tr -d '\\n'"
    )
    last_check = now
  end

  if cached_branch ~= "" then
    return "  " .. cached_branch .. " "
  end

  return ""
end


-- File type with Nerd Font icon
local function file_type()
  local ft = vim.bo.filetype

  local icons = {
    lua = "\u{e620} ",           -- nf-dev-lua
    python = "\u{e73c} ",        -- nf-dev-python
    javascript = "\u{e74e} ",    -- nf-dev-javascript
    typescript = "\u{e628} ",    -- nf-dev-typescript
    javascriptreact = "\u{e7ba} ",
    typescriptreact = "\u{e7ba} ",
    html = "\u{e736} ",          -- nf-dev-html5
    css = "\u{e749} ",           -- nf-dev-css3
    scss = "\u{e749} ",
    json = "\u{e60b} ",          -- nf-dev-json
    markdown = "\u{e73e} ",      -- nf-dev-markdown
    vim = "\u{e62b} ",           -- nf-dev-vim
    sh = "\u{f489} ",            -- nf-oct-terminal
    bash = "\u{f489} ",
    zsh = "\u{f489} ",
    rust = "\u{e7a8} ",          -- nf-dev-rust
    go = "\u{e724} ",            -- nf-dev-go
    c = "\u{e61e} ",             -- nf-dev-c
    cpp = "\u{e61d} ",           -- nf-dev-cplusplus
    java = "\u{e738} ",          -- nf-dev-java
    php = "\u{e73d} ",           -- nf-dev-php
    ruby = "\u{e739} ",          -- nf-dev-ruby
    swift = "\u{e755} ",         -- nf-dev-swift
    kotlin = "\u{e634} ",
    dart = "\u{e798} ",
    elixir = "\u{e62d} ",
    haskell = "\u{e777} ",
    sql = "\u{e706} ",
    yaml = "\u{f481} ",
    toml = "\u{e615} ",
    xml = "\u{f05c} ",
    dockerfile = "\u{f308} ",    -- nf-linux-docker
    gitcommit = "\u{f418} ",     -- nf-oct-git_commit
    gitconfig = "\u{f1d3} ",     -- nf-fa-git
    vue = "\u{fd42} ",           -- nf-md-vuejs
    svelte = "\u{e697} ",
    astro = "\u{e628} ",
  }

  if ft == "" then
    return "  "
  end

  return icons[ft] or ("  " .. ft)
end


-- File size
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


-- Mode text
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


-- Mode highlight
local function mode_highlight()
  local mode = vim.fn.mode()

  if mode == "n"
    or mode == "no"
    or mode == "nov"
    or mode == "noV"
    or mode == "no\22"
  then
    return "StatusModeNormal"

  elseif mode == "i"
    or mode == "ic"
    or mode == "ix"
  then
    return "StatusModeInsert"

  elseif mode == "v"
    or mode == "V"
    or mode == "\22"
  then
    return "StatusModeVisual"

  elseif mode == "R"
    or mode == "Rc"
    or mode == "Rv"
  then
    return "StatusModeReplace"

  elseif mode == "c" then
    return "StatusModeCommand"

  elseif mode == "t" then
    return "StatusModeTerminal"

  elseif mode == "s"
    or mode == "S"
    or mode == "\19"
  then
    return "StatusModeVisual"
  end

  return "StatusModeNormal"
end


-- Highlight groups
vim.api.nvim_set_hl(0, "StatusModeNormal", {
  fg = "#000000",
  bg = "#a6e3a1",
  bold = true,
})

vim.api.nvim_set_hl(0, "StatusModeInsert", {
  fg = "#000000",
  bg = "#89b4fa",
  bold = true,
})

vim.api.nvim_set_hl(0, "StatusModeVisual", {
  fg = "#000000",
  bg = "#cba6f7",
  bold = true,
})

vim.api.nvim_set_hl(0, "StatusModeReplace", {
  fg = "#000000",
  bg = "#f38ba8",
  bold = true,
})

vim.api.nvim_set_hl(0, "StatusModeCommand", {
  fg = "#000000",
  bg = "#f9e2af",
  bold = true,
})

vim.api.nvim_set_hl(0, "StatusModeTerminal", {
  fg = "#000000",
  bg = "#fab387",
  bold = true,
})

-- Make functions accessible from the statusline
_G.mode_icon = mode_icon
_G.mode_highlight = mode_highlight
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size

-- Active statusline
local function setup_dynamic_statusline()
  vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = augroup,

    callback = function()
      vim.opt_local.statusline = table.concat({
        " ",

        -- Mode
        "%#%{v:lua.mode_highlight()}#",
        "%{v:lua.mode_icon()}",

        -- Reset highlight
        "%#StatusLine#",

        -- File
        " %f %h%m%r ",

        -- Git branch
        "%{v:lua.git_branch()}",

        -- Separator
        " ",

        -- File type
        "%{v:lua.file_type()}",

        -- Separator
        " ",

        -- File size
        "%{v:lua.file_size()}",

        -- Push remaining content to right
        "%=",

        -- Position
        "  %l:%c  %P ",
      })
    end,
  })

  -- Inactive window statusline
  vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = augroup,

    callback = function()
      vim.opt_local.statusline =
        "  %f %h%m%r  %{v:lua.file_type()} %=  %l:%c   %P "
    end,
  })
end

setup_dynamic_statusline()

-- Update statusline immediately when changing modes
vim.api.nvim_create_autocmd("ModeChanged", {
  group = augroup,

  callback = function()
    vim.cmd("redrawstatus")
  end,
})

-- ============================================================================
-- DASHBOARD / STARTUP SCREEN — borderless, gradient Saturn, two-column layout
-- ============================================================================

local dashboard_augroup = vim.api.nvim_create_augroup("Dashboard", { clear = true })

-- Horizontal offset: Increase to push the dashboard further right
local OFFSET_X = 62

-- ---------------------------------------------------------------------------
-- Palette (Catppuccin Mocha)
-- ---------------------------------------------------------------------------
local palette = {
  peach    = "#fab387",
  sapphire = "#74c7ec",
  mauve    = "#cba6f7",
  blue     = "#89b4fa",
  green    = "#a6e3a1",
  text     = "#cdd6f4",
  subtext  = "#a6adc8",
  surface2 = "#585b70",
}

-- ---------------------------------------------------------------------------
-- Tiny color-interpolation helper -> gives the Saturn art a smooth gradient
-- ---------------------------------------------------------------------------
local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

local function lerp(a, b, t)
  return math.floor(a + (b - a) * t + 0.5)
end

local function gradient_hex(hex_a, hex_b, t)
  local r1, g1, b1 = hex_to_rgb(hex_a)
  local r2, g2, b2 = hex_to_rgb(hex_b)
  return string.format("#%02x%02x%02x", lerp(r1, r2, t), lerp(g1, g2, t), lerp(b1, b2, t))
end

-- Static highlight groups
vim.api.nvim_set_hl(0, "DashTitle", { fg = palette.blue, bold = true })
vim.api.nvim_set_hl(0, "DashKey", { fg = palette.green, bold = true })
vim.api.nvim_set_hl(0, "DashText", { fg = palette.text })
vim.api.nvim_set_hl(0, "DashDim", { fg = palette.subtext, italic = true })
vim.api.nvim_set_hl(0, "DashDivider", { fg = palette.surface2 })

-- ---------------------------------------------------------------------------
-- Saturn ASCII art
-- ---------------------------------------------------------------------------
local saturn_ascii = {
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⢞⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⣀⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣦⣀⣠⠞⠁⢸⢀⠙⢦⡀⠀⠀⠀⣠⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⡀⠀]],
  [[⠀⠀⠀⠀⢰⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣿⣧⢀⠴⢃⠓⣌⠠⠙⢦⡀⣾⡟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣉⣻⡆]],
  [[⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣸⣿⠄⢣⡉⠖⡄⢓⢅⠂⡙⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⣿⡇]],
  [[⠀⠀⠀⠀⢸⣇⠐⡤⢀⢤⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⣀⢀⠠⣊⣼⣿⠘⣄⠚⢤⠉⡖⡨⢑⣄⢿⣇⠀⣀⢀⢠⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡘⣰⣿⠇]],
  [[⠀⠀⠀⠀⠀⠙⠿⠿⣿⡅⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡘⢤⣿⡿⠿⢟⠡⣊⠤⣉⠆⢣⠔⡡⢣⠄⡙⢿⢿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠘⣤⣾⠟⠁⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⣿⠆⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡘⠴⣿⡧⢉⠆⡱⡐⢢⠡⠚⡄⢎⡑⢢⠑⣌⣶⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡐⢤⣿⠟⠁⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⣿⠇⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡘⡔⣿⣇⠣⣘⠡⠜⡡⢊⠕⡨⢂⠜⣠⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⣡⣼⠿⠁⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⡌⣿⣇⠒⢤⡉⣒⠡⢃⠜⡠⣃⣾⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣡⣾⠿⠉⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⣿⠇⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⡌⣿⡧⢉⠆⠴⡁⢎⠰⣨⣶⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⣡⣾⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⣿⠇⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⡌⣿⣇⠣⣘⠡⡘⣤⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⣑⣾⡿⣏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⡌⣿⡧⠑⡄⣣⣾⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢊⣴⣿⠛⣄⠈⠳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⣠⣿⠇⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢱⡘⣿⣇⣣⣾⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢊⣴⣿⠟⣠⠙⣄⠓⣅⠈⠳⣄⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⣠⠞⠁⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢢⠱⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢊⣴⣿⠟⢡⡘⠤⡩⢐⡐⠓⣅⠈⠳⣄⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⣠⠞⠁⢀⢼⣿⠆⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢢⢙⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢊⣴⣿⠟⡡⢊⠖⣈⠖⡡⢃⠆⣉⠖⡨⢑⢆⠈⠳⣄⠀⠀⠀]],
  [[⣠⠞⠁⢀⡴⢉⠼⣿⡃⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢂⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⢊⣴⣿⠟⡡⢊⡔⢣⠘⡄⠎⡔⡡⠚⡄⢎⡑⢣⢌⠱⢆⠈⠳⣄⠀]],
  [[⢾⣷⣶⣶⡁⡆⢇⢸⣿⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡎⠰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⢏⣿⡿⢁⠎⡁⢇⠸⣀⢉⢰⠉⡰⢁⠷⡈⢆⡸⢰⠈⠶⣈⣷⣶⣾⡷]],
  [[⠀⠙⢷⣭⢟⣮⡰⢸⣿⡅⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⢲⣵⡿⡋⢆⡩⢒⡉⢆⠱⢂⠥⢊⠴⣁⠣⢂⡍⠢⠔⡡⢊⣴⡿⣯⡿⠋⠀]],
  [[⠀⠀⠀⠙⢿⣶⡹⢮⣿⠆⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡶⠷⢾⣿⡏⢢⠱⢌⡰⢡⡘⢌⢒⡉⢆⣉⠒⠤⢃⠣⢌⠱⣈⣴⣿⣻⡿⠋⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠙⢿⣽⣿⡃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠃⠀⠀⢠⡿⡑⢢⢃⠲⢄⠣⣘⠰⢊⠔⡊⢤⠙⡌⡌⠱⣈⡶⣟⣿⡾⠋⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠙⣿⡅⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢹⣿⣤⣤⣤⡾⠗⣈⠦⡑⢪⢄⡓⠤⠓⡌⣒⡉⠦⡑⠰⣈⣵⡾⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣢⣼⣿⠟⣉⣍⠩⢔⠣⣌⢢⢑⠢⣌⠘⡌⢓⡘⢤⡘⢤⡁⣧⣿⢯⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⣿⡆⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢒⣾⣛⣛⠛⠛⠛⢛⣿⠃⣶⣟⣛⠛⠛⠛⠻⣮⣦⣼⡾⠛⠛⠛⢿⣿⣋⣠⡾⠛⠛⠛⠛⣧⡀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⣿⡆⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⢊⣴⣿⠟⣻⡟⠀⠀⠀⣾⡇⢡⠙⣿⡏⠀⠀⠀⠀⠈⠉⠉⠀⠀⠀⠀⠀⠉⠉⠉⠀⠀⠀⠀⠀⣾⠃⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢚⣤⣿⠟⡡⢺⣿⠀⠀⠀⣰⡟⢄⠣⣸⡿⠁⠀⢀⣾⠛⡟⣻⣿⡟⠀⠀⢠⡿⠛⠛⠛⣿⠃⠀⠀⣰⡏⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⣿⡆⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⢘⣰⣿⠟⣡⠚⢄⣿⠃⠀⠀⢀⣿⠃⡜⢠⣿⠇⠀⠀⣸⡟⣤⣿⣿⡿⠀⠀⠀⣾⠃⠀⠀⣰⡏⠀⠀⢀⣿⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⣿⡆⠐⠀⠀⠀⠀⠀⠀⠀⢀⢄⣱⣾⡿⢧⡘⡄⢃⣾⡏⠀⠀⠀⣾⡇⢸⢈⣼⡏⠀⠀⢰⣿⣾⣟⡿⣻⠇⠀⠀⢸⡏⠀⠀⢀⣿⠀⠀⠀⣼⠃⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⣿⠆⠠⠀⠀⠀⠀⠀⢀⠔⣡⣾⠟♙⢿⣳⡝⢮⣰⡿⠀⠀⠀⣰⡟⡄⢣⢸⡿⠀⠀⠀⣾⣿⡿⠋⢰⡟⠀⠀⢠⡿⠀⠀⠀⣼⠃⠀⠀⢠⡟⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠻⣇⠐⡠⢄⠠⠠⢔⣡⣾⠟⠁⠀⠀⠀⠙⢿⣧⣿⢃⡀⣀⢀⡛⣿⡧⢡⣿⣃⣀⣀⣸⣻⡏⠀⠀⣾⣁⣀⣀⣜⣿⠆⠀⢠⣟⣀⣀⣀⣛⣿⠆⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠛⠛⠛⠛⠛⠛⠁⠀⠀⠀⠀⠀⠀⠀⠙⢿⣟⢿⣻⠛⡛⢛⠡⢂⣽⡿⣿⡿⠋⠉⠀⠀⠀⠉⠉⠉⠉⠉⠉⠀⠀⠈⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⣽⣹⢬⡂⣱⣾⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⣧⢻⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
}

-- ---------------------------------------------------------------------------
-- Small helpers
-- ---------------------------------------------------------------------------
local function center_line(line, width)
  local len = vim.fn.strdisplaywidth(line)
  local pad = math.floor((width - len) / 2) + OFFSET_X
  if pad < 0 then pad = 0 end
  return string.rep(" ", pad) .. line
end

local function truncate(str, max_len)
  if vim.fn.strdisplaywidth(str) <= max_len then return str end
  return vim.fn.strcharpart(str, 0, max_len - 1) .. "…"
end

local function safe_require(mod)
  local ok, m = pcall(require, mod)
  if ok then return m end
  return nil
end

local function telescope_action(fn_name)
  return function()
    local builtin = safe_require("telescope.builtin")
    if builtin and builtin[fn_name] then
      builtin[fn_name]()
    else
      vim.notify("Telescope not available: " .. fn_name, vim.log.levels.WARN)
    end
  end
end

local function open_explorer()
  local oil = safe_require("oil")
  if oil then
    oil.open()
  else
    vim.cmd.Explore()
  end
end

local function get_stats_line()
  local parts = {}
  local v = vim.version()
  table.insert(parts, string.format("nvim %d.%d.%d", v.major, v.minor, v.patch))

  local lazy = safe_require("lazy")
  if lazy then
    local ok, stats = pcall(lazy.stats)
    if ok then
      local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
      table.insert(parts, string.format("%d/%d plugins", stats.loaded, stats.count))
      table.insert(parts, ms .. "ms")
    end
  end

  table.insert(parts, os.date("%a %d %b · %H:%M"))
  return table.concat(parts, "  ·  ")
end

-- ---------------------------------------------------------------------------
-- Count "ink" (non-blank braille cells) in a Saturn art line
-- ---------------------------------------------------------------------------
local function ink_count(line)
  local total = vim.fn.strchars(line)
  local _, blanks = line:gsub("⠀", "")
  return total - blanks
end

-- ---------------------------------------------------------------------------
-- Dashboard
-- ---------------------------------------------------------------------------
local function open_dashboard()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, buf)

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "dashboard"

  vim.wo[0].number = false
  vim.wo[0].relativenumber = false
  vim.wo[0].cursorline = false
  vim.wo[0].signcolumn = "no"
  vim.wo[0].colorcolumn = ""
  vim.wo[0].list = false
  vim.wo[0].wrap = false
  vim.wo[0].foldenable = false

  local win_width = vim.api.nvim_win_get_width(0)
  local win_height = vim.api.nvim_win_get_height(0)

  local action_keys = {}
  local colw = math.floor((math.min(win_width - 4, 66) - 4) / 2)

  local recent_entries = {}
  local recent_keys = { "1", "2", "3", "4", "5", "6" }
  local rcount = 0
  for _, file in ipairs(vim.v.oldfiles) do
    if rcount >= 6 then break end
    if vim.fn.filereadable(file) == 1 then
      rcount = rcount + 1
      local key = recent_keys[rcount]
      local name = vim.fn.fnamemodify(file, ":t")
      table.insert(recent_entries, { key = key, label = name })
      action_keys[key] = function() vim.cmd.edit(file) end
    end
  end

  local cwd = vim.fn.getcwd()
  local cwd_name = vim.fn.fnamemodify(cwd, ":t")
  local project_entries = {}
  local project_keys = { "a", "s", "d", "f", "g", "h" }
  local dir_handle = vim.loop.fs_opendir(cwd, nil, 50)
  local dir_files = {}
  if dir_handle then
    local entries = vim.loop.fs_readdir(dir_handle)
    if entries then
      for _, entry in ipairs(entries) do
        if entry.type == "file" and not entry.name:match("^%.") then
          table.insert(dir_files, entry.name)
        end
      end
    end
    vim.loop.fs_closedir(dir_handle)
  end
  local pcount = 0
  for _, fname in ipairs(dir_files) do
    if pcount >= 6 then break end
    pcount = pcount + 1
    local key = project_keys[pcount]
    table.insert(project_entries, { key = key, label = fname })
    action_keys[key] = function() vim.cmd.edit(cwd .. "/" .. fname) end
  end

  local row_count = math.max(#recent_entries, #project_entries, 1)

  local fixed_lines = 1 + 1 + 1 + 1 + 1 + 1 + 1 + row_count + 1 + 1 + 1 + 1

  local art_width = 0
  for _, l in ipairs(saturn_ascii) do
    art_width = math.max(art_width, vim.fn.strdisplaywidth(l))
  end
  local W = math.max(40, math.min(art_width, win_width - 4))

  local art_budget = win_height - fixed_lines - 1
  local art = {}
  for _, l in ipairs(saturn_ascii) do table.insert(art, l) end

  while #art > 0 and #art > art_budget do
    if ink_count(art[1]) <= ink_count(art[#art]) then
      table.remove(art, 1)
    else
      table.remove(art, #art)
    end
  end

  local lines = {}
  local total_content = #art + fixed_lines
  local top_pad = math.max(0, math.floor((win_height - total_content) / 2))
  for _ = 1, top_pad do table.insert(lines, "") end

  local saturn_start_idx = #lines
  for _, l in ipairs(art) do
    table.insert(lines, center_line(l, W))
  end

  table.insert(lines, "")
  table.insert(lines, center_line("N E O V I M", W))
  local title_idx = #lines - 1
  table.insert(lines, center_line(get_stats_line(), W))
  local stats_idx = #lines - 1
  table.insert(lines, "")

  local divider = string.rep("─", math.min(W, 60))
  table.insert(lines, center_line(divider, W))
  local divider1_idx = #lines - 1
  table.insert(lines, "")

  table.insert(lines, center_line(
    string.format("%-" .. colw .. "s  %s", "RECENT FILES", "PROJECT · " .. truncate(cwd_name, colw - 10)),
    W))
  local header_idx = #lines - 1

  for i = 1, row_count do
    local l, r = recent_entries[i], project_entries[i]
    local ltext = l and string.format("[%s] %s", l.key, truncate(l.label, colw - 5)) or ""
    local rtext = r and string.format("[%s] %s", r.key, truncate(r.label, colw - 5)) or ""
    if #recent_entries == 0 and i == 1 then ltext = "(no recent files)" end
    if #project_entries == 0 and i == 1 then rtext = "(no files here)" end
    ltext = ltext .. string.rep(" ", math.max(0, colw - vim.fn.strdisplaywidth(ltext)))
    table.insert(lines, center_line(ltext .. "  " .. rtext, W))
  end

  table.insert(lines, "")
  table.insert(lines, center_line(divider, W))
  local divider2_idx = #lines - 1
  table.insert(lines, "")

  table.insert(lines, center_line(
    "[n] New   [e] Explorer   [F] Find   [G] Grep   [R] Recent   [q] Quit", W))
  local footer_idx = #lines - 1

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.api.nvim_win_set_cursor(0, { 1, 0 })

  -- Highlight setup
  local ns = vim.api.nvim_create_namespace("dashboard_hl")

  local n_art_full = #saturn_ascii
  local trimmed_from_top = 0
  for i, l in ipairs(saturn_ascii) do
    if art[1] == l then trimmed_from_top = i - 1; break end
  end
  for i = 1, #art do
    local orig_i = i + trimmed_from_top
    local t = (orig_i - 1) / math.max(1, n_art_full - 1)
    local color
    if t < 0.5 then
      color = gradient_hex(palette.peach, palette.sapphire, t / 0.5)
    else
      color = gradient_hex(palette.sapphire, palette.mauve, (t - 0.5) / 0.5)
    end
    local grp = "DashSaturn" .. orig_i
    vim.api.nvim_set_hl(0, grp, { fg = color })
    vim.api.nvim_buf_add_highlight(buf, ns, grp, saturn_start_idx + i - 1, 0, -1)
  end

  vim.api.nvim_buf_add_highlight(buf, ns, "DashTitle", title_idx, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, ns, "DashDim", stats_idx, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, ns, "DashDivider", divider1_idx, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, ns, "DashDivider", divider2_idx, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, ns, "DashDim", header_idx, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, ns, "DashDim", footer_idx, 0, -1)

  for lnum, text in ipairs(lines) do
    local pos = 1
    while true do
      local s, e = string.find(text, "%[%a%]", pos)
      if not s then break end
      vim.api.nvim_buf_add_highlight(buf, ns, "DashKey", lnum - 1, s - 1, e)
      pos = e + 1
    end
  end

  -- Keymaps
  local opts = { buffer = buf, silent = true, nowait = true }

  for k, action in pairs(action_keys) do
    vim.keymap.set("n", k, action, opts)
  end

  vim.keymap.set("n", "n", function() vim.cmd.enew() end, opts)
  vim.keymap.set("n", "e", open_explorer, opts)
  vim.keymap.set("n", "F", telescope_action("find_files"), opts)
  vim.keymap.set("n", "G", telescope_action("live_grep"), opts)
  vim.keymap.set("n", "R", telescope_action("oldfiles"), opts)
  vim.keymap.set("n", "q", function() vim.cmd.qa() end, opts)
end

-- Autocommands
vim.api.nvim_create_autocmd("VimEnter", {
  group = dashboard_augroup,
  callback = function()
    if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" then
      open_dashboard()
    end
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = dashboard_augroup,
  callback = function()
    if vim.bo.filetype == "dashboard" then
      open_dashboard()
    end
  end,
})

-- Restore window options when leaving the dashboard buffer
vim.api.nvim_create_autocmd("BufLeave", {
  group = dashboard_augroup,
  callback = function()
    if vim.bo.filetype == "dashboard" then
      vim.wo[0].number = true
      vim.wo[0].relativenumber = true
      vim.wo[0].signcolumn = "auto"
    end
  end,
})
-- ============================================================================
-- TABS & BUFFERS
-- ============================================================================

vim.keymap.set('n', '<leader>bo', ':%bd|e#|bd#<CR>', { desc = 'Close all buffers except current' })

-- Rename current file
vim.keymap.set('n', '<leader>rr', function()
  local old_name = vim.fn.expand('%')
  local new_name = vim.fn.input('New file name: ', old_name)
  if new_name ~= '' and new_name ~= old_name then
    vim.cmd('saveas ' .. new_name)
    vim.fn.delete(old_name)
    print('File renamed to: ' .. new_name)
  end
end, { desc = 'Rename current file' })

-- ============================================================================
-- LSP CONFIGURATION
-- ============================================================================

-- LSP settings
local function setup_lsp()
  -- Show diagnostic signs in the gutter
  local signs = {
    Error = "\u{f06a} ", -- nf-fa-exclamation_circle
    Warn = "\u{f071} ",  -- nf-fa-exclamation_triangle
    Hint = "\u{f0eb} ",  -- nf-fa-lightbulb_o
    Info = "\u{f05a} "   -- nf-fa-info_circle
  }

  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- Diagnostic configuration
  vim.diagnostic.config({
    virtual_text = {
      prefix = '●',
      spacing = 4,
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  })

  -- LSP keymaps (set when LSP attaches)
  vim.api.nvim_create_autocmd('LspAttach', {
    group = augroup,
    callback = function(ev)
      local opts = { buffer = ev.buf }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format { async = true }
      end, opts)
    end,
  })

  -- Floating window borders
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or 'rounded'
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end
end

-- LSP diagnostic keymaps (always available)
vim.keymap.set('n', 'pd', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
vim.keymap.set('n', 'nd', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic list' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.open_float, { desc = 'Show line diagnostics' })

setup_lsp()

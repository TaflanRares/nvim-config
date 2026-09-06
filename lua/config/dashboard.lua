local M = {}

local dashboard_augroup = vim.api.nvim_create_augroup("Dashboard", { clear = true })
local OFFSET_X = 62

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

vim.api.nvim_set_hl(0, "DashTitle", { fg = palette.blue, bold = true })
vim.api.nvim_set_hl(0, "DashKey", { fg = palette.green, bold = true })
vim.api.nvim_set_hl(0, "DashText", { fg = palette.text })
vim.api.nvim_set_hl(0, "DashDim", { fg = palette.subtext, italic = true })
vim.api.nvim_set_hl(0, "DashDivider", { fg = palette.surface2 })

local saturn_ascii = {
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⢞⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⣀⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣦⣀⣠⠞⠁⢸⢀⠙⢦⡀⠀⠀⠀⣠⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⡀⠀",
  "⠀⠀⠀⠀⢰⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣿⣧⢀⠴⢃⠓⣌⠠⠙⢦⡀⣾⡟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣉⣻⡆",
  "⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣸⣿⠄⢣⡉⠖⡄⢓⢅⠂⡙⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⣿⡇",
  "⠀⠀⠀⠀⢸⣇⠐⡤⢀⢤⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⣀⢀⠠⣊⣼⣿⠘⣄⠚⢤⠉⡖⡨⢑⣄⢿⣇⠀⣀⢀⢠⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡘⣰⣿⠇",
  "⠀⠀⠀⠀⠀⠙⠿⠿⣿⡅⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡘⢤⣿⡿⠿⢟⠡⣊⠤⣉⠆⢣⠔⡡⢣⠄⡙⢿⢿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠘⣤⣾⠟⠁⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⣿⠆⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡘⠴⣿⡧⢉⠆⡱⡐⢢⠡⠚⡄⢎⡑⢢⠑⣌⣶⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡐⢤⣿⠟⠁⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⣿⠇⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡘⡔⣿⣇⠣⣘⠡⠜⡡⢊⠕⡨⢂⠜⣠⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⣡⣼⠿⠁⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⡌⣿⣇⠒⢤⡉⣒⠡⢃⠜⡠⣃⣾⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣡⣾⠿⠉⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⣿⠇⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⡌⣿⡧⢉⠆⠴⡁⢎⠰⣨⣶⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⣡⣾⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⣿⠇⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⡌⣿⣇⠣⣘⠡⡘⣤⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⣑⣾⡿⣏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⡌⣿⡧⠑⡄⣣⣾⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢊⣴⣿⠛⣄⠈⠳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⣠⣿⠇⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢱⡘⣿⣇⣣⣾⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢊⣴⣿⠟⣠⠙⣄⠓⣅⠈⠳⣄⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⣠⠞⠁⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢢⠱⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢊⣴⣿⠟⢡⡘⠤⡩⢐⡐⠓⣅⠈⠳⣄⠀⠀⠀⠀⠀",
  "⠀⠀⠀⣠⠞⠁⢀⢼⣿⠆⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢢⢙⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢊⣴⣿⠟⡡⢊⠖⣈⠖⡡⢃⠆⣉⠖⡨⢑⢆⠈⠳⣄⠀⠀⠀",
  "⣠⠞⠁⢀⡴⢉⠼⣿⡃⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢂⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⢊⣴⣿⠟⡡⢊⡔⢣⠘⡄⠎⡔⡡⠚⡄⢎⡑⢣⢌⠱⢆⠈⠳⣄⠀",
  "⢾⣷⣶⣶⡁⡆⢇⢸⣿⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡎⠰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⢏⣿⡿⢁⠎⡁⢇⠸⣀⢉⢰⠉⡰⢁⠷⡈⢆⡸⢰⠈⠶⣈⣷⣶⣾⡷",
  "⠀⠙⢷⣭⢟⣮⡰⢸⣿⡅⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⢲⣵⡿⡋⢆⡩⢒⡉⢆⠱⢂⠥⢊⠴⣁⠣⢂⡍⠢⠔⡡⢊⣴⡿⣯⡿⠋⠀",
  "⠀⠀⠀⠙⢿⣶⡹⢮⣿⠆⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡶⠷⢾⣿⡏⢢⠱⢌⡰⢡⡘⢌⢒⡉⢆⣉⠒⠤⢃⠣⢌⠱⣈⣴⣿⣻⡿⠋⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠙⢿⣽⣿⡃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠃⠀⠀⢠⡿⡑⢢⢃⠲⢄⠣⣘⠰⢊⠔⡊⢤⠙⡌⡌⠱⣈⡶⣟⣿⡾⠋⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠙⣿⡅⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢹⣿⣤⣤⣤⡾⠗⣈⠦⡑⢪⢄⡓⠤⠓⡌⣒⡉⠦⡑⠰⣈⣵⡾⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣢⣼⣿⠟⣉⣍⠩⢔⠣⣌⢢⢑⠢⣌⠘⡌⢓⡘⢤⡘⢤⡁⣧⣿⢯⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⣿⡆⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢒⣾⣛⣛⠛⠛⠛⢛⣿⠃⣶⣟⣛⠛⠛⠛⠻⣮⣦⣼⡾⠛⠛⠛⢿⣿⣋⣠⡾⠛⠛⠛⠛⣧⡀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⣿⡆⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⢊⣴⣿⠟⣻⡟⠀⠀⠀⣾⡇⢡⠙⣿⡏⠀⠀⠀⠀⠈⠉⠉⠀⠀⠀⠀⠀⠉⠉⠉⠀⠀⠀⠀⠀⣾⠃⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢚⣤⣿⠟⡡⢺⣿⠀⠀⠀⣰⡟⢄⠣⣸⡿⠁⠀⢀⣾⠛⡟⣻⣿⡟⠀⠀⢠⡿⠛⠛⠛⣿⠃⠀⠀⣰⡏⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⣿⡆⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⢘⣰⣿⠟⣡⠚⢄⣿⠃⠀⠀⢀⣿⠃⡜⢠⣿⠇⠀⠀⣸⡟⣤⣿⣿⡿⠀⠀⠀⣾⠃⠀⠀⣰⡏⠀⠀⢀⣿⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⣿⡆⠐⠀⠀⠀⠀⠀⠀⠀⢀⢄⣱⣾⡿⢧⡘⡄⢃⣾⡏⠀⠀⠀⣾⡇⢸⢈⣼⡏⠀⠀⢰⣿⣾⣟⡿⣻⠇⠀⠀⢸⡏⠀⠀⢀⣿⠀⠀⠀⣼⠃⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⣿⠆⠠⠀⠀⠀⠀⠀⢀⠔⣡⣾⠟♙⢿⣳⡝⢮⣰⡿⠀⠀⠀⣰⡟⡄⢣⢸⡿⠀⠀⠀⣾⣿⡿⠋⢰⡟⠀⠀⢠⡿⠀⠀⠀⣼⠃⠀⠀⢠⡟⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠻⣇⠐⡠⢄⠠⠠⢔⣡⣾⠟⠁⠀⠀⠀⠙⢿⣧⣿⢃⡀⣀⢀⡛⣿⡧⢡⣿⣃⣀⣀⣸⣻⡏⠀⠀⣾⣁⣀⣀⣜⣿⠆⠀⢠⣟⣀⣀⣀⣛⣿⠆⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠛⠛⠛⠛⠛⠛⠁⠀⠀⠀⠀⠀⠀⠀⠙⢿⣟⢿⣻⠛⡛⢛⠡⢂⣽⡿⣿⡿⠋⠉⠀⠀⠀⠉⠉⠉⠉⠉⠉⠀⠀⠈⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⣽⣹⢬⡂⣱⣾⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⣧⢻⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
}

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

local function ink_count(line)
  local total = vim.fn.strchars(line)
  local _, blanks = line:gsub("⠀", "")
  return total - blanks
end

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
  local left_col_width = 30
  local right_col_width = 30
  local gap = 7

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

  local function pad_cell(text, width)
    local value = text or ""
    local display_width = vim.fn.strdisplaywidth(value)
    if display_width >= width then
      return value
    end
    return value .. string.rep(" ", width - display_width)
  end

  local recent_header = pad_cell("RECENT FILES", left_col_width)
  local project_header = pad_cell("PROJECT · " .. truncate(cwd_name, right_col_width - 12), right_col_width)
  local table_line = "  " .. recent_header .. string.rep(" ", gap) .. project_header
  table.insert(lines, center_line(table_line, W + 4))
  local header_idx = #lines - 1

  for i = 1, row_count do
    local l, r = recent_entries[i], project_entries[i]
    local left_label = l and truncate(l.label, left_col_width - 6) or ""
    local right_label = r and truncate(r.label, right_col_width - 6) or ""
    local ltext = l and string.format("[%s] %s", l.key, left_label) or ""
    local rtext = r and string.format("[%s] %s", r.key, right_label) or ""
    if #recent_entries == 0 and i == 1 then ltext = "(no recent files)" end
    if #project_entries == 0 and i == 1 then rtext = "(no files here)" end

    local left_cell = pad_cell(ltext, left_col_width)
    local right_cell = pad_cell(rtext, right_col_width)
    local row = "  " .. left_cell .. string.rep(" ", gap) .. right_cell
    table.insert(lines, center_line(row, W + 4))
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

vim.api.nvim_create_autocmd("VimEnter", {
  group = dashboard_augroup,
  once = true,
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

M.open = open_dashboard
return M

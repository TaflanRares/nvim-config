local M = {}

function M.setup()
  vim.cmd.colorscheme("unokai")
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
  vim.api.nvim_set_hl(0, "Visual", { bg = "#0b2818" })

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

  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.cursorline = true
  vim.opt.wrap = false
  vim.opt.scrolloff = 10
  vim.opt.sidescrolloff = 8

  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.softtabstop = 2
  vim.opt.expandtab = true
  vim.opt.smartindent = true
  vim.opt.autoindent = true

  vim.opt.ignorecase = true
  vim.opt.smartcase = true
  vim.opt.incsearch = true

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

  vim.opt.backspace = "indent,eol,start"
  vim.opt.autochdir = false
  vim.opt.iskeyword:append("-")
  vim.opt.path:append("**")
  vim.opt.clipboard:append("unnamedplus")

  vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

  vim.opt.splitbelow = true
  vim.opt.splitright = true

  vim.opt.wildmenu = true
  vim.opt.wildmode = "longest:full,full"
  vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

  vim.opt.diffopt:append("linematch:60")
  vim.opt.redrawtime = 10000
  vim.opt.maxmempattern = 20000

  local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

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

  vim.api.nvim_create_autocmd("VimResized", {
    group = augroup,
    callback = function()
      vim.cmd("tabdo wincmd =")
    end,
  })
end

M.setup()
return M

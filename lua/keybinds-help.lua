local M = {}

local keybinds = {
	-- File Operations
	{ mode = "n", key = "<leader>cd", desc = "Change to file directory" },
  { mode = "n", key = "<C-n>", desc = "Toggle neo-tree file menu" },
  { mode = "n", key = "[cnt]gcc", desc = "Comments the following [cnt] lines" },
  { mode = "v", key = "gc", desc = "Comments the selected lines" },

	-- Telescope
	{ mode = "n", key = "<C-p>", desc = "Find files" },
	{ mode = "n", key = "<leader>fg", desc = "Live grep" },

	-- Git (Gitsigns)
	{ mode = "n", key = "]c", desc = "Next git hunk" },
	{ mode = "n", key = "[c", desc = "Previous git hunk" },
	{ mode = "n", key = "<leader>gb", desc = "Git blame line" },
	{ mode = "n", key = "<leader>gp", desc = "Preview git hunk" },
	{ mode = "n", key = "<leader>gr", desc = "Reset git hunk" },
	{ mode = "n", key = "<leader>gs", desc = "Stage git hunk" },
	{ mode = "n", key = "<leader>gu", desc = "Undo stage hunk" },
	{ mode = "n", key = "<leader>gtb", desc = "Toggle git blame" },

	-- Git (Diffview)
	{ mode = "n", key = "<leader>gd", desc = "Open git diff view" },
	{ mode = "n", key = "<leader>gh", desc = "Git file history (all)" },
	{ mode = "n", key = "<leader>gf", desc = "Git file history (current)" },
	{ mode = "n", key = "<leader>gc", desc = "Close git diff view" },

	-- CSV
	{ mode = "n", key = "<leader>cca", desc = "Align CSV" },
	{ mode = "n", key = "<leader>ccA", desc = "Clear CSV alignment" },

	-- LSP
	{ mode = "n", key = "K", desc = "Hover documentation" },
	{ mode = "n", key = "<leader>gd", desc = "Go to definition" },
	{ mode = "n", key = "<leader>ca", desc = "Code actions" },
	{ mode = "v", key = "<leader>ca", desc = "Code actions" },
 	{ mode = "n", key = "<C-e>", desc = "Show diagnostics" },
	{ mode = "i", key = "<C-e>", desc = "Show diagnostics" },

	-- Completion
	{ mode = "i", key = "<C-Space>", desc = "Trigger completion" },
	{ mode = "i", key = "<C-b>", desc = "Scroll docs up" },
	{ mode = "i", key = "<C-f>", desc = "Scroll docs down" },
	{ mode = "i", key = "<CR>", desc = "Confirm completion" },

  -- Compile and debug
  { mode = "n", key = "F5", desc = "Compiles and runs current directory"},
  { mode = "n", key = "F6", desc = "Debug start"},
  { mode = "n", key = "F10", desc = "Debug step over"},
  { mode = "n", key = "F11", desc = "Debug step into"},
  { mode = "n", key = "F12", desc = "Debug step out"},
  { mode = "n", key = "<Leader>b", desc = "Debug add breakpoint"},
}

-- Mode colors
local mode_colors = {
	n = "#cba6f7", -- Purple
	i = "#a6e3a1", -- Green
	v = "#f9e2af", -- Yellow
	t = "#89dceb", -- Orange
}

local mode_names = { n = "Normal", i = "Insert", v = "Visual", t = "Terminal" }

function M.show_keybinds()
	local buf = vim.api.nvim_create_buf(false, true)
	local ns = vim.api.nvim_create_namespace("keybinds_highlight")

	local lines = {}
	local highlights = {}

	local function add_line(text, hl_group, fg_color)
		table.insert(lines, text)
		if hl_group then
			local hl_name = "Keybinds_" .. hl_group
			vim.api.nvim_set_hl(0, hl_name, { fg = fg_color or "#89b4fa", bold = true })
			table.insert(highlights, { line = #lines - 1, hl = hl_name, col_start = 0, col_end = -1 })
		end
	end

	add_line(
		"╔══════════════════════════════════════════════════════╗",
		"title",
		"#89b4fa"
	)
	add_line(
    "║                   ⚡ MY KEYBINDS  ⚡                 ║",
    "title",
    "#89b4fa"
  )
	add_line(
		"╚══════════════════════════════════════════════════════╝",
		"title",
		"#89b4fa"
	)
	add_line("         Press / to search • q or Esc to close", "subtitle", "#6c7086")
	table.insert(lines, "")

	local grouped = {}
	for _, bind in ipairs(keybinds) do
		grouped[bind.mode] = grouped[bind.mode] or {}
		table.insert(grouped[bind.mode], bind)
	end

	-- Display keybinds
	for _, mode in ipairs({ "n", "i", "v", "t" }) do
		if grouped[mode] then
			local mode_line = " " .. string.upper(mode) .. "  " .. mode_names[mode] .. " Mode"
			add_line(mode_line, "mode_" .. mode, mode_colors[mode])
			add_line(string.rep("─", 52))

			for _, bind in ipairs(grouped[mode]) do
				local line_text = string.format("  %s → %s", bind.key, bind.desc)
				table.insert(lines, line_text)

				local key_color = "#89b4fa"
				local hl_name = "key_" .. ("default") .. "_" .. #highlights
				vim.api.nvim_set_hl(0, hl_name, { fg = key_color, bold = true })
				table.insert(highlights, {
					line = #lines - 1,
					hl = hl_name,
					col_start = 2,
					col_end = 2 + #bind.key,
				})
			end
			table.insert(lines, "")
		end
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	for _, hl in ipairs(highlights) do
		vim.api.nvim_buf_add_highlight(buf, ns, hl.hl, hl.line, hl.col_start, hl.col_end)
	end

	local width = 56
	local height = math.min(#lines, 25)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
	})

	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_win_set_option(win, "scrolloff", 999)
	vim.api.nvim_win_set_option(win, "cursorline", true)

	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", opts)
	vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", opts)
	vim.api.nvim_buf_set_keymap(buf, "n", "/", "/", { noremap = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "n", "n", opts)
	vim.api.nvim_buf_set_keymap(buf, "n", "N", "N", opts)
end

function M.setup(opts)
	opts = opts or {}
	vim.api.nvim_create_user_command("ShowKeybinds", M.show_keybinds, {})
	if opts.keymap then
		vim.keymap.set("n", opts.keymap, M.show_keybinds, { desc = "Show my keybinds" })
	end
end

return M

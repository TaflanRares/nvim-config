local langs = {
	"lua_ls",
	"rust_analyzer",
	"clangd",
	"jdtls",
	"html",
	"verible",
}

local server_filetypes = {
	lua_ls        = { "lua" },
	rust_analyzer = { "rust" },
	clangd        = { "c", "cpp", "objc", "objcpp" },
	jdtls         = { "java" },
	html          = { "html" },
	verible       = { "systemverilog", "verilog" },
}

return {
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		event = "BufReadPre",
		config = function()
			require("mason-lspconfig").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			vim.lsp.set_log_level("ERROR")

			for _, server in ipairs(langs) do
				vim.lsp.config(server, { capabilities = capabilities })
			end

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local ft = args.match
					for server, filetypes in pairs(server_filetypes) do
						for _, supported_ft in ipairs(filetypes) do
							if ft == supported_ft then
								vim.lsp.enable(server)
								return
							end
						end
					end
				end,
			})

			-- Keymaps
			local bufopts = { noremap = true, silent = true }
			vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, bufopts)
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, bufopts)
			vim.keymap.set("n", "<C-e>", function()
				vim.diagnostic.open_float({ scope = "buffer" })
			end, bufopts)
			vim.keymap.set("i", "<C-e>", function()
				vim.diagnostic.open_float({ scope = "line" })
			end, bufopts)
		end,
	},
}

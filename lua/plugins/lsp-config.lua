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
		lazy = true,
	},
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPost",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			vim.lsp.set_log_level("ERROR")

			for server, filetypes in pairs(server_filetypes) do
				vim.lsp.config(server, {
					capabilities = capabilities,
					filetypes = filetypes,
				})
				vim.lsp.enable(server)
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufopts = { noremap = true, silent = true, buffer = args.buf }
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
			})
		end,
	},
}

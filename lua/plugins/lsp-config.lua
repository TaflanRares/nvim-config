local server_filetypes = {
	lua_ls = { "lua" },
	rust_analyzer = { "rust" },
	clangd = { "c", "cpp", "objc", "objcpp" },
	jdtls = { "java" },
	html = { "html" },
	verible = { "systemverilog", "verilog" },
}

return {
	{
		"mason-org/mason.nvim",
		lazy = true,
		cmd = "Mason",
		config = function()
			require("mason").setup({
				PATH = "prepend",
			})
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		lazy = true,
	},
	{
		"stevearc/conform.nvim",
		lazy = true,
		event = "BufWritePre",
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = false })
				end,
				mode = { "n", "v" },
				desc = "Format buffer",
			},
		},
		opts = {
			formatters = {
				stylua = {
					command = vim.fn.stdpath("data") .. "/mason/bin/stylua.cmd",
				},
				prettier = {
					command = vim.fn.stdpath("data") .. "/mason/bin/prettier.cmd",
				},
				["clang-format"] = {
					command = vim.fn.stdpath("data") .. "/mason/bin/clang-format.cmd",
				},
				["verible-verilog-format"] = {
					command = vim.fn.stdpath("data") .. "/mason/bin/verible-verilog-format.cmd",
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				rust = { "rustfmt" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				java = { "google-java-format" },
				html = { "prettier" },
				systemverilog = { "verible-verilog-format" },
				verilog = { "verible-verilog-format" },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = true,
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
					local client = vim.lsp.get_client_by_id(args.data.client_id)
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
					if client and client:supports_method("textDocument/formatting") then
						vim.keymap.set("n", "<leader>lf", function()
							vim.lsp.buf.format({ bufnr = args.buf })
						end, vim.tbl_extend("force", bufopts, { desc = "LSP format" }))
					end
				end,
			})
		end,
	},
}

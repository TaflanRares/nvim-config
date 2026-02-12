local langs = {
	"lua_ls",
	"rust_analyzer",
	"clangd",
	"jdtls",
	"html",
}
return {
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = langs,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			vim.lsp.set_log_level("ERROR")
			for _, server in ipairs(langs) do
				vim.lsp.config(server, {
					capabilities = capabilities,
				})
			end

			vim.lsp.enable(langs)

			-- keymaps
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

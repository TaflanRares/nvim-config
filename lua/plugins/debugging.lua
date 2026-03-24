return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	lazy = true,
	keys = {
		{
			"<F5>",
			function()
				require("dap").terminate()
			end,
			desc = "Debug: Terminate",
		},
		{
			"<F6>",
			function()
				require("dap").continue()
			end,
			desc = "Debug: Continue",
		},
		{
			"<F10>",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: Step Over",
		},
		{
			"<F11>",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: Step Into",
		},
		{
			"<F12>",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: Step Out",
		},
		{
			"<Leader>b",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: Toggle Breakpoint",
		},
		{
			"<Leader>B",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Debug: Conditional Breakpoint",
		},
		{
			"<Leader>dt",
			function()
				require("dapui").toggle()
			end,
			desc = "Debug: Toggle UI",
		},
		{
			"<Leader>dc",
			function()
				require("dapui").close()
			end,
			desc = "Debug: Close UI",
		},
		{
			"<Leader>dr",
			function()
				require("dap").repl.open()
			end,
			desc = "Debug: Open REPL",
		},
		{
			"<Leader>dl",
			function()
				require("dap").run_last()
			end,
			desc = "Debug: Run Last",
		},
		{
			"<Leader>de",
			function()
				require("dapui").eval()
			end,
			desc = "Debug: Evaluate expression",
		},
		{
			"<Leader>de",
			function()
				require("dapui").eval()
			end,
			mode = "v",
			desc = "Debug: Evaluate selection",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup({
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.25 },
						{ id = "breakpoints", size = 0.25 },
						{ id = "stacks", size = 0.25 },
						{ id = "watches", size = 0.25 },
					},
					size = 40,
					position = "left",
				},
				{
					elements = {
						{ id = "repl", size = 0.5 },
						{ id = "console", size = 0.5 },
					},
					size = 10,
					position = "bottom",
				},
			},
		})

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end

		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = vim.fn.stdpath("data") .. "/mason/bin/codelldb.cmd",
				args = { "--port", "${port}" },
			},
		}

		local codelldb_config = {
			{
				name = "Launch (stop at entry)",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "\\", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = true,
				args = {},
				console = "integratedTerminal",
			},
			{
				name = "Launch (run to breakpoint)",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "\\", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
				console = "integratedTerminal",
			},
			{
				name = "Attach to process",
				type = "codelldb",
				request = "attach",
				pid = require("dap.utils").pick_process,
				args = {},
			},
		}

		dap.configurations.c = codelldb_config
		dap.configurations.cpp = codelldb_config
		dap.configurations.rust = codelldb_config
	end,
}

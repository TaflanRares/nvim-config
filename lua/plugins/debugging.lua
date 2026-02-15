return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Setup dap-ui with better layout
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

		-- Configure listeners - ONLY auto-open, NOT auto-close
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		-- Don't auto-close - let user close manually
		-- dap.listeners.before.event_terminated.dapui_config = function()
		-- 	dapui.close()
		-- end
		-- dap.listeners.before.event_exited.dapui_config = function()
		-- 	dapui.close()
		-- end

		-- CodeLLDB Adapter
		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = vim.fn.stdpath("data") .. "/mason/bin/codelldb.cmd",
				args = { "--port", "${port}" },
			},
		}

		-- C/C++/Rust Configurations
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
				-- Show program output in console
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

		-- Apply configurations to all three languages
		dap.configurations.c = codelldb_config
		dap.configurations.cpp = codelldb_config
		dap.configurations.rust = codelldb_config

		-- Keybindings
		vim.keymap.set("n", "<F5>", dap.terminate, { desc = "Debug: Terminate" })
		vim.keymap.set("n", "<F6>", dap.continue, { desc = "Debug: Continue" })
		vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
		vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
		vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })

		vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
		vim.keymap.set("n", "<Leader>B", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: Conditional Breakpoint" })

		-- UI controls
		vim.keymap.set("n", "<Leader>dt", dapui.toggle, { desc = "Debug: Toggle UI" })
		vim.keymap.set("n", "<Leader>dc", dapui.close, { desc = "Debug: Close UI" })

		-- Debug controls
		vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
		vim.keymap.set("n", "<Leader>dl", dap.run_last, { desc = "Debug: Run Last" })

		-- Evaluate expression under cursor
		vim.keymap.set("n", "<Leader>de", function()
			dapui.eval()
		end, { desc = "Debug: Evaluate expression" })
		vim.keymap.set("v", "<Leader>de", function()
			dapui.eval()
		end, { desc = "Debug: Evaluate selection" })
	end,
}

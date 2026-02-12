vim.keymap.set("n", "<F5>", function()
	local current_file = vim.fn.expand("%:p")
	local src_dir = vim.fn.finddir("src", ".;")

	if src_dir ~= "" then
		vim.cmd('!javac "' .. src_dir .. '\\*.java" && java -cp "' .. src_dir .. '" Main')
	else
		vim.cmd('!javac "%:h\\*.java" && java -cp "%:h" "%:t:r"')
	end
end)

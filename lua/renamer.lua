-- 变量重命名
local M = {}

local rename = function(old_name)
	local newName = vim.trim(vim.fn.getline("."))
  vim.api.nvim_buf_delete(0, { force = true })
	if #newName > 0 and newName ~= old_name then
		local params = vim.lsp.util.make_position_params()
		params.newName = newName
		vim.lsp.buf_request(0, "textDocument/rename", params)
	end
end

M.rename_current_cursor_field = function()
	local old_name = vim.fn.expand("<cword>") .. " "
	local win_opt = {
		title = "Renamer",
		border = "single",
		style = "minimal",
		relative = "cursor",
		focusable = true,
		width = 25,
		height = 1,
		row = 1,
		col = 0,
	}
	-- local win = require("plenary.popup").create(currName, {
	--   title = "Renamer",
	--   style = "minimal",
	--   borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
	--   relative = "cursor",
	--   borderhighlight = "RenamerBorder",
	--   titlehighlight = "RenamerTitle",
	--   focusable = true,
	--   width = 25,
	--   height = 1,
	--   line = "cursor+2",
	--   col = "cursor-1",
	-- })

	local bufid = vim.api.nvim_create_buf(true, true)
	local win = vim.api.nvim_open_win(bufid, true, win_opt)
	local map_opts = { noremap = true, silent = true }
	vim.cmd("normal w")
	vim.cmd("startinsert")
	vim.api.nvim_buf_set_keymap(0, "i", "<Esc>", "<cmd>stopinsert | q!<CR>", map_opts)
	vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", "<cmd>stopinsert | q!<CR>", map_opts)
	vim.api.nvim_buf_set_keymap(0, "i", "<CR>", "", {
		callback = function()
			vim.api.nvim_command("stopinsert")
			rename(old_name)
		end,
	})
	vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "", {
		callback = function()
			vim.api.nvim_command("stopinsert")
			rename(old_name)
		end,
	})
end

return M


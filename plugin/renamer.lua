vim.api.nvim_create_user_command(
  "RenameCurrentCursorField",
  function()
	  require("renamer").rename_current_cursor_field()
  end,
  {
    nargs = 0,
    desc = "Rename the current cursor field",
  }
)

local M = {}

-- Remove unnamed, unmodified, normal buffers that aren't shown in any window
function M.clean_empty_bufs()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b)
      and vim.api.nvim_buf_get_name(b) == ""
      and vim.bo[b].buftype == ""
      and not vim.bo[b].modified
      and #vim.fn.win_findbuf(b) == 0 then
      pcall(vim.api.nvim_buf_delete, b, {})
    end
  end
end

return M

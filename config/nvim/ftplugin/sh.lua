vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true

local augroup = vim.api.nvim_create_augroup("ShellFormat", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  buffer = 0,
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 2000 })
  end,
})

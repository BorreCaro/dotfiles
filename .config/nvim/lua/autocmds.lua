require "nvchad.autocmds"
-- Indent changer
local indent_config = require "configs.indent_settings"
for filetype, settings in pairs(indent_config.settings) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetype,
    callback = function()
      for option, value in pairs(settings) do
        vim.opt_local[option] = value
      end
    end,
  })
end
-- Cerrar terminal con Esc
_G.terminal_close_key = "<Esc>"
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.keymap.set("t", _G.terminal_close_key, "<C-\\><C-n>:bd!<CR>", { buffer = bufnr, silent = true })
  end,
})
-- Yank Highlight
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
vim.diagnostic.config {
  -- Mostrar el texto completo del error/advertencia en línea (al lado del código)
  virtual_text = {
    -- Mostrarlo siempre, pero solo para Warnings (W) o más graves
    severity = { min = "WARN" },
    source = "always",
  },

  -- Asegurar que el pop-up (hover) esté activo
  float = true,

  -- Asegurar que los signos (W, E) estén en el margen
  signs = true,
}

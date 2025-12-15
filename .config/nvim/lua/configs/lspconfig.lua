local nvlsp = require "nvchad.configs.lspconfig"
local navic = require "nvim-navic"

local on_attach = function(client, bufnr)
  nvlsp.on_attach(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

local servers = { "html", "cssls", "pyright", "clangd", "ruff", "rust-analyzer", "stylua" }

for _, lsp in ipairs(servers) do
  -- Sintaxis nvim 0.11+
  vim.lsp.config(lsp, {
    on_attach = on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })

  vim.lsp.enable(lsp)
end

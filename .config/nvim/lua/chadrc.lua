---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "redhorizon",
  transparency = true,
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

-- 1. Función de estado (Estrategia LSP)
local function get_copilot_status()
  -- Si el paquete no se ha cargado, no hacemos nada (mantiene el inicio diferido)
  if not package.loaded["copilot"] then
    return "%#Comment# Off %*"
  end

  -- ESTRATEGIA: Verificamos si el cliente LSP 'copilot' está conectado al buffer actual.
  -- Esta es la fuente de la verdad. Si el toggle lo apaga, el cliente se desconecta.
  local clients = vim.lsp.get_clients { name = "copilot", bufnr = 0 }

  -- Si no hay cliente conectado, está Inactivo
  if #clients == 0 then
    return "%#Comment# Inactive %*"
  end

  -- Si hay cliente, preguntamos a la API si hay errores o si está trabajando
  local ok, api = pcall(require, "copilot.api")
  if not ok then
    return ""
  end

  local data = api.status.data

  if data.status == "InProgress" then
    return "%#String# Pending %*"
  elseif data.status == "Warning" then
    return "%#Error# Error %*"
  end

  -- Si el cliente está conectado y la API está normal, entonces está Activo
  return "%#String# Active %*"
end

M.nvdash = { load_on_startup = true }

M.ui = {
  statusline = {
    modules = {
      copilot = get_copilot_status,
    },

    order = {
      "mode",
      "file",
      "git",
      "%=",
      "lsp_msg",
      "%=",
      "diagnostics",
      "lsp",
      "copilot", -- Nuestro módulo
      "cwd",
      "cursor",
    },
  },
}

return M

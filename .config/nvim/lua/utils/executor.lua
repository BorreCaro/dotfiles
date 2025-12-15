local M = {} -- M es la tabla que vamos a exportar (el módulo)
local run_commands = require "configs.run_commands"
local platform = require "utils.platform"

-- Detectar sistema usando the platform utility
local commands = platform.is_windows and run_commands.windows or run_commands.unix

-- Define la función principal que se llamará desde el mapeo
M.run_file = function()
  local filetype = vim.bo.filetype
  local expand = vim.fn.expand
  local command = commands[filetype]

  if command then
    command = command:gsub("%%<", expand "%<"):gsub("%%", expand "%")
    vim.cmd "write"
    vim.cmd "split | terminal "
    -- Enviar el comando al terminal
    vim.api.nvim_chan_send(vim.b.terminal_job_id, command .. "\n")
    vim.cmd "startinsert"
  else
    print "No hay comando definido para este tipo de archivo"
  end
end
return M

-- Platform detection utility module
local M = {}

-- Check if running on Windows
M.is_windows = vim.fn.has "win32" == 1 or vim.fn.has "win64" == 1

-- Check if running on macOS
M.is_mac = vim.fn.has "macunix" == 1

-- Check if running on Linux
M.is_linux = vim.fn.has "unix" == 1 and not M.is_mac

-- Get path separator for current platform
M.path_sep = M.is_windows and "\\" or "/"

-- Check if a command/executable exists on the system
---@param cmd string The command to check
---@return boolean
M.executable_exists = function(cmd)
  return vim.fn.executable(cmd) == 1
end

return M

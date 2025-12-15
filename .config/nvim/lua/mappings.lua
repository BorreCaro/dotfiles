require "nvchad.mappings"

local M = {}
local map = vim.keymap.set
local executor = require "utils.executor" -- Tu modulo de compilar

-- Mappings generales
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>rf", executor.run_file, { desc = "Run file based on lang" })
_G.terminal_close_key = "<Esc>"

-- DEBUGGING (DAP)
-- Nota: Usamos una función anónima o require directo dentro del map para evitar
-- errores si el plugin dap no se ha cargado aún al iniciar nvim.

map("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "DAP Toggle Breakpoint" })
map("n", "<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { desc = "DAP Conditional Breakpoint" })

map("n", "<leader>dc", function()
  require("dap").continue()
end, { desc = "DAP Continue/Start" })
map("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "DAP Step Into" })
map("n", "<leader>do", function()
  require("dap").step_out()
end, { desc = "DAP Step Out" })
map("n", "<leader>dn", function()
  require("dap").step_over()
end, { desc = "DAP Step Over" })
map("n", "<leader>dt", function()
  require("dap").terminate()
end, { desc = "DAP Terminate" })
map("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "DAP UI Toggle" })

-- Copilot
map("n", "<leader>cp", "<cmd>Copilot toggle<CR>", { desc = "Copilot Toggle Copilot" })
M.cmp_accept_key = "<C-y>"

-- Competitest
M.competitest = {

  run = { key = "<leader>pr", desc = "Competitest Run test cases" },
  add = { key = "<leader>pa", desc = "Competitest Add test case" },
  edit = { key = "<leader>pe", desc = "Competitest Edit test cases" },
  recv = { key = "<leader>pi", desc = "Competitest Download Problem (Integration)" },
}
M.silicon = {
  whole = { key = "<leader>ss", desc = "Silicon Screenshot whole file" },
  selection = { key = "<leader>sv", desc = "Silicon Screenshot selection" },
}
M.lazygit = {
  lazygit = { key = "<leader>lg", desc = "LazyGit Open LazyGit" },
}
M.trouble = {
  diagnostics = { key = "<leader>td", desc = "Trouble Toggle Diagnostics" },
  references = { key = "<leader>tr", desc = "Trouble Toggle References" },
}
M.flash = {
  jump = { key = "s", desc = "Flash Jump" },
  treesitter = { key = "S", desc = "Flash Treesitter (Block select)" },
}

-- Refactoring
map("x", "<leader>re", ":Refactor extract<CR>", { desc = "Refactor Extract" })
map("x", "<leader>rv", ":Refactor extract_var<CR>", { desc = "Refator Extract Var" })
map({ "n", "x" }, "<leader>rI", ":Refactor inline_var<CR>", { desc = "Refactor Refactor Inline Var" })
map("n", "<leader>ri", ":Refactor inline_func<CR>", { desc = "Refactor Refactor Inline Function" })
map("n", "<leader>rb", ":Refactor extract_block<CR>", { desc = "Refactor Extract Block" })

return M

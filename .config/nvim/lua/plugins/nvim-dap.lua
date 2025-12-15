local platform = require "utils.platform"

return {
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    dependencies = {
      "rcarriga/nvim-dap-ui", -- Versión actualizada recomendada
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      -- 1. Configuración de Iconos (Breakpoints bonitos)
      local sign = vim.fn.sign_define
      sign("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      sign("DapBreakpointCondition", { text = "🔶", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      sign("DapLogPoint", { text = "📝", texthl = "DapLogPoint", linehl = "", numhl = "" })
      sign("DapStopped", { text = "👉", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
      sign("DapBreakpointRejected", { text = "🌑", texthl = "DapBreakpoint", linehl = "", numhl = "" })

      -- 2. Setup de UI y Virtual Text
      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      -- 3. Adaptadores

      -- PYTHON: use "python" on Windows, "python3" on Unix
      local python_cmd = platform.is_windows and "python" or "python3"
      dap.adapters.python = {
        type = "executable",
        command = python_cmd,
        args = { "-m", "debugpy.adapter" },
      }

      -- C / C++ / RUST (codelldb)
      -- On Windows, Mason installs codelldb.cmd instead of codelldb
      local codelldb_cmd = vim.fn.stdpath "data"
        .. platform.path_sep
        .. "mason"
        .. platform.path_sep
        .. "bin"
        .. platform.path_sep
        .. "codelldb"
      if platform.is_windows then
        codelldb_cmd = codelldb_cmd .. ".cmd"
      end

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          -- IMPORTANTE: Asegúrate de que codelldb esté instalado vía Mason
          command = codelldb_cmd,
          args = { "--port", "${port}" },
        },
      }

      -- 4. Configuraciones (Launch)

      -- Configuración compartida para C y C++
      local exe_suffix = platform.is_windows and ".exe" or ""
      local path_sep = platform.path_sep
      local c_cpp_config = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. path_sep .. "bin" .. path_sep, "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      dap.configurations.c = c_cpp_config
      dap.configurations.cpp = c_cpp_config

      -- Configuración Python
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
        },
      }

      -- 5. Listeners para abrir/cerrar UI automáticamente
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}

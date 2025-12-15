local platform = require "utils.platform"
local km = require("mappings").competitest

return {
  {
    "xeluxee/competitest.nvim",
    dependencies = "MunifTanjim/nui.nvim",

    keys = {
      { km.run.key, "<cmd>CompetiTest run<cr>", desc = km.run.desc },
      { km.add.key, "<cmd>CompetiTest add_testcase<cr>", desc = km.add.desc },
      { km.edit.key, "<cmd>CompetiTest edit_testcase<cr>", desc = km.edit.desc },
      { km.recv.key, "<cmd>CompetiTest receive problem<cr>", desc = km.recv.desc },
    },

    config = function()
      local home = vim.fn.expand "~"
      local path_sep = platform.path_sep

      -- Helper function to build platform-appropriate executable path
      local function build_exe_path()
        if platform.is_windows then
          return "$(ABSDIR)\\bin\\$(FNOEXT).exe"
        end
        return "$(ABSDIR)/bin/$(FNOEXT)"
      end

      -- Helper function to build template file paths
      local function template_path(filename)
        return table.concat({ home, "Desktop", "code", "comp", "templates", filename }, path_sep)
      end

      local exe_output = build_exe_path()
      local python_cmd = platform.is_windows and "python" or "python3"

      require("competitest").setup {
        host = "0.0.0.0",
        port = 10042,
        testcases_use_single_file = true,
        testcases_directory = "testcases",
        compile_directory = "bin",

        problem_format = "$(PROBLEM)_$(INDEX)",

        received_problems_path = "$(JAVA_TASK_CLASS).$(FEXT)",
        received_contests_problems_path = "$(JAVA_TASK_CLASS).$(FEXT)",

        compile_command = {
          cpp = {
            exec = "g++",
            args = {
              "$(FABSPATH)",
              "-o",
              exe_output,
            },
          },
          rust = { exec = "rustc", args = { "$(FABSPATH)", "-o", exe_output } },
        },

        run_command = {
          cpp = { exec = exe_output },
          rust = { exec = exe_output },
          python = { exec = python_cmd, args = { "$(FABSPATH)" } },
        },
        runner_ui = {
          interface = "popup",
        },

        template_file = {
          cpp = template_path "template.cpp",
          py = template_path "template.py",
          rust = template_path "template.rs",
        },
      }
    end,
  },
}

local platform = require "utils.platform"
local km = require("mappings").silicon

-- Silicon requires the silicon binary which may not be available on Windows
-- Disable the plugin if silicon is not installed
if not platform.executable_exists "silicon" then
  return {}
end

return {
  "michaelrommel/nvim-silicon",
  cmd = { "Silicon" },

  keys = {
    {
      km.whole.key,
      function()
        ---@diagnostic disable-next-line
        require("nvim-silicon").clip {
          from = 1,
          to = vim.fn.line "$",
        }
      end,
      mode = "n",
      desc = km.whole.desc,
    },
    {
      km.selection.key,
      function()
        require("nvim-silicon").clip()
      end,
      mode = "v",
      desc = km.selection.desc,
    },
  },

  config = function()
    local silicon = require "nvim-silicon"

    silicon.setup {
      disable_defaults = false,
      debug = false,
      theme = "OneHalfDark",
      wslclipboard = "auto",
      wslclipboardcopy = "delete",
    }
  end,
}

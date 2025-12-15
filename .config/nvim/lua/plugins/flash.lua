local km = require("mappings").flash
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      km.jump.key,
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = km.jump.desc,
    },
    {
      km.treesitter.key,
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = km.treesitter.desc,
    },
  },
}

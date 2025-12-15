local km = require("mappings").trouble
return {
  "folke/trouble.nvim",
  opts = {},
  cmd = "Trouble",
  keys = {
    { km.diagnostics.key, "<cmd>Trouble diagnostics toggle<cr>", desc = km.diagnostics.desc },
    {
      km.references.key,
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = km.references.desc,
    },
  },
}

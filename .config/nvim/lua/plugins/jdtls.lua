return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function()
    require("configs.java").setup()
  end,
}

local maps = require("mappings").lazygit
return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { maps.lazygit.key, "<cmd>LazyGit<cr>", desc = maps.lazygit.desc },
  },
}

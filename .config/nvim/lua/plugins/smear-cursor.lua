local is_win = require("utils.platform").is_windows
return {
  "sphamba/smear-cursor.nvim",
  lazy = false,
  enabled = is_win,
  opts = {
    stiffness = 0.8,
    trailing_stiffness = 0.5,
    distance_stop_animating = 0.5,
    cursor_color = "#fe4e9f",
    enabled = true,
  },
}

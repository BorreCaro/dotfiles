require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!
o.relativenumber = true
o.number = true
o.whichwrap = "" -- No saltar linea con j k al terminar
o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

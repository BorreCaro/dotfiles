local M = {}

M.base_30 = {
  white = "#ffffff", -- Texto principal blanco puro
  darker_black = "#0b0f10", -- Fondo más oscuro (barras laterales)
  black = "#0f1416", -- Fondo principal (match con Kitty)
  black2 = "#141b1e",
  one_bg = "#192226",
  one_bg2 = "#202b30",
  one_bg3 = "#28353b",
  grey = "#455a64",
  grey_fg = "#546e7a",
  grey_fg2 = "#607d8b",
  light_grey = "#78909c",

  -- La paleta "Hot":
  red = "#ff3c33", -- Rojo principal
  baby_pink = "#ff5f58", -- Rojo suave
  line = "#202b30",

  green = "#26a69a", -- Teal (para strings)
  vibrant_green = "#4db6ac",

  nord_blue = "#2c4e57",
  blue = "#4dd0e1", -- Azul muy claro y legible

  yellow = "#ff7043", -- Naranja (Warnings)
  sun = "#ff8a65",

  purple = "#f06292", -- Rosa (Keywords)
  dark_purple = "#ad1457",

  teal = "#00bcd4",
  orange = "#ff5722",
  cyan = "#26c6da",

  statusline_bg = "#141b1e",
  lightbg = "#202b30",
  pmenu_bg = "#ff3c33", -- Menú emergente ROJO (muy agresivo, pero combina)
  folder_bg = "#ff3c33", -- Iconos de carpeta rojos
}

M.base_16 = {
  base00 = "#0f1416", -- Fondo
  base01 = "#192226",
  base02 = "#202b30",
  base03 = "#455a64",
  base04 = "#78909c",
  base05 = "#ffffff", -- Texto Normal (Blanco)
  base06 = "#ff5f58", -- Acentos suaves
  base07 = "#ffffff",

  base08 = "#ff3c33", -- Variables / Errores (ROJO)
  base09 = "#ff7043", -- Números / Constantes (NARANJA)
  base0A = "#ff8a65", -- Clases (CORAL)
  base0B = "#26a69a", -- Strings (TEAL - El único contraste frío)
  base0C = "#4dd0e1",
  base0D = "#ff5f58", -- Funciones (ROJO SUAVE en vez de azul)
  base0E = "#f06292", -- Keywords/Includes (ROSA)
  base0F = "#d84315",
}

M.type = "dark"

return M

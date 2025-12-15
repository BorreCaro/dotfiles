return {
  -- 1. Copilot base (inicia apagado, sugerencia inline desactivada)
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    config = function()
      require("copilot").setup {
        enabled = false,
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    end,
  },

  -- 2. El puente (copilot-cmp)
  {
    "zbirenbaum/copilot-cmp",
    event = { "InsertEnter", "LspAttach" },
    fix_pairs = true,
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- 3. Configuración de nvim-cmp: SÓLO FIX para <CR>
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "zbirenbaum/copilot-cmp" },
    opts = function(_, conf)
      local cmp = require "cmp"
      local accept_key = require("mappings").cmp_accept_key

      -- Agregar la fuente de Copilot
      table.insert(conf.sources, 1, { name = "copilot", group_index = 2 })

      -- *** LÓGICA CONDICIONAL para el Enter (<CR>) ***
      local custom_mapping = {
        ["<CR>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            local entry = cmp.get_selected_entry()

            if entry and entry.source.name == "copilot" then
              -- Si la sugerencia visible es Copilot, NO confirmar, solo nueva línea
              cmp.mapping.abort()
              fallback()
            else
              -- Si es LSP, snippet, o cualquier otra cosa, confirmar
              cmp.mapping.confirm { select = true }(fallback)
            end
          else
            -- Si no hay menú visible, solo inserta la nueva línea
            fallback()
          end
        end, { "i", "s" }),
        [accept_key] = cmp.mapping.confirm { select = true },
      }

      -- Sobrescribir SÓLO el keymap de <CR>
      conf.mapping = vim.tbl_deep_extend("force", conf.mapping, custom_mapping)

      -- La ventana de preview/documentación queda ACTIVA por defecto.

      return conf
    end,
  },
}

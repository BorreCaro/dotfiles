local M = {}

M.setup = function()
  local jdtls = require "jdtls"
  local platform = require "utils.platform"

  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local workspace_dir = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name

  -- 1. RUTAS DINÁMICAS A MASON
  local mason_path = vim.fn.stdpath "data" .. "/mason/"

  -- Buscamos el launcher.jar automáticamente
  local launcher_jar = vim.fn.glob(mason_path .. "packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")

  local os_config = "linux"
  if platform.is_mac then
    os_config = "mac"
  elseif platform.is_windows then
    os_config = "win"
  end

  -- 2. CONFIGURACIÓN DEL (DAP)
  local bundles = {}

  -- Jar del Debugger (java-debug-adapter)
  local java_debug_path = mason_path
    .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
  vim.list_extend(bundles, vim.split(vim.fn.glob(java_debug_path), "\n"))

  -- Jars de Testing (java-test)
  local java_test_path = mason_path .. "packages/java-test/extension/server/*.jar"
  vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path), "\n"))

  -- 3. CONFIGURACIÓN DEL SERVIDOR
  local config = {
    cmd = {
      "java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xmx1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",

      "-jar",
      launcher_jar,
      "-configuration",
      mason_path .. "packages/jdtls/config_" .. os_config,
      "-data",
      workspace_dir,
    },

    root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },

    init_options = {
      bundles = bundles,
    },

    settings = {
      java = {
        eclipse = { downloadSources = true },
        maven = { downloadSources = true },
        implementationsCodeLens = { enabled = true },
        referencesCodeLens = { enabled = true },
        references = { includeDecompiledSources = true },
        format = { enabled = true },
      },
    },

    -- 4. ON_ATTACH (Navic + DAP + Mappings)
    on_attach = function(client, bufnr)
      -- A) Cargar mapeos base de NvChad
      local utils = require "nvchad.configs.lspconfig"
      utils.on_attach(client, bufnr)

      -- B) Conectar NAVIC (para la winbar)
      if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
      end

      -- C) Iniciar DEBUGGER
      require("jdtls").setup_dap { hotcodereplace = "auto" }

      -- D) Activar CodeLens
      require("jdtls").setup.add_commands()
      vim.lsp.codelens.refresh()
    end,

    capabilities = require("nvchad.configs.lspconfig").capabilities,
  }

  jdtls.start_or_attach(config)
end

return M

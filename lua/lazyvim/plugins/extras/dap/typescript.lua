return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "js-debug-adapter")
        end,
      },
    },
    opts = function()
      local dap = require("dap")

      for _, adapterType in ipairs({ "node", "chrome", "msedge" }) do
        local pwaType = "pwa-" .. adapterType

        if not dap.adapters[pwaType] then
          dap.adapters[pwaType] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
              command = "js-debug-adapter",
              args = { "${port}" },
            },
          }
        end

        -- Define adapters without the "pwa-" prefix for VSCode compatibility
        if not dap.adapters[adapterType] then
          dap.adapters[adapterType] = function(cb, config)
            local nativeAdapter = dap.adapters[pwaType]

            config.type = pwaType

            if type(nativeAdapter) == "function" then
              nativeAdapter(cb, config)
            else
              cb(nativeAdapter)
            end
          end
        end
      end

      local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" }

      local vscode = require("dap.ext.vscode")
      vscode.type_to_filetypes["node"] = js_filetypes
      vscode.type_to_filetypes["pwa-node"] = js_filetypes

      for _, language in ipairs(js_filetypes) do
        if not dap.configurations[language] then
          local runtimeExecutable = nil
          if language:find("typescript") then
            runtimeExecutable = vim.fn.executable("tsx") == 1 and "tsx" or "ts-node"
          end
          dap.configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch Node (npm run scripts)",
              cwd = vim.fn.getcwd(),
              args = { "${file}" },
              sourceMaps = true,
              protocol = "inspector",
              runtimeExecutable = "npm",
              console = "integratedTerminal",
              runtimeArgs = {
                "run-script",
                function()
                  return vim.fn.input("npm run ", "start")
                end,
              },
              skipFiles = {
                "<node_internals>/**",
                "node_modules/**",
                "${workspaceFolder}/node_modules/**",
                "**/*.min.js",
                "**/chunk*.js",
                "**/webpack/runtime/**",
                "**/webpack-internal/**",
                "webpack://**",
                "webpack-internal://**",
                "**/[^.]*",
                "**/@fs/**",
                "**/?t=*",
                "**/*?*=",
                "**/virtual:*",
                "**/vite/client",
                "**/@vite/client",
                "**/hmr*",
                "**/*refresh*",
                "**/bootstrap",
              },
              resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**",
              },
            },
            {
              type = "pwa-chrome",
              request = "launch",
              name = "Launch Chrome",
              url = function()
                local co = coroutine.running()
                return coroutine.create(function()
                  vim.ui.input({
                    prompt = "Enter URL: ",
                    default = "http://localhost:3000",
                  }, function(url)
                    if url == nil or url == "" then
                      return
                    else
                      coroutine.resume(co, url)
                    end
                  end)
                end)
              end,
              webRoot = "${workspaceFolder}",
              sourceMaps = true,
              protocol = "inspector",
              skipFiles = {
                "<node_internals>/**",
                "node_modules/**",
                "${workspaceFolder}/node_modules/**",
                "**/*.min.js",
                "**/chunk*.js",
                "**/webpack/runtime/**",
                "**/webpack-internal/**",
                "webpack://**",
                "webpack-internal://**",
                "**/[^.]*",
                "**/@fs/**",
                "**/?t=*",
                "**/*?*=",
                "**/virtual:*",
                "**/vite/client",
                "**/@vite/client",
                "**/hmr*",
                "**/*refresh*",
                "**/bootstrap",
              },
              sourceMapPathOverrides = {
                ["webpack:///src/*"] = "${webRoot}/*",
              },
              runtimeArgs = {
                -- 自动打开调试面板
                "--auto-open-devtools-for-tabs",
              },
            },
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              cwd = "${workspaceFolder}",
              sourceMaps = true,
              runtimeExecutable = runtimeExecutable,
              console = "integratedTerminal",
              skipFiles = {
                "<node_internals>/**",
                "node_modules/**",
                "${workspaceFolder}/node_modules/**",
              },
              resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**",
              },
            },
          }
        end
      end
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = {
      -- chrome adapter is deprecated, use js-debug-adapter instead
      automatic_installation = { exclude = { "chrome" } },
    },
  },
}

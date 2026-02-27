return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
    keys = {
      { "<leader>am", mode = { "n" }, "<cmd>MCPHub<cr>", desc = "mcphub" },
    },
    config = function()
      require("mcphub").setup({
        config = vim.fn.expand("~/.config/nvim/servers.json"),
        ui = {
          window = {
            width = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
            height = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
            align = "center", -- "center", "top-left", "top-right", "bottom-left", "bottom-right", "top", "bottom", "left", "right"
            relative = "editor",
            zindex = 50,
            border = "rounded", -- "none", "single", "double", "rounded", "solid", "shadow"
          },
          wo = { -- window-scoped options (vim.wo)
            winhl = "Normal:MCPHubNormal,FloatBorder:FloatBorder",
          },
        },
      })
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "j-hui/fidget.nvim",
    },
    opts = {
      strategies = {},
    },
    keys = {
      { "<leader>a", mode = { "n", "v" }, "", desc = "ai" },
      { "<leader>ap", mode = { "n", "v" }, "<cmd>CodeCompanionActions<cr>", desc = "Actions" },
      {
        "<leader>ac",
        mode = { "n" },
        function()
          local input = vim.fn.input("Enter argument: ")
          if input ~= "" then
            vim.cmd("CodeCompanionCmd " .. input)
          end
        end,
        desc = "Cmd",
      },

      { "<leader>aa", mode = { "n", "v" }, "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle" },
    },
    config = function()
      require("codecompanion").setup({
        prompt_library = require("prompt").getPrompts(),
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              -- MCP Tools
              make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
              show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
              add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
              show_result_in_chat = true, -- Show tool results directly in chat buffer
              format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
              -- MCP Resources
              make_vars = true, -- Convert MCP resources to #variables for prompts
              -- MCP Prompts
              make_slash_commands = true, -- Add MCP prompts as /slash commands
            },
          },
        },
        display = {
          chat = {
            auto_scroll = true,
            start_in_insert_mode = false,
            window = {
              layout = "vertical", -- float|vertical|horizontal|buffer
              border = "single", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
              height = 0.4,
              width = 0.4,
              relative = "editor",
              full_height = true, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
              title = " Codecompanion chat ", -- title of chat window
            },
          },
          action_palette = {
            width = 95,
            height = 10,
            prompt = "Prompt ", -- Prompt used for interactive LLM calls
            provider = "default", -- default|telescope|mini_pick
            opts = {
              show_default_actions = true, -- Show the default actions in the action palette?
              show_default_prompt_library = true, -- Show the default prompt library in the action palette?
            },
          },
        },
        opts = {
          log_level = "DEBUG",
          language = "Chinese",
        },
        adapters = {
          deepseek = function()
            return require("codecompanion.adapters").extend("deepseek", {
              env = {
                api_key = "DEEPSEEK_API_KEY",
              },
              schema = {
                model = {
                  default = "deepseek-chat",
                },
              },
            })
          end,
        },
        -- 配置适配器设置
        strategies = {
          chat = {
            adapter = "deepseek",
            tools = {},
            roles = {
              ---@type string|fun(adapter: CodeCompanion.Adapter): string
              llm = function(adapter)
                return "AI (" .. adapter.formatted_name .. ")"
              end,
              ---@type string
              user = "User",
            },
            keymaps = {
              send = {
                modes = { n = "<CR>", i = "<C-s>" },
              },
              close = {
                modes = { n = "<C-c>", i = "<C-c>" },
              },
              clear = {
                modes = {
                  n = "<leader>ax",
                  i = "<leader>ax",
                },
                callback = "keymaps.clear",
                description = "Code Companion - Clear",
              },
              change_adapter = {
                modes = {
                  n = "<leader>am",
                  i = "<leader>am",
                },
                index = 15,
                callback = "keymaps.change_adapter",
                description = "Code Companion - ChangeAdapter",
              },
            },
          },
          inline = {
            adapter = "copilot",
          },
          cmd = {
            adapter = "copilot",
          },
        },
      })
    end,
  },
}

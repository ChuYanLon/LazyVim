return {
  {
    "olimorris/codecompanion.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter"
    },
    opts = {
      strategies = {},
    },
    config = function()
      require("codecompanion").setup({
        prompt_library = require("lazyvim.prompt").getPrompts(),
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

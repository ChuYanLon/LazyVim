local function deepMerge(t1, t2)
  local result = {}
  for k, v in pairs(t1) do
    result[k] = type(v) == "table" and deepMerge({}, v) or v
  end
  for k, v in pairs(t2) do
    if type(v) == "table" and type(result[k]) == "table" then
      result[k] = deepMerge(result[k], v)
    else
      result[k] = v
    end
  end
  return result
end
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
    optional = true,
    config = function(_,opts)
      require("codecompanion").setup(deepMerge({
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
              show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
              add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
              show_result_in_chat = true, -- Show tool results directly in chat buffer
              format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
              make_vars = true, -- Convert MCP resources to #variables for prompts
              make_slash_commands = true, -- Add MCP prompts as /slash commands
            },
          },
        },
      },opts or {}))
    end,
  },
}

{
  {
    "ChuYanLon/vimwiki",
    branch = "local-dev",
    lazy = true,
    event = "VeryLazy",
    keys = {
      {"<leader>m<leader>","",desc="VimwikiAdvanced"},
      {
        "<leader>ms",
        function()
          local wikis = vim.fn["vimwiki#base#ui_select"]()

          if vim.tbl_isempty(wikis) then
            vim.notify("No Vimwiki configured.", vim.log.levels.WARN)
            return
          end

          local items = {}
          for _, wiki in ipairs(wikis) do
            local display = string.format("%s", wiki.path)
            table.insert(items, display)
          end

          vim.ui.select(items, {
            prompt = "Select Vimwiki:",
            format_item = function(item)
              return item
            end,
          }, function(_, idx)
            if not idx then
              return
            end
            vim.fn["vimwiki#base#goto_index"](idx)
          end)
        end,
        desc = "VimwikiSelect",
        noremap = false,
        silent = true,
      },
    },
    init = function()
      vim.g.vimwiki_global_ext = 0
      vim.g.vimwiki_map_prefix = "<Leader>m"
      vim.g.vimwiki_ext2syntax = {
        [".md"] = "markdown",
        [".markdown"] = "markdown",
        [".mdown"] = "markdown",
      }
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        {
          mode = { "n", "x" },
          { "<leader>m", desc = "wiki", icon = " " }
        },
      },
    },
  }
}

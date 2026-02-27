return {
  {
    "neo451/feed.nvim",
    lazy = true,
    cmd = "Feed",
    keys = {
      { "<leader>kk", "<cmd>Feed index<cr>", { desc = "rss" } },
      { "<leader>kt", "<cmd>Feed list<cr>", { desc = "tag" } },
      { "<leader>kS", "<cmd>Feed sync!<cr>", { desc = "sync" } },
      { "<leader>ku", "<cmd>Feed update<cr>", { desc = "update" } },
      { "<leader>ko", "<cmd>Feed log<cr>", { desc = "log" } },
      { "<leader>ks", "<cmd>Feed search<cr>", { desc = "search" } },
      { "<leader>kl", "<cmd>Feed<cr>", { desc = "list" } },
    },
    config = function()
      require("feed").setup({
        ui = {
          order = { "date", "feed", "title", "reading_time" },
          reading_time = {
            color = "Comment",
            format = function(id, db)
              local cpm = 1000 -- set to whatever you like
              local content = db:get(id):gsub("%s+", " ") -- reads the entry content
              local chars = vim.fn.strchars(content)
              local time = math.ceil(chars / cpm)
              return string.format("(%s min)", time)
            end,
          },
        },
        feeds = vim.g.rss_feeds and vim.g.rss_feeds or {},
      })
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        {
          mode = { "n", "x" },
          { "<leader>k", desc = "rss", icon = " " },
        },
      },
    },
  },
}

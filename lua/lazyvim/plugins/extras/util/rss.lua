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
    config = function(_,opts)
      require("feed").setup(deepMerge({
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
        }
      },opts or {}))
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

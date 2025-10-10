return {
  "danymat/neogen",
  dependencies = LazyVim.has("mini.snippets") and { "mini.snippets" } or {},
  cmd = "Neogen",
  keys = {
    {
      "<leader>cn",
      "",
      desc = "Generate Annotations (Neogen)",
    },
    {
      "<leader>cnf",
      function()
        require("neogen").generate({ type = "func" })
      end,
      desc = "Generate func Annotations (Neogen)",
    },
    {
      "<leader>cnc",
      function()
        require("neogen").generate({ type = "class" })
      end,
      desc = "Generate class Annotations (Neogen)",
    },
    {
      "<leader>cnt",
      function()
        require("neogen").generate({ type = "type" })
      end,
      desc = "Generate type Annotations (Neogen)",
    },
    {
      "<leader>cne",
      function()
        require("neogen").generate({ type = "file" })
      end,
      desc = "Generate file Annotations (Neogen)",
    },
  },
  opts = function(_, opts)
    if opts.snippet_engine ~= nil then
      return
    end

    local map = {
      ["LuaSnip"] = "luasnip",
      ["mini.snippets"] = "mini",
      ["nvim-snippy"] = "snippy",
      ["vim-vsnip"] = "vsnip",
    }

    for plugin, engine in pairs(map) do
      if LazyVim.has(plugin) then
        opts.snippet_engine = engine
        return
      end
    end

    if vim.snippet then
      opts.snippet_engine = "nvim"
    end
  end,
}

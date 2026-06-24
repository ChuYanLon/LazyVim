return {
  {
    "saghen/blink.cmp",
    enabled = false,
    optional = true,
  },
  {
    "neovim/nvim-lspconfig",
    enabled = false,
    optional = true,
  },
  {
    "mason-org/mason.nvim",
    enabled = false,
    optional = true,
  },
  {
    "neoclide/coc.nvim",
    branch = "release",
    event = "VeryLazy",
    build = {
      ":CocInstall -sync coc-json coc-tsserver",
    },
    config = function()
      vim.g.coc_global_extensions = {
        "coc-json",
        "coc-tsserver",
      }
    end,
  },
}

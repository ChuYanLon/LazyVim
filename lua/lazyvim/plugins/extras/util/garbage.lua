return {
    "zeioth/garbage-day.nvim",
    dependencies = "neovim/nvim-lspconfig",
    lazy = true,
    event = "VeryLazy",
    opts = {
      notifications = true,
      grace_period = 60 * 10,
      wakeup_delay = 0,
      excluded_lsp_clients = {
        "copilot",
      },
    },
  }

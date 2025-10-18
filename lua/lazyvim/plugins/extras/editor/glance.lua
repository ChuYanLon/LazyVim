return {
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    opts = {
      winbar = {
        enable = true,
      },
      use_trouble_qf = true,
      folds = {
        fold_closed = "",
        fold_open = "",
        folded = true, -- Automatically fold list on startup
      },
      indent_lines = {
        enable = true, -- Show indent guidelines
        icon = "│",
      },
    },
    config = function(_, opts)
      local glance = require("glance")
      local actions = glance.actions
      require("glance").setup(vim.tbl_extend("force", opts, {
        mappings = {
          list = {
            ["<C-h>"] = actions.enter_win("preview"), -- Focus preview window
            ["<C-l>"] = "",
            ["<C-j>"] = actions.next, -- Next item
            ["<C-k>"] = actions.previous, -- Previous item
          },
          preview = {
            ["q"] = actions.close,
            ["<C-l>"] = actions.enter_win("list"), -- Focus preview window
            ["<C-h>"] = "",
            ["<C-j>"] = actions.preview_scroll_win(5), -- Scroll up the preview window
            ["<C-k>"] = actions.preview_scroll_win(-5), -- Scroll down the preview window
          },
        },
      }))
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local Keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- stylua: ignore
      vim.list_extend(Keys, {
        { "gd","<CMD>Glance definitions<CR>",  desc = "Goto Definition", has = "definition" },
        { "gr", "<CMD>Glance references<CR>", nowait = true, desc = "References" },
        { "gi", "<CMD>Glance implementations<CR>", desc = "Goto Implementation" },
        { "gy", "<CMD>Glance type_definitions<CR>",desc = "Goto T[y]pe Definition" },
      })
    end,
  },
}

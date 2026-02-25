local function gen_feed_sections()
  local feed = require("feed")
  local entries = feed.db:filter("+unread #5")
  local sections = {
    { section = "header" },
    { section = "keys", gap = 1, padding = 1 },
    { pane = 2, title = "  Feeds", padding = 1 },
  }

  for _, id in ipairs(entries) do
    table.insert(sections, {
      pane = 2,
      desc = feed.headline(id),
      action = function()
        feed.show_entry({ id = id })
      end,
    })
  end
  table.insert(sections, { section = "startup" })
  return sections
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
    opts = {
      spec = {
        {
          mode = { "n", "x" },
          { "<leader>k", desc = "rss", icon = " " },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>ch",
        function()
          Snacks.image.hover()
        end,
        desc = "image hover",
        noremap = true,
        silent = true,
      },
      {
        "<leader>h",
        function()
          if vim.bo.filetype == "snacks_dashboard" then
            vim.cmd.bdelete()
          else
            Snacks.dashboard()
          end
        end,
        desc = "Dashboard",
        noremap = true,
        silent = true,
      },
    },
    opts = {
      bigfile = {
        notify = true, -- 显示通知，当检测到大文件时
        size = 300 * 1024, -- 大文件大小（300KB）
        line_length = 600, -- 平均行长度（适用于处理压缩或最小化的文件）
      },
      dashboard = {
        bo = {
          bufhidden = "wipe",
          buftype = "nofile",
          buflisted = false,
          filetype = "snacks_dashboard",
          swapfile = false,
          undofile = false,
        },
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
            { icon = "󰈭 ", key = "w", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
            {
              icon = " ",
              key = "d",
              desc = "Create dap launch json",
              action = ":lua require('utils').create_launch_json()",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        },
        formats = {
          footer = { "%s", align = "center" },
          header = { "%s", align = "center" },
          file = function(item, ctx)
            local fname = vim.fn.fnamemodify(item.file, ":~")
            fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
            if #fname > ctx.width then
              local dir = vim.fn.fnamemodify(fname, ":h")
              local file = vim.fn.fnamemodify(fname, ":t")
              if dir and file then
                file = file:sub(-(ctx.width - #dir - 2))
                fname = dir .. "/…" .. file
              end
            end
            local dir, file = fname:match("^(.*)/(.+)$")
            return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
          end,
        },
        sections = gen_feed_sections(),
      },
      image = {
        formats = {
          "png",
          "jpg",
          "jpeg",
          "gif",
          "bmp",
          "webp",
          "tiff",
          "heic",
          "avif",
          "mp4",
          "mov",
          "avi",
          "mkv",
          "webm",
          "pdf",
          "svg",
          "ico",
        },
        doc = {
          enabled = false,
          conceal = function(lang)
            return lang == "markdown"
          end,
        },
      },
      picker = {
        enabled = true,
        prompt = "   ",
        icons = {
          files = {
            enabled = true, -- show file icons
            dir = "",
            dir_open = "",
            file = "󰈚",
          },
        },
        win = {
          input = {
            keys = {
              ["<Tab>"] = { "select_and_prev", mode = { "i", "n" } },
              ["<S-Tab>"] = { "select_and_next", mode = { "i", "n" } },
              ["<A-Up>"] = { "history_back", mode = { "n", "i" } },
              ["<A-Down>"] = { "history_forward", mode = { "n", "i" } },
              ["<A-j>"] = { "list_down", mode = { "n", "i" } },
              ["<A-k>"] = { "list_up", mode = { "n", "i" } },
              ["<C-u>"] = { "preview_scroll_up", mode = { "n", "i" } },
              ["<C-d>"] = { "preview_scroll_down", mode = { "n", "i" } },
              ["<A-u>"] = { "list_scroll_up", mode = { "n", "i" } },
              ["<A-d>"] = { "list_scroll_down", mode = { "n", "i" } },
              ["<c-j>"] = { "list_down", mode = { "n", "i" } },
              ["<c-k>"] = { "list_up", mode = { "n", "i" } },
            },
          },
        },
        layout = {
          preset = function()
            return vim.o.columns >= 120 and "telescope" or "vertical"
          end,
        },
        layouts = {
          telescope = {
            reverse = false,
            layout = {
              box = "horizontal",
              backdrop = false,
              height = 0.8,
              width = 0.8,
              border = "none",
              {
                box = "vertical",
                {
                  win = "input",
                  height = 1,
                  border = "rounded",
                  title = "{title} {live} {flags}",
                  title_pos = "center",
                },
                { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
              },
              {
                win = "preview",
                title = "{preview:Preview}",
                width = 0.51,
                border = "rounded",
                title_pos = "center",
              },
            },
          },
        },
        sources = {
          files = {
            exclude = { "books", "wikis" },
          },
          grep = {
            exclude = { "books", "wikis" },
          },
          explorer = {
            include = { "*.env.*", "local.sh", ".dumi", ".vscode" },
            exclude = { "books", "wikis" },
            layout = {
              preview = "main",
              layout = {
                backdrop = false,
                width = 40, -- Pfff.. 40. I have 60!
                min_width = 40,
                height = 0,
                position = "left",
                box = "vertical",
                { win = "list", border = "none" },
              },
            },
          },
          lines = {
            layout = {
              preset = function()
                return vim.o.columns >= 120 and "telescope" or "vertical"
              end,
            },
          },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.dashboard.sections = vim.tbl_deep_extend("force", opts.dashboard.sections, gen_feed_sections())
      return opts
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        {
          mode = { "n", "x" },
          { "<leader>k", desc = "rss", icon = " " }
        },
      },
    },
  }
}

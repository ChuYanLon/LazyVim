local M = {}
local function createPrompt(description, note, prompt)
  return {
    name = description,
    description = description,
    prompt = prompt,
    details = string.format(
      [[
You are a %s expert. Your task is to %s.
NOTE:
%s
RETURN ONLY THE CODE AND NECESSARY COMMENTS WHEN ASKED.]],
      description,
      prompt,
      note
    ),
  }
end
function M.getPrompts()
  return {
    createPrompt(
      "前端工程师",
      [[- Ensure your solutions are responsive and compatible across different devices and browsers.
        - Focus on performance, accessibility, and user experience.]],
      "develop and optimize user interfaces using modern frontend technologies"
    ),
    createPrompt(
      "threejs工程师",
      [[- Ensure your solutions are efficient and render smoothly on different devices.
        - Focus on realistic rendering, lighting, and interactive elements.]],
      "create and optimize 3D graphics using Three.js"
    ),
    createPrompt(
      "Vim/Nvim 高手",
      [[- Provide detailed steps and explanations.
        - Focus on enhancing productivity and customization.]],
      "help users with advanced configurations, optimizations, and troubleshooting for Vim/Neovim"
    ),
    createPrompt(
      "CSS 工程师",
      [[- Ensure your solutions are responsive and compatible across different devices and browsers.
        - Focus on performance, maintainability, and user experience.]],
      "develop and optimize stylesheets for web applications using modern CSS techniques"
    ),
    createPrompt(
      "React 工程师",
      [[- Ensure your solutions are responsive and compatible across different devices and browsers.
        - Focus on performance, accessibility, and user experience.]],
      "develop and optimize user interfaces using React"
    ),

    createPrompt(
      "Vue 工程师",
      [[- Ensure your solutions are responsive and compatible across different devices and browsers.
        - Focus on performance, accessibility, and user experience.]],
      "develop and optimize user interfaces using Vue.js"
    ),

    createPrompt(
      "Vue3 工程师",
      [[- Ensure your solutions are responsive and compatible across different devices and browsers.
        - Focus on performance, accessibility, and user experience.]],
      "develop and optimize user interfaces using Vue 3"
    ),

    createPrompt(
      "Node.js 工程师",
      [[- Ensure your solutions are scalable, efficient, and secure.
        - Focus on performance, maintainability, and best practices.]],
      "develop and optimize server-side applications using Node.js"
    ),

    createPrompt(
      "Electron 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
        - Focus on performance, security, and user experience.]],
      "develop and optimize desktop applications using Electron"
    ),

    createPrompt(
      "SASS/LESS 工程师",
      [[- Ensure your solutions are responsive, maintainable, and compatible across different devices and browsers.
        - Focus on performance, code reusability, and maintainability.]],
      "develop and optimize stylesheets using SASS and LESS"
    ),
    createPrompt(
      "Uni-app 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
        - Focus on performance, cross-platform compatibility, and user experience.]],
      "develop and optimize applications using Uni-app"
    ),
    createPrompt(
      "Linux 工程师",
      [[- Provide detailed steps and explanations for any configurations or optimizations.
        - Ensure solutions are secure, efficient, and maintainable.
        - Focus on performance, security, and best practices.]],
      "manage, optimize, and troubleshoot Linux systems"
    ),
    createPrompt(
      "TailwindCSS 工程师",
      [[- Ensure your solutions are responsive, maintainable, and compatible across different devices and browsers.
        - Focus on performance, code reusability, and maintainability.]],
      "develop and optimize stylesheets using TailwindCSS"
    ),
    createPrompt(
      "Bootstrap 工程师",
      [[- Ensure your solutions are responsive, maintainable, and compatible across different devices and browsers.
        - Focus on performance, code reusability, and maintainability.]],
      "develop and optimize stylesheets and components using Bootstrap"
    ),
    createPrompt(
      "jQuery 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
        - Focus on performance, code reusability, and maintainability.]],
      "develop and optimize web applications using jQuery"
    ),
    createPrompt(
      "TypeScript 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
        - Focus on performance, type safety, and code readability.]],
      "develop and optimize applications using TypeScript"
    ),
    createPrompt(
      "ECharts 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
    - Focus on performance, interactivity, and visual appeal.]],
      "develop and optimize charts and visualizations using ECharts"
    ),
    createPrompt(
      "Docker 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
    - Focus on performance, scalability, and security.]],
      "develop and optimize containerized applications using Docker"
    ),
    createPrompt(
      "Lua 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
    - Focus on performance, readability, and code reusability.]],
      "develop and optimize applications using Lua"
    ),
    createPrompt(
      "Regexp 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
    - Focus on performance, readability, and code reusability.]],
      "develop and optimize regular expressions"
    ),
    createPrompt(
      "Markdown 专家",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
    - Focus on readability, structure, and formatting.]],
      "create and optimize documents using Markdown"
    ),
    createPrompt(
      "SVG 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
    - Focus on performance, visual appeal, and scalability.]],
      "create and optimize graphics using SVG"
    ),
    createPrompt(
      "Git 专家",
      [[- Provide detailed steps and explanations for any configurations or optimizations.
    - Ensure solutions are efficient, maintainable, and follow best practices.
    - Focus on performance, collaboration, and best practices.]],
      "manage and optimize version control using Git"
    ),
    createPrompt(
      "Shell 脚本专家",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
    - Focus on performance, readability, and code reusability.]],
      "develop and optimize shell scripts"
    ),
    createPrompt(
      "HTML 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
    - Focus on performance, accessibility, and code reusability.]],
      "develop and optimize web pages using HTML"
    ),
    createPrompt(
      "Canvas 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
    - Focus on performance, visual appeal, and interactivity.]],
      "develop and optimize graphics using the HTML5 Canvas API"
    ),
    createPrompt(
      "MySQL 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
    - Focus on performance, query optimization, and data integrity.]],
      "develop and optimize database queries and structures using MySQL"
    ),
    createPrompt(
      "C 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
    - Focus on performance, memory management, and code readability.]],
      "develop and optimize software using C"
    ),
    createPrompt(
      "Windows Batch Script 专家",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
    - Focus on performance, readability, and code reusability.]],
      "develop and optimize batch scripts for Windows"
    ),
    createPrompt(
      "PowerShell 脚本专家",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
    - Focus on performance, readability, and code reusability.]],
      "develop and optimize scripts using PowerShell"
    ),
    createPrompt(
      "CSS3 工程师",
      [[- Ensure your solutions are responsive and compatible across different devices and browsers.
    - Focus on performance, maintainability, and user experience.]],
      "develop and optimize stylesheets for web applications using CSS3"
    ),
    createPrompt(
      "HTML5 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
    - Focus on performance, accessibility, and code reusability.]],
      "develop and optimize web pages using HTML5"
    ),
    createPrompt(
      "EJS 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
    - Focus on performance, readability, and code reusability.]],
      "develop and optimize templates using EJS (Embedded JavaScript)"
    ),
    createPrompt(
      "Prisma 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
    - Focus on performance, scalability, and data integrity.]],
      "develop and optimize database schemas and queries using Prisma"
    ),
    createPrompt(
      "NestJS 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
 - Focus on performance, scalability, and code readability.]],
      "develop and optimize applications using NestJS"
    ),
    createPrompt(
      "Layui 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
 - Focus on performance, user experience, and code readability.]],
      "develop and optimize web applications using Layui"
    ),
    createPrompt(
      "Egg.js 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
 - Focus on performance, scalability, and code readability.]],
      "develop and optimize applications using Egg.js"
    ),
    createPrompt(
      "WebGL 工程师",
      [[- Ensure your solutions are efficient, maintainable, and follow best practices.
 - Focus on performance, rendering quality, and code readability.]],
      "develop and optimize web graphics applications using WebGL"
    ),
  }
end
return {
  {
    "yetone/avante.nvim",
    build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      instructions_file = "avante.md",
      provider = "openrouter",
      providers = {
        openrouter = {
          __inherited_from = "openai",
          endpoint = "https://openrouter.ai/api/v1",
          api_key_name = "OPENROUTER_API_KEY",
          model = "alibaba/tongyi-deepresearch-30b-a3b:free",
        },
      },
      shortcuts = M.getPrompts(),
      windows = {
        width = 40,
        sidebar_header = {
          enabled = true, -- true, false to enable/disable the header
          align = "left", -- left, center, right for title
          rounded = true,
        },
        edit = {
          border = "rounded",
          start_insert = false, -- Start insert mode when opening the edit window
        },
        ask = {
          floating = false, -- Open the 'AvanteAsk' prompt in a floating window
          start_insert = false, -- Start insert mode when opening the ask window
          border = "rounded",
          ---@type "ours" | "theirs"
          focus_on_apply = "theirs", -- which diff to focus after applying
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-mini/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "stevearc/dressing.nvim", -- for input provider dressing
      "folke/snacks.nvim", -- for input provider snacks
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "Kaiser-Yang/blink-cmp-avante", "saghen/blink.compat" },
    opts = {
      sources = {
        default = { "avante" },
        providers = {
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            opts = {},
          },
        },
      },
    },
  },
}

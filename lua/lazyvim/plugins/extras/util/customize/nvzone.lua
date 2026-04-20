return {
  {
    "nvzone/showkeys",
    lazy = true,
    cmd = "ShowkeysToggle",
    opts = {
      winhl = "FloatBorder:FloatBorder,Normal:Normal",
    },
  },
  {
    "nvzone/typr",
    lazy = true,
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },
  {
    "nvzone/timerly",
    lazy = true,
    dependencies = "nvzone/volt",
    cmd = "TimerlyToggle",
    opts = {},
  },
  {
    "nvzone/minty",
    lazy = true,
    cmd = { "Shades", "Huefy" },
  },
}

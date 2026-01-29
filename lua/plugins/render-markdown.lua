return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "quarto" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    -- Enable rendering by default
    enabled = true,
    -- Maximum file size to render (in MB)
    max_file_size = 10.0,
    -- Debounce time for updates (in ms)
    debounce = 100,
    -- Preset rendering style: 'normal' or 'obsidian'
    preset = "normal",
    -- Render markdown in normal mode
    render_modes = { "n", "c" },
    -- Anti-conceal settings
    anti_conceal = {
      enabled = true,
    },
    -- Heading settings
    heading = {
      enabled = true,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      backgrounds = {
        "RenderMarkdownH1Bg",
        "RenderMarkdownH2Bg",
        "RenderMarkdownH3Bg",
        "RenderMarkdownH4Bg",
        "RenderMarkdownH5Bg",
        "RenderMarkdownH6Bg",
      },
    },
    -- Code block settings
    code = {
      enabled = true,
      style = "full",
      width = "block",
      left_pad = 2,
      right_pad = 2,
    },
    -- Checkbox settings
    checkbox = {
      enabled = true,
      unchecked = { icon = "󰄱 " },
      checked = { icon = "󰱒 " },
    },
    -- Bullet list settings
    bullet = {
      enabled = true,
      icons = { "●", "○", "◆", "◇" },
    },
  },
}

-- bootstrap lazy.nvim, LazyVim and your plugins

require("config.lazy")

require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    disable = { "latex" }, -- Disable Tree-sitter highlighting for LaTeX files
  },
})

require("render-markdown").setup({
  completions = { lsp = { enabled = true } },
})

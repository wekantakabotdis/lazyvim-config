return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "html" })

      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
      opts.highlight.disable = { "latex" }
      
      opts.indent = opts.indent or { enable = true }
    end,
  },
}

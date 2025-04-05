return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Ensure the HTML parser is installed
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "html" })

      -- Enable syntax highlighting and indentation for HTML
      opts.highlight = opts.highlight or { enable = true }
      opts.indent = opts.indent or { enable = true }
    end,
  },
}

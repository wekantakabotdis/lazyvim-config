-- Disable auto-formatting on save
return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- Disable formatting on save for all filetypes
      opts.format_on_save = false
      return opts
    end,
  },
  {
    "mfussenegger/nvim-lint",
    enabled = false, -- Disable linting if it's enabled by default in LazyVim
  },
  -- Override LazyVim's default format setup to disable auto-format on save
  {
    "LazyVim/LazyVim",
    opts = {
      format = {
        enabled = false, -- This disables the auto-formatting functionality
      },
    },
  },
}
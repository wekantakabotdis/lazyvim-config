return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        r_language_server = {
          filetypes = { "r", "rmd" },
        },
        pylsp = {
          enabled = false,
          mason = false,
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "basic",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "pyright") then
        table.insert(opts.ensure_installed, "pyright")
      end
    end,
  },
}

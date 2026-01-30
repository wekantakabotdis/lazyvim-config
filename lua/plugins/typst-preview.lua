return {
  "wekantakabotdis/typst-preview.nvim",
  ft = { "typst" },
  opts = {},
  config = function(_, opts)
    require("typst-preview").setup(opts)

    -- Auto-start preview when opening typst files
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.typ",
      callback = function()
        require("typst-preview").start()
        vim.keymap.set("n", "<leader>tr", function()
          require("typst-preview").refresh()
        end, { buffer = true, desc = "Refresh preview" })
      end,
      once = true,
    })
  end,
}

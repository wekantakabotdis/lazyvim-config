return {
  dir = vim.fn.expand("~/Desktop/typst-preview.nvim"),
  name = "typst-preview.nvim",
  ft = { "typst" },
  opts = {},
  config = function(_, opts)
    require("typst-preview").setup(opts)

    -- Auto-start preview when opening typst files
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.typ",
      callback = function()
        if not vim.g.typst_preview_started then
          require("typst-preview").start()
          vim.g.typst_preview_started = true
        end
        vim.keymap.set("n", "<leader>tr", function()
          require("typst-preview").refresh()
        end, { buffer = true, desc = "Refresh preview" })
        vim.keymap.set("n", "<leader>tc", function()
          if vim.fn.executable("typst") == 0 then
            vim.notify("`typst` CLI not found in PATH", vim.log.levels.ERROR)
            return
          end

          vim.cmd("write")
          local input = vim.api.nvim_buf_get_name(0)
          local output = vim.fn.fnamemodify(input, ":r") .. ".pdf"
          vim.fn.jobstart({ "typst", "compile", input, output }, { detach = true })
          vim.notify("Compiling Typst to " .. output, vim.log.levels.INFO)
        end, { buffer = true, desc = "Compile Typst to PDF" })
      end,
    })
  end,
}

return {
  "stevearc/oil.nvim",
  opts = {
    keymaps = {
      ["<C-h>"] = false, -- Disable Ctrl+h
    },
  },
  config = function()
    require("oil").setup({
      keymaps = {
        ["<C-h>"] = false, -- Disable Ctrl+h
      },
    })

    -- Automatically open preview on Oil buffer enter
    vim.api.nvim_create_autocmd("User", {
      pattern = "OilEnter",
      callback = function(args)
        local oil = require("oil")
        if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
          oil.open_preview()
        end
      end,
    })
  end,
  dependencies = {
    { "echasnovski/mini.icons", opts = {} },
  },
  lazy = false,
}

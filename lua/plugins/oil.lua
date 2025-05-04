return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = {
    { "echasnovski/mini.icons", opts = {} },
  },
  opts = {
    keymaps = {
      ["<C-h>"] = false,
    },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
  },
  config = function(_, opts)
    require("oil").setup(opts)

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
}

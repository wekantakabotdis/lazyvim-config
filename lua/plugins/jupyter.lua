return {
  -- Image rendering for inline plots (requires kitty, wezterm, or similar)
  {
    "3rd/image.nvim",
    dependencies = { "luarocks.nvim" },
    opts = {
      backend = "kitty", -- or "ueberzug" for X11
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "quarto", "ipynb" },
        },
      },
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },

  -- Luarocks dependency for image.nvim
  {
    "vhyrro/luarocks.nvim",
    priority = 1001,
    opts = {
      rocks = { "magick" },
    },
  },

  -- ipynb.nvim - VS Code-like Jupyter notebook editing experience
  -- Provides proper cell rendering, inline outputs, and modal editing
  {
    "meatballs/ipynb.nvim",
    ft = { "ipynb" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("ipynb").setup({
        -- Show cell markers
        show_cell_markers = true,
        -- Render markdown cells
        render_markdown = true,
      })
    end,
    keys = {
      { "<leader>no", "<cmd>IpynbOpen<cr>", desc = "Notebook: [o]pen" },
      { "<leader>ns", "<cmd>IpynbSave<cr>", desc = "Notebook: [s]ave" },
    },
  },

  -- NotebookNavigator for cell navigation and execution
  {
    "GCBallesteros/NotebookNavigator.nvim",
    dependencies = {
      "nvim-mini/mini.comment",
      "benlubas/molten-nvim",
    },
    event = "VeryLazy",
    config = function()
      local nn = require("notebook-navigator")
      nn.setup({
        -- Code cell marker (Jupyter-style)
        cell_markers = {
          python = "# %%",
        },
        -- Show cell boundaries
        show_cell_markers = true,
      })

      -- Cell navigation keymaps
      vim.keymap.set("n", "]c", function() nn.move_cell("d") end, { desc = "Next cell" })
      vim.keymap.set("n", "[c", function() nn.move_cell("u") end, { desc = "Previous cell" })
      vim.keymap.set("n", "<leader>jc", function() nn.run_cell() end, { desc = "Jupyter: run [c]ell" })
      vim.keymap.set("n", "<leader>jC", function() nn.run_and_move() end, { desc = "Jupyter: run [C]ell and move" })
    end,
  },

  -- Mini.comment for commenting (NotebookNavigator dependency)
  {
    "nvim-mini/mini.comment",
    event = "VeryLazy",
    opts = {},
  },
}

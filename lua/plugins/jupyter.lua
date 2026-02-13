return {
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    opts = {
      style = "quarto",
      output_extension = "qmd",
      force_ft = "quarto",
      custom_language_formatting = {
        python = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto",
        },
        r = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto",
        },
      },
    },
  },

  {
    "3rd/image.nvim",
    dependencies = { "luarocks.nvim" },
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "quarto", "python", "r", "ipynb" },
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

  {
    "vhyrro/luarocks.nvim",
    priority = 1001,
    opts = {
      rocks = { "magick" },
    },
  },

  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    dependencies = { "3rd/image.nvim" },
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_image_location = "virt"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
      vim.g.molten_output_win_hide_on_leave = false
      vim.g.molten_cover_empty_lines = true
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_output_virt_lines = true
      vim.g.molten_virt_lines_off_by_1 = false
      vim.g.molten_auto_init_behavior = "init"
    end,
    config = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "MoltenInitPost",
        callback = function()
          pcall(vim.fn.MoltenUpdateOption, "auto_open_output", false)
          pcall(vim.fn.MoltenUpdateOption, "output_win_hide_on_leave", false)
          pcall(vim.fn.MoltenUpdateOption, "cover_empty_lines", true)
          pcall(vim.fn.MoltenUpdateOption, "virt_text_output", true)
          pcall(vim.fn.MoltenUpdateOption, "output_virt_lines", true)
          pcall(vim.fn.MoltenUpdateOption, "virt_lines_off_by_1", false)
          pcall(vim.fn.MoltenUpdateOption, "image_location", "virt")
        end,
      })

      local function maybe_auto_init_kernel(bufnr)
        if vim.b[bufnr].molten_auto_init_done then
          return
        end

        local file = vim.api.nvim_buf_get_name(bufnr)
        if not file:match("%.ipynb$") then
          return
        end

        vim.b[bufnr].molten_auto_init_done = true

        local kernel_name = "python3"
        local ok_read, lines = pcall(vim.fn.readfile, file)
        if ok_read and lines and #lines > 0 then
          local ok_json, notebook = pcall(vim.json.decode, table.concat(lines, "\n"))
          if ok_json and notebook and notebook.metadata and notebook.metadata.kernelspec then
            kernel_name = notebook.metadata.kernelspec.name or kernel_name
          end
        end

        local ok_kernels, kernels = pcall(vim.fn.MoltenAvailableKernels)
        if ok_kernels and type(kernels) == "table" then
          if vim.tbl_contains(kernels, kernel_name) then
            pcall(vim.cmd, "MoltenInit " .. kernel_name)
            return
          end
          if vim.tbl_contains(kernels, "python3") then
            pcall(vim.cmd, "MoltenInit python3")
            return
          end
        end

        pcall(vim.cmd, "MoltenInit")
      end

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter" }, {
        pattern = "*.ipynb",
        callback = function(args)
          pcall(vim.fn.MoltenUpdateOption, "auto_open_output", false)
          pcall(vim.fn.MoltenUpdateOption, "output_win_hide_on_leave", false)
          pcall(vim.fn.MoltenUpdateOption, "cover_empty_lines", true)
          pcall(vim.fn.MoltenUpdateOption, "virt_text_output", true)
          pcall(vim.fn.MoltenUpdateOption, "output_virt_lines", true)
          pcall(vim.fn.MoltenUpdateOption, "virt_lines_off_by_1", false)
          pcall(vim.fn.MoltenUpdateOption, "image_location", "virt")

          vim.defer_fn(function()
            maybe_auto_init_kernel(args.buf)
          end, 80)
        end,
      })

      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.ipynb",
        callback = function()
          local ok, status = pcall(require, "molten.status")
          if ok and status.initialized() == "Molten" then
            pcall(vim.cmd, "MoltenExportOutput!")
          end
        end,
      })
    end,
  },

}

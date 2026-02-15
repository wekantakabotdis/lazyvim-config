return {
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto", "ipynb" },
    dev = false,
    opts = {
      lspFeatures = {
        enabled = true,
        chunks = "curly",
        languages = { "python", "r", "julia", "bash", "html" },
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      codeRunner = {
        enabled = true,
        default_method = "molten",
      },
    },
    dependencies = {
      {
        "jmbuhr/otter.nvim",
        opts = {
          buffers = {
            preambles = {
              python = {
                "import numpy as np",
                "import pandas as pd",
                "import matplotlib.pyplot as plt",
              },
            },
          },
        },
      },
      "benlubas/molten-nvim",
    },
    config = function(_, opts)
      require("quarto").setup(opts)
      local runner = require("quarto.runner")
      local quarto = require("quarto")
      local otter = require("otter")

      local function ensure_lsp_loaded()
        local ok_lazy, lazy = pcall(require, "lazy")
        if ok_lazy then
          pcall(lazy.load, {
            plugins = {
              "nvim-lspconfig",
              "mason.nvim",
              "mason-lspconfig.nvim",
            },
          })
        end
        pcall(require, "lspconfig")
      end

      local function ensure_runner_ready()
        ensure_lsp_loaded()
        pcall(quarto.activate)
      end

      local function is_notebook_buffer(bufnr)
        local name = vim.api.nvim_buf_get_name(bufnr)
        return name:match("%.ipynb$") ~= nil or name:match("%.qmd$") ~= nil
      end

      local function schedule_notebook_activation(bufnr)
        if not vim.api.nvim_buf_is_valid(bufnr) or vim.b[bufnr].quarto_activate_pending then
          return
        end

        vim.b[bufnr].quarto_activate_pending = true
        vim.defer_fn(function()
          if not vim.api.nvim_buf_is_valid(bufnr) then
            return
          end

          vim.b[bufnr].quarto_activate_pending = false
          local ft = vim.bo[bufnr].filetype
          if ft == "quarto" or ft == "ipynb" then
            ensure_lsp_loaded()
            pcall(quarto.activate)
            return
          end
          if ft == "markdown" and is_notebook_buffer(bufnr) then
            ensure_lsp_loaded()
            pcall(otter.activate, { "python" }, true, true)
          end
        end, 120)
      end

      local function ensure_molten_initialized()
        local ok, status = pcall(require, "molten.status")
        if ok and status.initialized() ~= "Molten" then
          pcall(vim.cmd, "MoltenInit")
        end
      end

      local function apply_molten_output_mode()
        pcall(vim.fn.MoltenUpdateOption, "auto_open_output", false)
        pcall(vim.fn.MoltenUpdateOption, "output_win_hide_on_leave", false)
        pcall(vim.fn.MoltenUpdateOption, "cover_empty_lines", true)
        pcall(vim.fn.MoltenUpdateOption, "virt_text_output", true)
        pcall(vim.fn.MoltenUpdateOption, "output_virt_lines", true)
        pcall(vim.fn.MoltenUpdateOption, "virt_lines_off_by_1", false)
        pcall(vim.fn.MoltenUpdateOption, "image_location", "virt")
      end

      local function move_chunk(direction)
        local bufnr = vim.api.nvim_get_current_buf()
        local cur_line = vim.api.nvim_win_get_cursor(0)[1]
        local last_line = vim.api.nvim_buf_line_count(bufnr)
        local matcher = vim.regex("^\\s*```\\s*{")

        local current_header = nil
        for line_no = cur_line, 1, -1 do
          local line = vim.api.nvim_buf_get_lines(bufnr, line_no - 1, line_no, false)[1] or ""
          if matcher:match_str(line) then
            current_header = line_no
            break
          end
        end

        if direction == "next" then
          local start_line = current_header and (current_header + 1) or (cur_line + 1)
          for line_no = start_line, last_line do
            local line = vim.api.nvim_buf_get_lines(bufnr, line_no - 1, line_no, false)[1] or ""
            if matcher:match_str(line) then
              vim.api.nvim_win_set_cursor(0, { math.min(line_no + 1, last_line), 0 })
              return
            end
          end
        else
          local start_line = current_header and (current_header - 1) or (cur_line - 1)
          for line_no = start_line, 1, -1 do
            local line = vim.api.nvim_buf_get_lines(bufnr, line_no - 1, line_no, false)[1] or ""
            if matcher:match_str(line) then
              vim.api.nvim_win_set_cursor(0, { math.min(line_no + 1, last_line), 0 })
              return
            end
          end
        end
      end

      local activate_group = vim.api.nvim_create_augroup("NotebookOtterActivate", { clear = true })
      vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "InsertLeave", "BufWritePost" }, {
        group = activate_group,
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          if ft == "quarto" or ft == "ipynb" or (ft == "markdown" and is_notebook_buffer(args.buf)) then
            schedule_notebook_activation(args.buf)
          end
        end,
      })

      local current_buf = vim.api.nvim_get_current_buf()
      local current_ft = vim.bo[current_buf].filetype
      if current_ft == "quarto" or current_ft == "ipynb" or (current_ft == "markdown" and is_notebook_buffer(current_buf)) then
        schedule_notebook_activation(current_buf)
      end

      vim.keymap.set("n", "<leader>jn", function() move_chunk("next") end, { desc = "Notebook: [n]ext cell" })
      vim.keymap.set("n", "<leader>jp", function() move_chunk("prev") end, { desc = "Notebook: [p]revious cell" })
      vim.keymap.set("n", "<leader>jc", function()
        ensure_runner_ready()
        ensure_molten_initialized()
        apply_molten_output_mode()
        runner.run_cell()
      end, { desc = "Notebook: run [c]ell", silent = true })
      vim.keymap.set("n", "<leader>jC", function()
        ensure_runner_ready()
        ensure_molten_initialized()
        apply_molten_output_mode()
        runner.run_cell()
        move_chunk("next")
      end, { desc = "Notebook: run cell and move", silent = true })
      vim.keymap.set("n", "<leader>ja", function()
        ensure_runner_ready()
        ensure_molten_initialized()
        apply_molten_output_mode()
        runner.run_all(true)
      end, { desc = "Notebook: run [a]ll cells", silent = true })
      vim.keymap.set("n", "<leader>jl", function()
        ensure_runner_ready()
        ensure_molten_initialized()
        apply_molten_output_mode()
        runner.run_line()
      end, { desc = "Notebook: run [l]ine", silent = true })
      vim.keymap.set("v", "<leader>jv", function()
        ensure_runner_ready()
        ensure_molten_initialized()
        apply_molten_output_mode()
        runner.run_range()
      end, { desc = "Notebook: run [v]isual selection", silent = true })
      vim.keymap.set("n", "<leader>ji", "<cmd>MoltenInit<cr>", { desc = "Notebook: kernel [i]nit", silent = true })
      vim.keymap.set("n", "<leader>js", "<cmd>MoltenShowOutput<cr>", { desc = "Notebook: [s]how output", silent = true })
      vim.keymap.set("n", "<leader>jh", "<cmd>MoltenHideOutput<cr>", { desc = "Notebook: [h]ide output", silent = true })
    end,
  },

  {
    "HakonHarnes/img-clip.nvim",
    event = "BufEnter",
    ft = { "markdown", "quarto", "latex" },
    opts = {
      default = {
        dir_path = "img",
      },
      filetypes = {
        markdown = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          drag_and_drop = {
            download_images = false,
          },
        },
        quarto = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          drag_and_drop = {
            download_images = false,
          },
        },
      },
    },
    config = function(_, opts)
      require("img-clip").setup(opts)
      vim.keymap.set("n", "<leader>ii", ":PasteImage<cr>", { desc = "insert [i]mage from clipboard" })
    end,
  },

  {
    "jbyuki/nabla.nvim",
    keys = {
      { "<leader>qm", ':lua require"nabla".toggle_virt()<cr>', desc = "toggle [m]ath equations" },
    },
  },
}

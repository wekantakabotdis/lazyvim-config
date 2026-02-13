return {
  {
    "nvim-mini/mini.ai",
    init = function()
      if not (LazyVim and LazyVim.mini) then
        return
      end

      LazyVim.mini.ai_whichkey = function(opts)
        local objects = {
          { " ", desc = "whitespace" },
          { '"', desc = '" string' },
          { "'", desc = "' string" },
          { "(", desc = "() block" },
          { ")", desc = "() block with ws" },
          { "<", desc = "<> block" },
          { ">", desc = "<> block with ws" },
          { "?", desc = "user prompt" },
          { "U", desc = "use/call without dot" },
          { "[", desc = "[] block" },
          { "]", desc = "[] block with ws" },
          { "_", desc = "underscore" },
          { "`", desc = "` string" },
          { "a", desc = "argument" },
          { "b", desc = ")]} block" },
          { "c", desc = "fenced code cell" },
          { "C", desc = "class" },
          { "d", desc = "digit(s)" },
          { "e", desc = "CamelCase / snake_case" },
          { "f", desc = "function" },
          { "g", desc = "entire file" },
          { "i", desc = "indent" },
          { "o", desc = "block, conditional, loop" },
          { "q", desc = "quote `\"'" },
          { "t", desc = "tag" },
          { "u", desc = "use/call" },
          { "{", desc = "{} block" },
          { "}", desc = "{} with ws" },
        }

        local ret = { mode = { "o", "x" } }
        local mappings = vim.tbl_extend("force", {}, {
          around = "a",
          inside = "i",
          around_next = "an",
          inside_next = "in",
          around_last = "al",
          inside_last = "il",
        }, opts.mappings or {})
        mappings.goto_left = nil
        mappings.goto_right = nil

        for name, prefix in pairs(mappings) do
          name = name:gsub("^around_", ""):gsub("^inside_", "")
          ret[#ret + 1] = { prefix, group = name }
          for _, obj in ipairs(objects) do
            local desc = obj.desc
            if prefix:sub(1, 1) == "i" then
              desc = desc:gsub(" with ws", "")
            end
            ret[#ret + 1] = { prefix .. obj[1], desc = desc }
          end
        end
        require("which-key").add(ret, { notify = false })
      end
    end,
    opts = function(_, opts)
      local ai = require("mini.ai")

      local function fenced_cell(ai_type)
        local ft = vim.bo.filetype
        if ft ~= "markdown" and ft ~= "quarto" and ft ~= "rmarkdown" then
          return nil
        end

        local cur = vim.api.nvim_win_get_cursor(0)[1]
        local last = vim.api.nvim_buf_line_count(0)
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

        local open_pat = "^%s*```%s*%b{}.*$"
        local close_pat = "^%s*```%s*$"

        local start_line
        for lnum = cur, 1, -1 do
          if lines[lnum]:match(open_pat) then
            start_line = lnum
            break
          end
        end
        if not start_line then
          return nil
        end

        local end_line
        for lnum = start_line + 1, last do
          if lines[lnum]:match(close_pat) then
            end_line = lnum
            break
          end
        end
        if not end_line or cur > end_line then
          return nil
        end

        local from_line = ai_type == "i" and (start_line + 1) or start_line
        local to_line = ai_type == "i" and (end_line - 1) or end_line
        if from_line > to_line then
          return nil
        end

        local to_col = math.max((lines[to_line] or ""):len(), 1)
        return { from = { line = from_line, col = 1 }, to = { line = to_line, col = to_col } }
      end

      opts.custom_textobjects = opts.custom_textobjects or {}
      opts.custom_textobjects.c = fenced_cell
      opts.custom_textobjects.C = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" })
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "ac", mode = { "o", "x" }, desc = "around fenced code cell" },
        { "ic", mode = { "o", "x" }, desc = "inside fenced code cell" },
        { "aC", mode = { "o", "x" }, desc = "around class" },
        { "iC", mode = { "o", "x" }, desc = "inside class" },
      },
    },
  },
}

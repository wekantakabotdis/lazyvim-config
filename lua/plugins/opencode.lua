return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- Recommended for ask() and select().
    -- Required for snacks provider.
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      provider = {
        enabled = "tmux",
        tmux = {
          window_name = "opencode",
          direction = "horizontal",
          size = "30%",
        },
      },
    }

    vim.o.autoread = true

    vim.keymap.set({ "n", "x" }, "<C-a>", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "Ask opencode" })

    vim.keymap.set({ "n", "x" }, "<C-x>", function()
      require("opencode").select()
    end, { desc = "Execute opencode action…" })

    vim.keymap.set({ "n", "x" }, "<leader>ai", function()
      require("opencode").prompt("implement", { submit = true })
    end, { desc = "AI: Implement" })

    vim.keymap.set({ "n", "x" }, "<leader>ar", function()
      require("opencode").prompt("review", { submit = true })
    end, { desc = "AI: Review" })

    vim.keymap.set({ "n", "x" }, "<leader>af", function()
      require("opencode").prompt("fix", { submit = true })
    end, { desc = "AI: Fix diagnostics" })

    vim.keymap.set({ "n", "x" }, "<leader>ad", function()
      require("opencode").prompt("document", { submit = true })
    end, { desc = "AI: Document" })

    vim.keymap.set({ "n", "x" }, "<leader>ae", function()
      require("opencode").prompt("explain", { submit = true })
    end, { desc = "AI: Explain" })

    vim.keymap.set({ "n", "x" }, "<leader>at", function()
      require("opencode").prompt("test", { submit = true })
    end, { desc = "AI: Add tests" })

    vim.keymap.set({ "n", "x" }, "<leader>ao", function()
      require("opencode").prompt("optimize", { submit = true })
    end, { desc = "AI: Optimize" })

    vim.keymap.set({ "n", "x" }, "<leader>ax", function()
      require("opencode").prompt("diagnostics", { submit = true })
    end, { desc = "AI: Explain diagnostics" })

    vim.keymap.set({ "n", "x" }, "<leader>ag", function()
      require("opencode").prompt("diff", { submit = true })
    end, { desc = "AI: Review git diff" })

    vim.keymap.set({ "n", "t" }, "<C-.>", function()
      require("opencode").toggle()
    end, { desc = "Toggle opencode" })

    vim.keymap.set({ "n", "x" }, "go", function()
      return require("opencode").operator("@this ")
    end, { expr = true, desc = "Add range to opencode" })

    vim.keymap.set("n", "goo", function()
      return require("opencode").operator("@this ") .. "_"
    end, { expr = true, desc = "Add line to opencode" })

    vim.keymap.set("n", "<S-C-u>", function()
      require("opencode").command("session.half.page.up")
    end, { desc = "opencode half page up" })

    vim.keymap.set("n", "<S-C-d>", function()
      require("opencode").command("session.half.page.down")
    end, { desc = "opencode half page down" })

    -- Remap increment/decrement since we're using <C-a> and <C-x> for opencode
    vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
    vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
  end,
}

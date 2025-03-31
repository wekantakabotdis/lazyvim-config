-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.keymap.set({ "n" }, "<leader>ci", ":split term://ipython", { desc = "[c]ode repl [i]python" })

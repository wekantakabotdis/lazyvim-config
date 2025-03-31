-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set(
  "n",
  "<leader>ir",
  "i```{r}<Esc>o<Enter>```<Esc>ki",
  { noremap = true, silent = true, desc = "Insert R Code" }
)

vim.keymap.set(
  "n",
  "<leader>ip",
  "i```{python}<Esc>o<Enter>```<Esc>ki",
  { noremap = true, silent = true, desc = "Insert Python Code" }
)

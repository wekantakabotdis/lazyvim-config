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

vim.keymap.set("n", "<leader>qp", ":QuartoPreview<Enter>", { noremap = true, silent = true, desc = "Quarto Preview" })

-- Disable default mappings from vim-tmux-navigator so we can set our own
vim.g.tmux_navigator_no_mappings = 1

-- Normal mode mappings for tmux navigation
vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", { silent = true })
vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>", { silent = true })
vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>", { silent = true })
vim.keymap.set("n", "<C-\\>", ":TmuxNavigatePrevious<CR>", { silent = true })

-- Terminal mode mappings for tmux navigation:
-- These mappings first exit Terminal mode (<C-\><C-n>) then execute the command.
vim.keymap.set("t", "<C-h>", "<C-\\><C-n>:TmuxNavigateLeft<CR>", { silent = true })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n>:TmuxNavigateDown<CR>", { silent = true })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n>:TmuxNavigateUp<CR>", { silent = true })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n>:TmuxNavigateRight<CR>", { silent = true })
vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>:TmuxNavigatePrevious<CR>", { silent = true })

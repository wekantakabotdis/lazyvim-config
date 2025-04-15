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

vim.keymap.set({ "n" }, "<localleader>ti", ":split term://ipython<Enter>", { desc = "new ipython terminal" })
vim.keymap.set({ "n" }, "<localleader>tr", ":split term://R<Enter>", { desc = "new R terminal" })

local runner = require("quarto.runner")
vim.keymap.set("n", "<localleader>rc", runner.run_cell, { desc = "run cell", silent = true })
vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "run cell and above", silent = true })
vim.keymap.set("n", "<localleader>rA", runner.run_all, { desc = "run all cells", silent = true })
vim.keymap.set("n", "<localleader>rl", runner.run_line, { desc = "run line", silent = true })
vim.keymap.set("v", "<localleader>r", runner.run_range, { desc = "run visual range", silent = true })
vim.keymap.set("n", "<localleader>RA", function()
  runner.run_all(true)
end, { desc = "run all cells of all languages", silent = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.rmd",
  callback = function()
    vim.bo.filetype = "quarto"
  end,
})
vim.keymap.set("n", "<localleader>cr", ":Leet run<CR>", { desc = "run tests", silent = true })
vim.keymap.set("n", "<localleader>cs", ":Leet submit<CR>", { desc = "submit", silent = true })
vim.keymap.set("n", "<localleader>cc", ":Leet reset<CR>", { desc = "clear", silent = true })
vim.keymap.set(
  "n",
  "<localleader>c,",
  ":Leet last_submit<CR>",
  { desc = "retrieve last submitted code", silent = true }
)
vim.keymap.set("n", "<localleader>cd", ":Leet desc<CR>", { desc = "toggle description", silent = true })
vim.keymap.set("n", "<localleader>cl", ":Leet lang<CR>", { desc = "language", silent = true })
vim.keymap.set("n", "<localleader>cf", ":Leet list<CR>", { desc = "search question", silent = true })
vim.keymap.set("n", "<localleader>co", ":Leet open<CR>", { desc = "open in browser", silent = true })
vim.keymap.set("n", "<localleader>ct", ":Leet tabs<CR>", { desc = "view tabs", silent = true })
vim.keymap.set("n", "<localleader>ci", ":Leet info<CR>", { desc = "info", silent = true })
vim.keymap.set("n", "<localleader>cb", ":Leet<CR>", { desc = "begin", silent = true })

vim.keymap.set("n", "<leader>mm", function()
  local input_file = vim.fn.expand("%:p")
  local output_file = vim.fn.expand("%:r") .. ".pdf"
  local cmd = string.format(":!pandoc '%s' -t beamer -o '%s'<CR>", input_file, output_file)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), "n", false)
end, {
  noremap = true,
  silent = true,
  desc = "Convert current file to Beamer PDF using Pandoc",
})

vim.keymap.set("n", "<leader>im", function()
  local lines = {
    "---",
    "title: ",
    "author: Yining Chen",
    "theme: Copenhagen",
    "---",
    "",
  }
  vim.api.nvim_put(lines, "l", true, true)
end, {
  noremap = true,
  silent = true,
  desc = "Insert Pandoc metadata header",
})

vim.keymap.set("n", "<leader>p", function()
  local ft = vim.bo.filetype
  if ft == "csv" or ft == "tsv" then
    vim.cmd("CsvViewToggle")
  elseif ft == "markdown" then
    vim.cmd("PeekOpen")
  elseif ft == "quarto" or ft == "rmarkdown" then
    vim.cmd("QuartoPreview")
  else
    print("No preview command mapped for filetype: " .. ft)
  end
end, { silent = true })

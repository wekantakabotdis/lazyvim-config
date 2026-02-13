-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function insert_fenced_code_block(lang)
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, { "```{" .. lang .. "}", "", "```" })
  vim.api.nvim_win_set_cursor(0, { row + 2, 0 })
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>ir", function()
  insert_fenced_code_block("r")
end, { noremap = true, silent = true, desc = "Insert R Code" })

vim.keymap.set("n", "<leader>ip", function()
  insert_fenced_code_block("python")
end, { noremap = true, silent = true, desc = "Insert Python Code" })

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

function insertFullPath()
  local filepath = vim.fn.expand("%")
  vim.fn.setreg("+", filepath) -- write to clippoard
end

vim.keymap.set("n", "<leader>cp", insertFullPath, { noremap = true, silent = true, desc = "Copy path" })

-- Harpoon keymaps (sane defaults)
local mark = require("harpoon.mark") -- Harpoon mark module :contentReference[oaicite:0]{index=0}
local ui = require("harpoon.ui") -- Harpoon UI module :contentReference[oaicite:1]{index=1}

-- Add the current file to Harpoon’s list
vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "󰈙 Add file to Harpoon list" }) -- José Garcia’s recommended default :contentReference[oaicite:2]{index=2}

-- Jump to Harpoon file slots #1–#9 with <leader>1…9
for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    ui.nav_file(i)
  end, { desc = string.format("󱈙 Go to Harpoon file #%d", i) })
end
-- (Optional) Use <leader>o as an alternative toggle key
vim.keymap.set("n", "<leader>o", ui.toggle_quick_menu, { desc = "󰄬 Toggle Harpoon quick-menu" }) -- mirrors <C-e> for consistency :contentReference[oaicite:8]{index=8}

-- (Optional) If you use Telescope, integrate Harpoon marks there
vim.keymap.set("n", "<leader>hm", function()
  require("telescope").extensions.harpoon.marks()
end, { noremap = true, desc = "󰈙 Telescope: Harpoon marks" }) -- Telescope extension from Harpoon :contentReference[oaicite:9]{index=9}

-- Disable auto-formatting command
vim.keymap.set("n", "<leader>uf", function()
  vim.g.autoformat = false
  vim.b.autoformat = false
  vim.notify("Auto-formatting disabled", vim.log.levels.INFO, { title = "Format" })
end, { desc = "Disable auto-formatting" })

-- Paste over visual selection without overwriting register
vim.keymap.set("x", "p", [["_dP]])

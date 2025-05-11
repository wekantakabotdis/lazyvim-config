return {
  "ThePrimeagen/harpoon", -- the Harpoon plugin
  dependencies = {
    "nvim-lua/plenary.nvim", -- required by Harpoon :contentReference[oaicite:0]{index=0}
    "nvim-telescope/telescope.nvim", -- for the Telescope extension :contentReference[oaicite:1]{index=1}
  },
  opts = {
    save_on_toggle = false, -- don’t write marks on every toggle :contentReference[oaicite:2]{index=2}
    save_on_change = true, -- auto-save when marks change :contentReference[oaicite:3]{index=3}
    enter_on_sendcmd = false, -- don’t auto-enter terminal on send :contentReference[oaicite:4]{index=4}
    tmux_autoclose_windows = false, -- leave TMUX windows open :contentReference[oaicite:5]{index=5}
    excluded_filetypes = { "harpoon" }, -- don’t mark Harpoon UI buffers :contentReference[oaicite:6]{index=6}
    mark_branch = true, -- keep branch-specific marks :contentReference[oaicite:7]{index=7}
    tabline = false, -- disable built-in tabline :contentReference[oaicite:8]{index=8}
    tabline_prefix = "   ", -- optional padding :contentReference[oaicite:9]{index=9}
    tabline_suffix = "   ", -- optional padding :contentReference[oaicite:10]{index=10}
  },
  config = function(_, opts)
    require("harpoon").setup(opts) -- initialize Harpoon with your opts :contentReference[oaicite:11]{index=11}
    require("telescope").load_extension("harpoon") -- register the Harpoon picker :contentReference[oaicite:12]{index=12}
  end,
}

return {
  -- Snacks.nvim configuration to disable explorer functionality completely
  -- This will prevent snacks from setting up its file explorer mapping (leader e)
  "folke/snacks.nvim",

  opts = {
    -- Disable specific snacks features that might conflict with oil
    explorer = { enabled = false },  -- This disables the snacks explorer feature
    
    -- Other snacks features can remain enabled
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
}
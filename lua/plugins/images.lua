return {
  "3rd/image.nvim",
  opts = {
    backend = "kitty",
    processor = "magick_cli", -- or "magick_cli"
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
      },
    },
    tmux_show_only_in_active_window = true,
    kitty_method = "normal",
  },
}

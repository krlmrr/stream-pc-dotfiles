-- Show hidden (dot) files and folders by default.
return {
  -- File tree (<leader>e)
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = { position = "right" },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = { ".git" },
        },
      },
    },
  },
  -- File and grep pickers (<leader><space>, <leader>ff, <leader>/)
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        hidden = true,
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
          explorer = { hidden = true },
        },
      },
    },
  },
}

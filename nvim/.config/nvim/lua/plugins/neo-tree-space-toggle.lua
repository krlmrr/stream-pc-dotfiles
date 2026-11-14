-- Space opens/closes the folder under the cursor in neo-tree.
-- (LazyVim disables <space> there so it can act as <leader>; inside the tree
-- it now toggles folders instead.)
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      mappings = {
        ["<space>"] = "toggle_node",
      },
    },
  },
}

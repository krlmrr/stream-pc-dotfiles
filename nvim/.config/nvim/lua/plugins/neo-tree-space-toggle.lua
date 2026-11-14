-- Space opens/closes the folder under the cursor in neo-tree.
-- nowait = false keeps <leader> shortcuts working in the tree: Neovim waits a
-- moment after <space> to see if another key follows (e.g. <space>gg), and only
-- toggles the folder if nothing does.
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      mappings = {
        ["<space>"] = { "toggle_node", nowait = false },
      },
    },
  },
}

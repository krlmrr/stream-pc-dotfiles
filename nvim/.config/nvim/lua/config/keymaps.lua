-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Ctrl+V pastes from the system clipboard, like everywhere else on the desktop.
-- (Visual block mode, normally Ctrl+V, is still on Ctrl+Q.)
vim.keymap.set({ "n", "x" }, "<C-v>", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("i", "<C-v>", "<C-r><C-o>+", { desc = "Paste from clipboard" })
vim.keymap.set("c", "<C-v>", "<C-r>+", { desc = "Paste from clipboard" })

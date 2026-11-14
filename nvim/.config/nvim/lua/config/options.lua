-- Options are automatically loaded before lazy.nvim startup.
require("config.remote_clipboard").setup()

vim.opt.relativenumber = false
vim.g.autoformat = false

-- Don't show partially typed keys (e.g. "gk") in the status line.
vim.opt.showcmd = false

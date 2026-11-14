-- Noice's command-line popup (":" box) and confirm dialog without their own
-- background, so they show the terminal's background like the rest of Neovim.
-- Themes paint these groups with a darker background; this clears it after
-- every colorscheme change (including Omarchy theme switches). Highlights that
-- need a color to be visible (selection, cursor, scrollbar) are left alone.
local function clear_noice_backgrounds()
	for name in pairs(vim.api.nvim_get_hl(0, {})) do
		if name:match("^NoiceCmdline") or name:match("^NoiceConfirm") then
			local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
			if hl.bg then
				hl.bg = nil
				vim.api.nvim_set_hl(0, name, hl)
			end
		end
	end
end

return {
	"folke/noice.nvim",
	init = function()
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("noice_transparent", { clear = true }),
			-- Run after the colorscheme and any plugin that sets Noice colors on it.
			callback = function()
				vim.schedule(clear_noice_backgrounds)
			end,
		})
		vim.schedule(clear_noice_backgrounds)
	end,
}

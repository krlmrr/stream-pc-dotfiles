-- Lazygit (<leader>gg) without its own background, so it shows the terminal's
-- background like the rest of Neovim and like `lzg` outside Neovim.
-- Snacks normally paints floating windows with SnacksNormal (One Dark's
-- darker background); this window uses Normal instead, which is transparent.
return {
	"folke/snacks.nvim",
	opts = {
		styles = {
			lazygit = {
				wo = {
					winhighlight = "Normal:Normal,NormalNC:Normal,FloatBorder:Normal",
				},
			},
		},
	},
}

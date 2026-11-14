-- PHP variables ($team, $this) in the theme's red instead of plain text color,
-- like One Dark does. Parameters and properties keep the theme's own colors.
-- The red comes from the current Omarchy theme, so it follows theme switches.
local function theme_red()
	local path = vim.fn.expand("~/.local/state/omarchy/current/theme/colors.toml")
	local ok, lines = pcall(vim.fn.readfile, path)
	if ok then
		for _, line in ipairs(lines) do
			local hex = line:match('^red%s*=%s*"(#%x%x%x%x%x%x)"')
			if hex then
				return hex
			end
		end
	end
	return "#e06c75" -- One Dark red
end

local function apply()
	local red = theme_red()
	vim.api.nvim_set_hl(0, "@variable.php", { fg = red })
	vim.api.nvim_set_hl(0, "@variable.builtin.php", { fg = red, italic = true })
end

return {
	"nvim-treesitter/nvim-treesitter",
	init = function()
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("php_variable_colors", { clear = true }),
			callback = function()
				vim.schedule(apply)
			end,
		})
		vim.schedule(apply)
	end,
}

-- Status line tweaks on top of LazyVim's defaults.
return {
	"nvim-lualine/lualine.nvim",
	opts = function(_, opts)
		opts.sections = opts.sections or {}

		-- No cursor position (line:column) or "% through file" figure.
		opts.sections.lualine_y = {}

		-- Clock in UTC, 12-hour, labelled with the timezone (e.g. "7:14 PM UTC").
		-- The "!" in os.date formats the time in UTC instead of local time; the
		-- leading zero of the hour is dropped.
		opts.sections.lualine_z = {
			function()
				local time = os.date("!%I:%M %p"):gsub("^0", "")
				return " " .. time .. " UTC"
			end,
		}
	end,
}

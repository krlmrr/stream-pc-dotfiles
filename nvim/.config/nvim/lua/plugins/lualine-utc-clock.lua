-- Status line clock in UTC, 12-hour, labelled with the timezone
-- (e.g. "7:14 PM UTC"). The "!" in os.date formats the time in UTC instead of
-- local time; the leading zero of the hour is dropped.
return {
	"nvim-lualine/lualine.nvim",
	opts = function(_, opts)
		opts.sections = opts.sections or {}
		opts.sections.lualine_z = {
			function()
				local time = os.date("!%I:%M %p"):gsub("^0", "")
				return " " .. time .. " UTC"
			end,
		}
	end,
}

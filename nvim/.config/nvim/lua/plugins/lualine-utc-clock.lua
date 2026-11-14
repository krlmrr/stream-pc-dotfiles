-- Status line clock in UTC, labelled with the timezone (e.g. "19:14 UTC").
-- The "!" in os.date formats the time in UTC instead of local time.
return {
	"nvim-lualine/lualine.nvim",
	opts = function(_, opts)
		opts.sections = opts.sections or {}
		opts.sections.lualine_z = {
			function()
				return " " .. os.date("!%H:%M") .. " UTC"
			end,
		}
	end,
}

-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- No overscroll: don't let a file window scroll past its content.
-- Vertically, the last line stays at the bottom of the window (no empty "~"
-- rows below it); horizontally, the view stops at the end of the longest line
-- on screen. Runs after every scroll (mouse wheel, Ctrl+E/Y, zt, zl, ...).
local function clamp_scroll(win)
	if not vim.api.nvim_win_is_valid(win) then
		return
	end
	local buf = vim.api.nvim_win_get_buf(win)
	if vim.bo[buf].buftype ~= "" or vim.api.nvim_win_get_config(win).relative ~= "" then
		return -- only normal file windows, not terminals, trees or floats
	end
	vim.api.nvim_win_call(win, function()
		local view = vim.fn.winsaveview()
		local info = vim.fn.getwininfo(win)[1]
		local changed = false

		-- Vertical: topline can't go past the point where the last line is at the bottom.
		local max_top = math.max(1, vim.fn.line("$") - vim.api.nvim_win_get_height(win) + 1)
		if view.topline > max_top then
			view.topline = max_top
			changed = true
		end

		-- Horizontal (only matters with 'nowrap'): stop at the longest visible line.
		if not vim.wo[win].wrap and view.leftcol > 0 then
			local longest = 0
			for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, info.topline - 1, info.botline, false)) do
				longest = math.max(longest, vim.fn.strdisplaywidth(line))
			end
			local text_width = info.width - info.textoff
			-- +1 leaves room for the cursor just past the end of a line (insert mode).
			local max_left = math.max(0, longest - text_width + 1)
			if view.leftcol > max_left then
				view.leftcol = max_left
				changed = true
			end
		end

		if changed then
			vim.fn.winrestview({ topline = view.topline, leftcol = view.leftcol })
		end
	end)
end

vim.api.nvim_create_autocmd({ "WinScrolled", "VimResized" }, {
	group = vim.api.nvim_create_augroup("no_overscroll", { clear = true }),
	callback = function()
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			clamp_scroll(win)
		end
	end,
})

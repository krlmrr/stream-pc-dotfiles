-- Markdown is shown fully rendered (headings, tables, checkboxes, code blocks,
-- links) while reading, and switches to the raw text only in insert mode.
return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	ft = { "markdown" },
	opts = {
		-- Render in normal, command-line and terminal modes; insert mode shows raw text.
		render_modes = { "n", "c", "t" },
		-- Keep the line under the cursor rendered too (by default it shows raw).
		anti_conceal = { enabled = false },
	},
}

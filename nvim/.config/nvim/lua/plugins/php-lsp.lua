-- Language servers for PHP / Laravel, installed by Mason:
-- - Intelephense: general PHP (completion, hover, go-to-definition, diagnostics).
-- - Laravel LSP (https://github.com/laravel/lsp): Laravel-aware completion and
--   go-to-definition for routes, views, config, env, translations, etc. Only
--   starts in projects that have an `artisan` file.
return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			intelephense = {},
			laravel_lsp = {},
		},
	},
}

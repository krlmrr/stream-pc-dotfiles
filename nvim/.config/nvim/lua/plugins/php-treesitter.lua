-- Tree-sitter parsers for PHP, so PHP gets full syntax highlighting (classes
-- like `DB::`, methods, properties, types) instead of Vim's basic regex syntax.
return {
	"nvim-treesitter/nvim-treesitter",
	opts = { ensure_installed = { "php", "php_only", "phpdoc" } },
}

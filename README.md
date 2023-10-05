# mySnippets

A collection of snippets for [LuaSnips][luasnip].

Example (with [lazy.nvim][lazy]):

```lua
{
    "L3MON4D3/LuaSnip",
    dependencies = {
        "mathjiajia/mysnippets",
        config = true,
    },
    config = function()
        require("luasnip").setup({
            update_events = "TextChanged,TextChangedI",
            enable_autosnippets = true,
        })
        -- other configuration
    end,
}
```

## mathematics

[lazy]: https://github.com/folke/lazy.nvim
[luasnip]: https://github.com/L3MON4D3/LuaSnip

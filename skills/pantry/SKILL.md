---
name: pantry
description: Use when the user asks about pantry or inventory tracking for their Cooklang collection (config/pantry.conf) - what they have in stock, what is expiring or running low, updating stock after shopping or cooking, or what they can cook with what they have.
---

# Skill: pantry

**Needs the Cook MCP server.** If tools like `pantry_list` and `pantry_update` are not available in this session, stop and tell the user to add the server: `claude mcp add cook -- npx -y @cookmd/mcp`, or the JSON config at https://github.com/cook-md/cook-mcp. Do not guess what is in stock or edit the file by hand instead.

Use when the user asks about pantry or inventory tracking.

The pantry is `config/pantry.conf` (TOML) at the collection root. Cook apps and CookCLI read it from that path, and `shopping_list` subtracts it, so keeping it current makes every shopping list shorter and correct.

## Tools

- `pantry_list` — what's in stock, by section (`section` to show only one, e.g. `"fridge"`).
- `pantry_expiring` — items expiring within `days` (default 7). Plan meals around these.
- `pantry_depleted` — items at or below their `low` threshold: the restock list.
- `pantry_recipes` — what can I cook: recipes fully covered by the pantry, plus partial matches (at least `threshold` % in stock, default 50) with their missing ingredients.
- `pantry_update` — `add`, `update`, `remove` items. Each item has `section` and `name`, plus optional `quantity` (Cooklang quantity, e.g. `"500%g"`, `"2"`), `expire` and `bought` (`YYYY-MM-DD`), `low` (threshold, e.g. `"100%g"`). Applied in order add → update → remove; it stops at the first failure and reports what was applied.

## The `pantry.conf` format

TOML, organised by storage location. Each item is either a simple quantity string or an object:

```
[freezer]
"frozen peas" = { bought = "2024-11-05", quantity = "500%g", low = "200%g" }

[fridge]
milk = { expire = "2024-11-15", quantity = "2%L" }
eggs = "12"

[pantry]
rice = "5%kg"
pasta = { quantity = "1%kg", low = "200%g" }

[spices]
cumin = { bought = "2024-06-01" }
```

## Workflow

1. To answer "what do I have / do I have X", call `pantry_list` (or `pantry_recipes` for "what can I make") — do not guess.
2. To change stock, call `pantry_list` first to see the existing section and item names, then `pantry_update` using those names — reason: `milk` in `[fridge]` and `Milk` in `[dairy]` would become two items.
3. After "I used / bought / finished X", update quantities or remove the item; after a shop, add the new items with `bought` (and `expire` for perishables).
4. Tell the user what changed in the pantry.
5. Before a shop, `pantry_depleted` (restock) and `pantry_expiring` (use first) are the two useful checks; offer them.

Name items the way the recipes name the ingredient (`olive oil`, not `olive_oil` or `EVOO`); matching ignores case but nothing else, so a differently spelled item is never subtracted from a shopping list or counted by `pantry_recipes`. Names with spaces are quoted TOML keys (`"olive oil" = "500%ml"`); `pantry_update` writes them that way.

## Boundaries

- Subtracting pantry stock from a shopping list is `shopping_list`'s job — never hand-edit totals.
- `pantry_update` writes only the collection's own `config/pantry.conf` and refuses when that file doesn't exist (a global pantry is never modified). To start a pantry, create it with `write_config` (`path: "config/pantry.conf"`, sections and items in the format above), then use `pantry_update` for changes.
- Prefer `pantry_update` for changes to an existing pantry: it edits one item without rewriting the file. Use `write_config` on `config/pantry.conf` only to create it or to reorganise it wholesale (read it with `pantry_list` first; `write_config` replaces the whole file).

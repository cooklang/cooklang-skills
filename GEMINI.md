# Cooklang

This folder may hold recipes written in [Cooklang](https://cooklang.org), a plain-text recipe format.

- `.cook` files are recipes. Ingredients are `@name{qty%unit}`, cookware `#name{}`, timers `~{qty%unit}`, sections `= Name`, notes `> text`.
- `.menu` files are meal plans that reference recipes.
- `config/aisle.conf` groups shopping-list items by store aisle; `config/pantry.conf` is the pantry inventory.
- Metadata (title, servings, tags, times, source) is YAML frontmatter between `---` lines at the top of the file. Never write the deprecated `>>` metadata lines; convert any you find to frontmatter.

## Use the Cook MCP server

The `cook` MCP server (`npx -y @cookmd/mcp`) reads, searches, validates and writes these files. Prefer its tools over editing by hand or doing arithmetic yourself:

- read and find: `list_recipes`, `read_recipe` (with scaling), `search_recipes`
- check and save: `validate`, then `write_recipe` / `write_menu` / `write_config` (writes are validated and stay inside the recipe folder)
- plan and shop: `shopping_list` (merges, groups by aisle, subtracts the pantry), `pantry_*`
- import and report: `import_recipe`, `render_report`
- nutrition (`get_nutrition`, `aggregate_nutrition`, ...) and photo or social-link import need a cook.md login on Cook Basic or Pro; `login` and `auth_status` handle that. Never estimate nutrition from memory.

The recipe folder is `COOK_RECIPES_DIR`, else the workspace folder the client reports, else the folder the server was started in (never `/`, the home folder or a plugin install folder). If the tools say no recipe folder is set, ask the user for the path and have them set `COOK_RECIPES_DIR` in the server config. If the `cook` tools are missing, tell the user to add the server (see https://github.com/cooklang/cooklang-skills).

## Skills

Each task below has a skill with a step-by-step guide (installed with the plugin or extension; the source is `skills/<name>/SKILL.md` in this repo). Use the matching skill before starting:

| Skill | Use it for |
|-------|------------|
| `cooklang-editing` | Write a new recipe or edit and fix a `.cook` file |
| `cooklang-validation` | Check recipes, a folder or the whole collection for errors |
| `metadata` | Add or fix YAML frontmatter, including bulk changes |
| `recipe-import` | Import a recipe from a URL, photos or pasted text |
| `recipe-search` | Find recipes by ingredient, tag, cuisine or a remembered phrase |
| `scale-recipe` | Show a recipe for more or fewer servings |
| `export-recipe` | Turn a recipe into Markdown, JSON, plain text or HTML |
| `organize-collection` | Folder layout, metadata audit, aisle and pantry config |
| `meal-planning` | Build or edit a `.menu` meal plan |
| `shopping-list` | Shopping lists from recipes or plans |
| `pantry` | Stock, expiry, low items; what can I cook now |
| `report-authoring` | Custom Jinja reports with `render_report` |
| `nutrition-reports` | Nutrition evaluation and screening (Cook Basic or Pro) |
| `nutrition-goals` | Change a recipe or plan to hit nutrition targets (Cook Basic or Pro) |

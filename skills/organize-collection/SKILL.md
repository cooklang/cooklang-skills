---
name: organize-collection
description: Use when the user wants to organize or tidy a Cooklang recipe collection - folder structure, a metadata consistency audit across .cook files (missing servings, inconsistent tags), setting up config/aisle.conf or config/pantry.conf, or a health check of the whole library.
---

# Skill: organize-collection

Use when the user wants their recipe collection structured, audited or set up: folders, consistent metadata, shopping-list and pantry config, or a whole-library check.

**Needs the Cook MCP server.** If tools like `list_recipes` and `validate` are not available in this session, stop and tell the user to add the server: `claude mcp add cook -- npx -y @cookmd/mcp`, or the JSON config at https://github.com/cook-md/cook-mcp. Do not audit from guesses about the files.

## 1. Survey

- `list_recipes` (`kind: "all"`): how many recipes and plans, which folders, loose files at the root, where plans live. `list_recipes` with `kind: "template"` shows report templates.
- `validate` with no arguments: parse errors and warnings per file, recipe references that don't resolve, and ingredients that have no aisle in `config/aisle.conf`.

Summarise in a few lines: counts per folder, files with errors, broken references, whether `config/aisle.conf` and `config/pantry.conf` exist.

## 2. Folder structure

Suggest a layout only if the current one isn't working; match what the user already does. Common shapes:

```
Breakfast/  Mains/  Sides/  Desserts/  Baking/  Drinks/
Sauces/          (sub-recipes other recipes reference with @./Sauces/...)
plans/           (.menu meal plans)
config/          (aisle.conf, pantry.conf)
reports/         (.jinja report templates)
```

By course is the most common; by cuisine or by diet also work. Folder names double as a course signal for search and meal planning. Recipe images sit beside the recipe with the same name (`Pancakes.jpg`).

cook-mcp has **no move, rename or delete tool**. To reorganise:

1. Agree the new layout and list every move.
2. The user moves the files (or you do, with your client's file tools if it has them).
3. Moved sub-recipes break `@./` references in other files: run `validate` with no arguments, then fix each referencing file with `read_recipe` → corrected full content → `write_recipe`.
4. Run `validate` with no arguments again until no reference is broken.

Never "move" by writing a copy with `write_recipe` and leaving the user with duplicates without saying so.

## 3. Metadata audit

Read the recipes in batches with `read_recipe` (for a large library, audit one folder at a time, or ask which part matters). Report a short table of:

- missing `title` or `servings` (servings drive scaling, plans and nutrition per serving);
- missing or inconsistent `tags` (`Italian` / `italian` / `italian-food`; `search_recipes` with `tag` matches whole tags, so drift hides recipes);
- mixed key spellings (`serves` vs `servings`, `time` vs `duration`);
- any remaining `>>` metadata lines (deprecated; convert to YAML frontmatter).

Propose one convention (e.g. lowercase, hyphenated tags: `gluten-free`, `one-pot`) and let the user pick. Apply fixes by following the metadata skill: it owns the field list and the bulk-edit workflow (body unchanged, full-file `write_recipe`, confirm first when touching more than about 10 files).

## 4. Config

- **`config/aisle.conf`** groups shopping lists by store aisle. Start from the ingredients `validate` (no arguments) reports as having no aisle, group them into `[section]` blocks in store order, and save the full file with `write_config` (`path: "config/aisle.conf"`). Format and synonyms: shopping-list skill.
- **`config/pantry.conf`** lets shopping lists subtract what's in stock and powers `pantry_recipes`. Create it with `write_config` (`path: "config/pantry.conf"`) from the user's staples, then use `pantry_update` for changes. Format: pantry skill.
- Re-run `validate` with no arguments afterwards to confirm the aisle coverage.

## Rules

- Survey and report before changing anything; let the user choose what to fix.
- Every `write_recipe` replaces a real file: send full content and keep recipe bodies unchanged when only metadata changes.
- Finish with `validate` (no arguments) and tell the user what changed and what is still open.

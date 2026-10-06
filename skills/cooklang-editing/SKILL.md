---
name: cooklang-editing
description: Use when writing a new Cooklang recipe or editing or fixing a .cook file - ingredients, cookware, timers, steps, sections, or resizing a recipe for good. For metadata/frontmatter changes use the metadata skill; to just show scaled amounts use scale-recipe. Not for meal plans (.menu) or importing from a URL/text.
---

# Skill: cooklang-editing

**Needs the Cook MCP server** (tools like `read_recipe` and `validate`). If these tools are missing, the Cook MCP server isn't connected: if you installed the cooklang plugin or extension, check that its `cook` server is running (e.g. `/mcp`) or reinstall it; otherwise add it from https://github.com/cook-md/cook-mcp. Do not write or save Cooklang without them.

Use when creating, editing, scaling, or fixing .cook recipe files.

This skill is for .cook recipes only. If the task is actually about a .menu meal plan, follow the meal-planning skill (`cooklang://skills/meal-planning`) instead. For metadata/frontmatter changes (title, tags, source, servings, etc.), follow the metadata skill (`cooklang://skills/metadata`).

## Workflow

1. If editing an existing file, read it with `read_recipe` first (use the path exactly as `list_recipes` / `search_recipes` returned it); understand its style and structure.
2. If creating a file, look at the collection layout with `list_recipes` and pick an idiomatic folder and name that match the existing ones.
3. Make the change using Cooklang syntax. For scaling, fixed quantities (`@salt{=1%tsp}`), or recipe references (`@./path`), consult the `cooklang://syntax` resource. `validate` warns "Unnecessary scaling lock modifier" on fixed quantities (`{=…}`): a known parser quirk; keep the `=` and ignore that warning.
4. Self-check the content against the cooklang-validation rules — no separate ingredient section, each quantity declared once inline, multi-word names braced — then run `validate` with the new text as `content` (and `as_path` set to where it will be saved). Fix every error before saving.
5. Save with `write_recipe`, always sending the full file content (there is no partial edit). It validates again and refuses to save content with errors.
6. Tell the user what you saved and where.

## Writing a new recipe

From a description, a family recipe from memory, or a dish the user names:

- Ask for what you can't know (how many it serves, the user's quantities) instead of inventing it; a sensible default is fine for things like oven temperature if you say so.
- Frontmatter with at least `title` and `servings`; add `time` (or `prep time` / `cook time`) and `tags` when known. Leave `source` out unless there is one.
- One paragraph per step, separated by a blank line: lines with no blank line between them join into one step.
- Mark everything inline where the step uses it: `@onion{1}(finely diced)` (preparation in parentheses), `#large pot{}`, `~{15%minutes}`. `= Sauce` starts a section in a multi-part recipe; a line starting with `>` is a note; `--` starts a comment.
- Show the draft, adjust, then validate and save as in the workflow above.

## Rules

- Metadata is YAML frontmatter, never the deprecated `>>` lines — for metadata-focused work, follow the metadata skill.
- Recipe images live beside the file with a matching name (`Baked Potato.jpg`), or as step images (`Baked Potato.3.jpg`); see the syntax reference under Images.
- Match the surrounding file's conventions (units, casing, section style) — reason: a recipe that mixes styles is harder for the user to maintain.
- Touch only the file the task names. If a change demonstrably needs another file (e.g. a referenced sub-recipe), name that file and explain why before editing it.
- Do not pass `force: true` to `write_recipe` to get past validation errors; fix them. Use it only when the user explicitly wants a file saved as-is.

## Do not skip the checks

| Excuse | Rebuttal |
|--------|----------|
| "The edit is tiny, I'll skip validation." | `write_recipe` overwrites the user's file for real. Run `validate` on the new content first; a broken recipe breaks every app that reads it. |
| "I'll send just the changed lines." | `write_recipe` replaces the whole file. Send the complete recipe, or you delete the rest of it. |
| "I described the change, that's enough." | If the user asked for the change, save it with `write_recipe` and say what you saved. |

---
name: cooklang-validation
description: Use when checking or validating Cooklang - one .cook recipe, a folder, or the whole collection - for syntax errors and broken references, or when asked to fix or clean up Cooklang (e.g. a stray ingredient list or unbraced multi-word names).
---

# Skill: cooklang-validation

**Needs the Cook MCP server.** If tools like `validate` and `read_recipe` are not available in this session, stop and tell the user to add the server: `claude mcp add cook -- npx -y @cookmd/mcp`, or the JSON config at https://github.com/cook-md/cook-mcp. Do not judge validity by eye alone instead.

Use when checking or validating a .cook recipe for syntax errors, or when asked to fix or clean up Cooklang. The cooklang-editing and recipe-import skills also self-check against these rules before they save a file.

These rules are for .cook recipes. Menu files (.menu) share most syntax but are not the focus here — if the task is about a meal plan, follow the meal-planning skill (`cooklang://skills/meal-planning`).

## Workflow

1. Run `validate`: with `path` for one file or folder, with no arguments for the whole collection, or with `content` (plus `as_path`) for text that is not saved yet. It reports parse errors and warnings and recipe references that don't resolve; for a folder or the whole collection it also lists ingredients missing from `config/aisle.conf` — run `validate` with no arguments to see ingredients with no aisle. (It warns "Unnecessary scaling lock modifier" on fixed quantities `{=…}`: a known parser quirk; keep the `=` and ignore that warning.)
2. Read the file with `read_recipe` (skip if the content is already in hand) and check it against every rule below too — some of them (a separate ingredient list, repeated quantities) parse fine and only show up as wrong data.
3. For each violation, name the rule, quote the offending line, and give the corrected line. Order the report by severity: errors (the file doesn't parse, a reference doesn't resolve), then rule violations below, then suggestions (missing `servings`, which scaling, plans and nutrition need).
4. If the user wants it fixed, run `validate` on the corrected text (`content`), then save it with `write_recipe` (full file content).
5. Tell the user what you fixed and saved.

## Rules

1. **No separate ingredient or shopping-list section.** A section such as `= Ingredients` or `= Shopping List` that lists `@ingredient{qty}` declarations is invalid — reason: Cooklang derives the ingredient list from inline tags, so a manual list plus inline references double-counts every ingredient. Move each quantity into the step that uses it and delete the section.
   - BAD: `= Ingredients` / `@bacon{6%slices}` … then `= Instructions` / `Cook the @bacon...`
   - GOOD: `Cook the @bacon{6%slices} in a #skillet over medium heat.`
2. **Declare each quantity once.** The first mention of an ingredient carries the quantity; every later mention is bare — reason: each `@name{qty}` becomes its own entry in the derived ingredient list, so repeating the quantity duplicates it there.
   - BAD: `@bacon{6%slices}` in one step and `@bacon{6%slices}` in another.
   - GOOD: `@bacon{6%slices}` the first time, then `@bacon` after.
3. **Multi-word names need `{}`.** An inline `@` or `#` name without braces captures only the first word — reason: the parser stops at the first space.
   - BAD: `Toast all the @white sandwich bread slices` (captures only "white").
   - GOOD: `Toast all the @white sandwich bread{}` and `#baking sheet{}`.
4. **YAML frontmatter only.** Metadata goes between `---` markers at the file start — reason: the old `>>` metadata lines are deprecated and must not be used; `write_recipe` refuses them. Convert any you find into frontmatter keys.
   - GOOD: `---` / `servings: 2` / `---`
5. **Quantity form is `{n%unit}`.** The `%` separates amount from unit — reason: `{n unit}` treats the whole thing as one amount and `{n/unit}` is a fraction.
   - BAD: `@milk{1 cup}`, `@milk{1/cup}`
   - GOOD: `@milk{1%cup}`, `@milk{1/2%cup}`
6. **Recipe references use `@./path` with no `.cook` extension.** Reason: the spec's reference form has no extension.
   - BAD: `@./sauces/pesto.cook{150%g}`
   - GOOD: `@./sauces/pesto{150%g}`
7. **Steps are paragraphs.** A blank line ends a step — reason: consecutive lines with no blank line between them parse as one step, so a recipe written one sentence per line collapses into a single step.

## Do not skip the fix

| Excuse | Rebuttal |
|--------|----------|
| "I only pointed out the errors, that's enough." | If the user wanted a fix, validate the corrected content and save it with `write_recipe`. Listing errors does not change the file. |
| "`validate` passed, so the recipe is fine." | Rules 1, 2, 3, 5, 6 and 7 pass `validate`; check them by eye. |
| "The recipe already has an ingredients list, keep it." | A separate ingredient list is the violation (rule 1). Remove it and put the quantities inline; do not preserve it. |

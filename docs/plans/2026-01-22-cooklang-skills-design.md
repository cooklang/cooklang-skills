# Cooklang Skills Design

## Overview

Claude skills for writing and managing recipes with Cooklang. Target audience: recipe authors at all skill levels.

## Project Structure

```
cooklang-skills/
├── README.md                 # Project overview, installation, skill list
├── LICENSE                   # MIT license
├── skills/
│   ├── create-recipe.md
│   ├── convert-recipe.md
│   ├── validate-recipes.md
│   ├── shopping-list.md
│   ├── search-recipes.md
│   ├── scale-recipe.md
│   ├── organize-collection.md
│   ├── meal-plan.md
│   ├── manage-pantry.md
│   └── export-recipe.md
└── examples/
    └── sample-recipes/       # Example .cook files for testing/demos
```

**Conventions:**
- Flat skills directory (no subcategories)
- Markdown format following Agent Skills specification
- Lowercase with hyphens: `create-recipe.md`
- Verb-noun pattern, plural when operating on multiple items

## Skill File Format

```markdown
---
name: skill-name
description: One-line description for skill discovery
---

# Skill Title

## Overview
Brief description of what the skill does and when to use it.

## Process
Step-by-step instructions for the agent to follow.

## Examples
Sample inputs and expected outputs.

## Reference
Quick syntax reminders (Cooklang syntax as needed).
```

Each skill is self-contained with enough Cooklang reference included.

## Skills

### 1. create-recipe (Flagship)

**Trigger scenarios:**
- "Create a recipe for spaghetti carbonara"
- "Help me write a new .cook file"
- "I have this recipe, convert it to Cooklang" (plain text pasted)

**Hybrid approach:**
1. Gather input - Ask what they're making, or accept pasted recipe/description
2. Extract structure - Identify title, servings, ingredients, steps, timing
3. Generate draft - Create properly formatted `.cook` file
4. Refine interactively - Ask if anything needs adjustment
5. Save file - Write to specified location

**Key behaviors:**
- Always use YAML frontmatter (never deprecated `>>` syntax)
- Multi-word ingredients get `{}`: `@ground black pepper{}`
- Include sensible defaults for metadata
- Suggest section headers for complex recipes

### 2. convert-recipe

- Import from URL using `cook import <url>` when possible
- Fall back to manual conversion for unsupported sites
- Accept plain text paste and convert to Cooklang syntax
- Preserve source URL in metadata
- Prompt for missing info (servings, times)

### 3. validate-recipes

- Run `cook doctor` on specified files or entire collection
- Report syntax errors, warnings, missing metadata
- Offer to fix common issues
- Strict mode for CI/CD: `cook doctor validate --strict`

### 4. shopping-list

- Run `cook shopping-list` with one or more recipes
- Support scaling: `cook shopping-list "Pizza.cook:2" "Salad.cook"`
- Group by aisle if `aisle.conf` exists
- Exclude pantry items if `pantry.conf` exists
- Output formats: human-readable, JSON, markdown

### 5. search-recipes

- Run `cook search` with user's query
- Search titles, ingredients, instructions, metadata
- Multiple terms use AND logic
- Show matching recipes with relevant context

### 6. scale-recipe

- Display recipe at different serving sizes
- Use `cook recipe "file.cook" --scale 2`
- Show original vs scaled quantities side-by-side
- Warn about fixed quantities (marked with `=`)

### 7. organize-collection

- Analyze folder structure and suggest improvements
- Recommend consistent category folders
- Audit metadata consistency across recipes
- Help bulk-add missing metadata
- Set up config files: `aisle.conf`, `pantry.conf`

### 8. meal-plan

- Create weekly meal plans interactively
- Ask: how many people, dietary restrictions, variety preferences
- Suggest recipes from collection
- Generate combined shopping list for the week
- Output as markdown table or `.menu` file

### 9. manage-pantry

- Set up and maintain `pantry.conf`
- Track stock with quantities and expiration dates
- Commands: `cook pantry depleted`, `cook pantry expiring --days 7`
- Show recipes you can make: `cook pantry recipes`
- Update quantities after cooking

### 10. export-recipe

- Convert `.cook` files to other formats
- Formats: Markdown, JSON, YAML, LaTeX
- Use `cook recipe "file.cook" -f <format>`
- Batch export for sharing collections

## Cooklang Quick Reference

Include relevant portions in each skill:

```markdown
**Metadata** (YAML frontmatter):
---
title: Recipe Name
servings: 4
time: 30 minutes
tags: [dinner, quick]
source: https://...
---

**Ingredients**: `@salt` or `@ground black pepper{}` or `@flour{500%g}`
**Cookware**: `#pot` or `#large mixing bowl{}`
**Timers**: `~{15%minutes}` or `~oven{25%minutes}`
**Fixed qty** (won't scale): `@salt{=1%tsp}`
**Sections**: `= Section Name` or `== Subsection ==`
**Comments**: `-- line comment` or `[- block comment -]`
**Notes**: `> This is a tip or background info`

Steps are paragraphs separated by blank lines.
```

## README Structure

- Installation instructions (Claude Code, Codex CLI)
- Skills table with descriptions
- Requirements (CookCLI installation)
- Quick start examples
- Links to Cooklang resources
- MIT license

## Implementation Order

1. Project scaffolding (README, LICENSE, directories)
2. create-recipe (flagship skill)
3. validate-recipes (CLI wrapper, immediately useful)
4. shopping-list (CLI wrapper, common use case)
5. convert-recipe (complements create-recipe)
6. search-recipes, scale-recipe (simple CLI wrappers)
7. organize-collection (collection management)
8. meal-plan, manage-pantry (advanced workflows)
9. export-recipe (utility)
10. Example recipes

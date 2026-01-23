# Cooklang Skills

Claude skills for writing and managing recipes with [Cooklang](https://cooklang.org).

## Installation

### Marketplace (Recommended)

```
/plugin marketplace add cooklang/cooklang-skills
/plugin install cooklang@cooklang-skills
```

### Manual Installation

**Claude Code:**
Add the `skills/` directory contents to your project's `/.claude/skills/` folder.

**Codex CLI:**
Add the `skills/` directory contents to `~/.codex/skills/`.

## Skills

Each skill lives in its own subdirectory under `skills/` with a `SKILL.md` file:

```
skills/
├── create-recipe/SKILL.md
├── convert-recipe/SKILL.md
├── validate-recipes/SKILL.md
├── shopping-list/SKILL.md
├── search-recipes/SKILL.md
├── scale-recipe/SKILL.md
├── organize-collection/SKILL.md
├── meal-plan/SKILL.md
├── manage-pantry/SKILL.md
└── export-recipe/SKILL.md
```

| Skill | Description |
|-------|-------------|
| `create-recipe` | Create new Cooklang recipes interactively from description or template |
| `convert-recipe` | Import recipes from URLs or plain text into Cooklang format |
| `validate-recipes` | Check recipes for syntax errors and best practice issues |
| `shopping-list` | Generate shopping lists from one or more recipes |
| `search-recipes` | Find recipes by ingredient, tag, or text |
| `scale-recipe` | Adjust recipe servings and display scaled ingredients |
| `organize-collection` | Structure folders, audit metadata, set up config files |
| `meal-plan` | Plan weekly meals and generate combined shopping lists |
| `manage-pantry` | Track inventory and find recipes you can make now |
| `export-recipe` | Convert recipes to Markdown, JSON, or other formats |

## Requirements

Some skills require [CookCLI](https://cooklang.org/cli/) for full functionality:

```bash
# macOS
brew install cookcli

# From source
cargo install cookcli
```

Skills that work without CookCLI: `create-recipe`, `convert-recipe`, `organize-collection`

## Quick Start

Try these prompts:

- "Create a recipe for banana bread"
- "Generate a shopping list for all recipes in dinner/"
- "Validate my recipes and fix any issues"
- "Plan meals for the week"

## Cooklang Resources

- [Cooklang Specification](https://cooklang.org/docs/spec/)
- [CookCLI Documentation](https://cooklang.org/cli/)
- [Cooklang GitHub](https://github.com/cooklang)

## License

MIT

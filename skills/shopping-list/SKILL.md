---
name: shopping-list
description: Generate shopping lists from one or more Cooklang recipes with scaling support
---

# Shopping List

## Overview

Generate consolidated shopping lists from recipes using CookCLI. Features:
- Combine multiple recipes into one list
- Scale individual recipes up or down
- Group items by store aisle (if configured)
- Exclude pantry items you already have

Use this skill when:
- Planning a shopping trip
- Preparing for a dinner party
- Meal prepping for the week

## Process

### Step 1: Identify Recipes

Ask: "Which recipes should I include?"
- Single recipe: `"Pasta.cook"`
- Multiple recipes: `"Pasta.cook" "Salad.cook"`
- Pattern: `dinner/*.cook`
- All recipes: `*.cook` or `**/*.cook`

### Step 2: Determine Scaling

Ask: "Any recipes need scaling?"
- Default servings: Use as-is
- Scale up: `"Pasta.cook:2"` (double)
- Scale down: `"Pasta.cook:0.5"` (half)

### Step 3: Generate List

**Basic command:**
```bash
cook shopping-list "Recipe1.cook" "Recipe2.cook"
```

**With scaling:**
```bash
cook shopping-list "Pizza.cook:2" "Salad.cook"
```

**All recipes in folder:**
```bash
cook shopping-list dinner/*.cook
```

**Output formats:**
```bash
cook shopping-list recipes.cook -f json
cook shopping-list recipes.cook -f yaml
```

### Step 4: Present Results

Show the list organized by:
1. **Aisle/category** (if `aisle.conf` exists)
2. **Alphabetically** (if no aisle config)

Indicate excluded pantry items if `pantry.conf` is configured.

### Step 5: Export Options

Offer export formats:
- **Terminal** - Display in console (default)
- **Markdown** - Copy-friendly checklist format
- **JSON** - For apps or further processing

## Examples

**User:** "Make a shopping list for this week's dinners"

**Run:**
```bash
cook shopping-list dinner/*.cook
```

**Output:**
```
Shopping List
=============

Produce
-------
- tomatoes: 800g
- onion: 3
- garlic: 8 cloves
- basil: 1 bunch

Dairy
-----
- parmesan: 150g
- mozzarella: 200g
- eggs: 6

Meat
----
- chicken breast: 600g
- pancetta: 100g

Pantry
------
- olive oil: 4 tbsp
- spaghetti: 400g
```

**User:** "Shopping list for pizza night, doubled"

**Run:**
```bash
cook shopping-list "Pizza.cook:2"
```

**Markdown export:**
```markdown
## Shopping List

### Produce
- [ ] tomatoes: 400g
- [ ] basil: 16 leaves

### Dairy
- [ ] mozzarella: 400g

### Pantry
- [ ] tipo zero flour: 1kg
- [ ] yeast: 2g
```

## Reference

### Command Syntax

```bash
# Basic
cook shopping-list "Recipe.cook"

# Multiple recipes
cook shopping-list "Recipe1.cook" "Recipe2.cook"

# With scaling (2x, 0.5x)
cook shopping-list "Recipe.cook:2"
cook shopping-list "Recipe.cook:0.5"

# Glob patterns
cook shopping-list *.cook
cook shopping-list dinner/*.cook

# Output format
cook shopping-list recipes.cook -f json
cook shopping-list recipes.cook -f yaml

# Ingredients only (no quantities)
cook shopping-list recipes.cook --ingredients-only

# Specify recipe directory
cook shopping-list -b ~/recipes "Dinner.cook"
```

### Configuration Files

**aisle.conf** - Groups ingredients by store section:
```toml
[produce]
tomatoes
onion
garlic

[dairy]
milk
cheese
butter

[meat]
chicken
beef
```

**pantry.conf** - Items you have (excluded from list):
```toml
[pantry]
salt
pepper
olive oil
flour
```

### Tips

- Use `:2` suffix to double, `:0.5` to halve
- Glob patterns work: `dinner/*.cook` for all dinner recipes
- Configure `aisle.conf` to match your grocery store layout
- Keep `pantry.conf` updated to avoid buying duplicates

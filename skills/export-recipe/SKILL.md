---
name: export-recipe
description: Convert Cooklang recipes to Markdown, JSON, YAML, or other formats
---

# Export Recipe

## Overview

Convert `.cook` recipes to other formats for sharing or integration:
- **Markdown** - For blogs, notes, sharing
- **JSON** - For apps and APIs
- **YAML** - For configuration/data pipelines
- **LaTeX** - For printed cookbooks

Use this skill when:
- Sharing a recipe on a blog or social media
- Integrating with other apps
- Creating a printable cookbook
- Backing up in portable format

## Process

### Step 1: Identify Recipe(s)

Ask: "Which recipe(s) do you want to export?"
- Single: `Recipe.cook`
- Multiple: `Recipe1.cook Recipe2.cook`
- Pattern: `dinner/*.cook`

### Step 2: Choose Format

Options:
- **Markdown** - Human-readable, good for sharing
- **JSON** - Structured data for apps
- **YAML** - Structured, more readable than JSON
- **LaTeX** - For PDF/print generation

### Step 3: Export

**Single recipe:**
```bash
cook recipe "Recipe.cook" -f markdown
cook recipe "Recipe.cook" -f json
cook recipe "Recipe.cook" -f yaml
```

**Save to file:**
```bash
cook recipe "Recipe.cook" -f markdown -o recipe.md
cook recipe "Recipe.cook" -f json -o recipe.json
```

**Batch export:**
```bash
for f in *.cook; do
  cook recipe "$f" -f markdown -o "${f%.cook}.md"
done
```

### Step 4: Post-Processing (Optional)

For markdown:
- Add header image reference
- Adjust formatting for target platform

For JSON:
- Pretty print if needed
- Validate structure

## Examples

**User:** "Export pasta recipe as markdown for my blog"

**Run:**
```bash
cook recipe "Pasta Carbonara.cook" -f markdown
```

**Output:**
```markdown
# Pasta Carbonara

**Servings:** 4
**Time:** 25 minutes
**Tags:** italian, pasta, dinner

## Ingredients

- 400g spaghetti
- 150g pancetta
- 4 eggs
- 100g parmesan (finely grated)
- Black pepper (freshly ground)
- Salt (1 pinch)

## Equipment

- Large pot
- Pan
- Bowl

## Instructions

1. Cook **400g spaghetti** in a **large pot** of salted boiling water until al dente.

2. While pasta cooks, cut **150g pancetta** into small cubes and fry in a **pan** until crispy.

3. In a **bowl**, whisk **4 eggs** with **100g parmesan** (finely grated) and **black pepper** (freshly ground).

4. Reserve ~1/2 cup pasta water, then drain the spaghetti.

5. Remove pan from heat. Add hot pasta to pancetta, then quickly pour in egg mixture, tossing constantly.

6. Add pasta water a splash at a time if needed to loosen the sauce.

7. Serve immediately with extra parmesan and black pepper.
```

**User:** "Export all dinner recipes as JSON"

**Run:**
```bash
for f in dinner/*.cook; do
  cook recipe "$f" -f json -o "export/$(basename ${f%.cook}).json"
done
```

## Reference

### Export Commands

```bash
# Format options
cook recipe "Recipe.cook" -f markdown
cook recipe "Recipe.cook" -f json
cook recipe "Recipe.cook" -f yaml
cook recipe "Recipe.cook" -f latex

# Save to file
cook recipe "Recipe.cook" -f markdown -o output.md

# With scaling
cook recipe "Recipe.cook:2" -f markdown
```

### Format Comparison

| Format | Best For | Pros | Cons |
|--------|----------|------|------|
| Markdown | Sharing, blogs | Readable, universal | No structure |
| JSON | Apps, APIs | Structured, parseable | Not human-friendly |
| YAML | Config, readable data | Structured + readable | Whitespace sensitive |
| LaTeX | Print, PDF | Beautiful output | Complex setup |

### JSON Structure

```json
{
  "title": "Recipe Name",
  "metadata": {
    "servings": 4,
    "time": "30 minutes",
    "tags": ["dinner", "quick"]
  },
  "ingredients": [
    {"name": "flour", "quantity": 500, "unit": "g"},
    {"name": "eggs", "quantity": 2, "unit": null}
  ],
  "cookware": ["bowl", "pan"],
  "timers": [
    {"name": null, "duration": 15, "unit": "minutes"}
  ],
  "steps": [
    "Step 1 text...",
    "Step 2 text..."
  ]
}
```

### Batch Export Script

```bash
#!/bin/bash
# Export all recipes to markdown

mkdir -p export

for recipe in **/*.cook; do
  name=$(basename "${recipe%.cook}")
  cook recipe "$recipe" -f markdown -o "export/$name.md"
  echo "Exported: $name"
done
```

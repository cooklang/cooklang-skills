---
name: search-recipes
description: Find recipes by ingredient, tag, metadata, or text search
---

# Search Recipes

## Overview

Search your recipe collection using CookCLI. Searches across:
- Recipe titles
- Ingredients
- Instructions
- Metadata (tags, cuisine, author)
- Notes

Use this skill when:
- Looking for recipes with specific ingredients
- Finding recipes by cuisine or tag
- Searching for a recipe you remember partially

## Process

### Step 1: Understand Query

Ask: "What are you looking for?"
- **Ingredient:** "recipes with chicken"
- **Multiple ingredients:** "recipes with chicken and rice"
- **Tag/cuisine:** "Italian recipes"
- **Text:** "something quick for dinner"

### Step 2: Run Search

**Single term:**
```bash
cook search chicken
```

**Multiple terms (AND logic):**
```bash
cook search chicken rice
```

**Phrase search:**
```bash
cook search "olive oil"
```

**In specific directory:**
```bash
cook search -b ~/recipes pasta
```

### Step 3: Present Results

Show matching recipes with:
- Recipe name (linked to file)
- Matching context (where the term was found)
- Key metadata (servings, time, tags)

### Step 4: Offer Actions

For selected recipe:
- "Open this recipe"
- "Scale to different servings"
- "Add to shopping list"

## Examples

**User:** "Find recipes with chicken"

**Run:**
```bash
cook search chicken
```

**Output:**
```
Found 5 recipes matching "chicken":

1. dinner/Chicken Stir Fry.cook
   Ingredients: @chicken breast{500%g}
   Tags: asian, quick, dinner
   Time: 25 minutes

2. dinner/Chicken Parmesan.cook
   Ingredients: @chicken breast{4}
   Tags: italian, dinner
   Time: 45 minutes

3. lunch/Chicken Salad.cook
   Ingredients: @cooked chicken{300%g}
   Tags: lunch, healthy
   Time: 15 minutes
```

**User:** "Something with tomatoes and basil"

**Run:**
```bash
cook search tomatoes basil
```

**Output:**
```
Found 3 recipes matching "tomatoes" AND "basil":

1. dinner/Caprese Salad.cook
2. dinner/Margherita Pizza.cook
3. dinner/Pasta Pomodoro.cook
```

## Reference

### Search Command Syntax

```bash
# Single term
cook search chicken

# Multiple terms (AND - both must match)
cook search chicken rice

# Phrase (exact match)
cook search "olive oil"

# Specify directory
cook search -b ~/recipes pasta
cook search -b ./dinner quick
```

### Search Scope

CookCLI searches these fields:
- **Title** - Recipe name
- **Ingredients** - All `@ingredient` entries
- **Instructions** - Full recipe text
- **Metadata** - Tags, cuisine, author, etc.
- **Notes** - Content in `>` blocks

### Tips

- Use specific ingredient names: "chicken breast" vs "chicken"
- Search by tag: `cook search vegetarian`
- Search by cuisine: `cook search italian`
- Combine for precision: `cook search quick vegetarian dinner`

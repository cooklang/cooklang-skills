---
name: organize-collection
description: Structure recipe folders, audit metadata consistency, and set up configuration files
---

# Organize Collection

## Overview

Help structure and maintain a recipe collection:
- Organize folder structure
- Audit metadata consistency
- Set up aisle.conf for shopping lists
- Configure pantry.conf for inventory

Use this skill when:
- Starting a new recipe collection
- Cleaning up a messy folder structure
- Preparing for better shopping list generation
- Standardizing metadata across recipes

## Process

### Step 1: Analyze Current State

Examine the collection:
```bash
find . -name "*.cook" | head -20
```

Check for:
- Folder structure (or lack thereof)
- Metadata consistency
- Config files present

### Step 2: Suggest Folder Structure

Recommend organization by meal type:
```
recipes/
├── breakfast/
├── lunch/
├── dinner/
├── desserts/
├── snacks/
├── sides/
├── sauces/
├── drinks/
└── config/
    ├── aisle.conf
    └── pantry.conf
```

Or by cuisine:
```
recipes/
├── italian/
├── asian/
├── mexican/
├── american/
└── ...
```

Ask preference and help reorganize if desired.

### Step 3: Audit Metadata

Check all recipes for:
- Missing `title`
- Missing `servings`
- Missing `tags`
- Inconsistent tag naming
- Deprecated `>>` syntax

Report findings and offer to fix.

### Step 4: Set Up Configuration

**Create aisle.conf:**
```toml
[produce]
tomatoes
onions
garlic
lettuce
# ... extract from recipes

[dairy]
milk
butter
cheese
eggs

[meat]
chicken
beef
pork

[pantry]
flour
sugar
rice
pasta
```

**Create pantry.conf:**
```toml
[pantry]
salt
pepper
olive oil
# ... common staples

[fridge]
butter
eggs

[freezer]
# items you keep stocked
```

### Step 5: Bulk Updates

Offer to:
- Add missing servings to all recipes
- Standardize tag format (lowercase, hyphenated)
- Add missing source URLs
- Convert deprecated syntax

## Examples

**User:** "Help me organize my recipes"

**Analysis output:**
```
Recipe Collection Analysis
==========================

Found 47 recipes in 3 directories:
- ./recipes/ (32 files, no subdirectories)
- ./old/ (10 files)
- ./to-try/ (5 files)

Metadata Issues:
- 12 recipes missing 'servings'
- 8 recipes missing 'tags'
- 3 recipes using deprecated >> syntax
- Inconsistent tags: "Italian" vs "italian" vs "ITALIAN"

Configuration:
- No aisle.conf found
- No pantry.conf found

Recommendations:
1. Create meal-type folders (breakfast, lunch, dinner, etc.)
2. Add missing servings to 12 recipes
3. Standardize tags to lowercase
4. Create aisle.conf with 45 unique ingredients
5. Set up pantry.conf with common staples
```

**User:** "Create an aisle.conf for my recipes"

**Generated aisle.conf:**
```toml
# Aisle configuration for shopping lists
# Customize sections to match your grocery store

[produce]
tomatoes
onion
garlic
bell pepper
lettuce
carrots
potatoes
lemon

[dairy]
milk
butter
eggs
parmesan
mozzarella
cream

[meat]
chicken breast
ground beef
bacon
pancetta

[seafood]
salmon
shrimp

[bakery]
bread

[pantry]
olive oil
flour
sugar
pasta
rice
canned tomatoes

[spices]
salt
pepper
oregano
basil
cumin

[frozen]
frozen peas
```

## Reference

### Recommended Folder Structures

**By meal:**
```
breakfast/ lunch/ dinner/ desserts/ snacks/ sides/ sauces/
```

**By cuisine:**
```
italian/ asian/ mexican/ indian/ american/ mediterranean/
```

**By diet:**
```
vegetarian/ vegan/ gluten-free/ keto/ quick-meals/
```

### Metadata Standards

Recommended fields for every recipe:
```yaml
---
title: Recipe Name        # Required
servings: 4               # Required for scaling
time: 30 minutes          # Helpful for planning
tags: [dinner, quick]     # For searching
source: https://...       # Credit and reference
---
```

Tag conventions:
- Lowercase: `italian` not `Italian`
- Hyphenated: `gluten-free` not `gluten free`
- Specific: `chicken` not `meat`

### Configuration File Locations

CookCLI looks for config in:
1. `./config/aisle.conf` (project)
2. `~/.config/cooklang/aisle.conf` (user)
3. `/etc/cooklang/aisle.conf` (system)

### Common Ingredients by Aisle

Use as starting point for aisle.conf:

**Produce:** tomatoes, onions, garlic, potatoes, carrots, celery, lettuce, peppers, lemons, limes, herbs

**Dairy:** milk, butter, eggs, cheese, cream, yogurt, sour cream

**Meat:** chicken, beef, pork, bacon, sausage

**Pantry:** flour, sugar, oil, vinegar, pasta, rice, beans, canned tomatoes, broth

**Spices:** salt, pepper, oregano, basil, cumin, paprika, cinnamon

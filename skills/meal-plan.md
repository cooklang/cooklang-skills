---
name: meal-plan
description: Plan weekly meals interactively and generate combined shopping lists
---

# Meal Plan

## Overview

Create meal plans by selecting recipes for each day/meal. Features:
- Weekly planning grid
- Combined shopping list generation
- Automatic scaling for household size
- Dietary restriction filtering

Use this skill when:
- Planning meals for the week
- Preparing for a dinner party
- Meal prepping in advance
- Reducing food waste with intentional planning

## Process

### Step 1: Gather Requirements

Ask:
- "How many people are you cooking for?"
- "How many days are you planning?"
- "Any dietary restrictions or preferences?"
- "Which meals? (breakfast, lunch, dinner)"

### Step 2: Suggest Recipes

Based on requirements:
1. Search collection for matching recipes
2. Consider variety (don't repeat cuisines)
3. Factor in prep time for busy days
4. Suggest using overlapping ingredients

Present options for each meal slot.

### Step 3: Build Plan

Create a plan grid:

| Day | Breakfast | Lunch | Dinner |
|-----|-----------|-------|--------|
| Mon | Oatmeal | Leftover | Pasta |
| Tue | Eggs | Salad | Stir Fry |
| ... | ... | ... | ... |

### Step 4: Generate Shopping List

Combine all recipes with appropriate scaling:
```bash
cook shopping-list "Oatmeal.cook" "Pasta.cook:4" "Eggs.cook" ...
```

### Step 5: Output Plan

Save as:
- **Markdown table** - For notes/calendar
- **Menu file** - `.menu` format for CookCLI
- **Shopping list** - Ready for the store

## Examples

**User:** "Plan dinners for the week for 4 people"

**Questions:**
1. "Any dietary restrictions?" → "No red meat"
2. "Prefer quick meals on weekdays?" → "Yes, under 30 min"
3. "Any cuisines to focus on?" → "Variety is good"

**Generated plan:**

```markdown
# Week of January 22, 2026

## Meal Plan (4 servings each)

| Day | Dinner | Time | Tags |
|-----|--------|------|------|
| Mon | Chicken Stir Fry | 25 min | asian, quick |
| Tue | Pasta Primavera | 30 min | italian, vegetarian |
| Wed | Fish Tacos | 25 min | mexican, seafood |
| Thu | Sheet Pan Chicken | 35 min | american, easy |
| Fri | Homemade Pizza | 45 min | italian, fun |
| Sat | Thai Curry | 40 min | asian, curry |
| Sun | Roast Chicken | 1.5 hr | classic, sunday |
```

**Shopping list generated:**
```bash
cook shopping-list \
  "Chicken Stir Fry.cook" \
  "Pasta Primavera.cook" \
  "Fish Tacos.cook" \
  "Sheet Pan Chicken.cook" \
  "Pizza.cook" \
  "Thai Curry.cook" \
  "Roast Chicken.cook"
```

## Reference

### Menu File Format

Save plans as `.menu` files:
```
# Weekly Dinner Plan
# January 22-28, 2026

Monday: Chicken Stir Fry.cook
Tuesday: Pasta Primavera.cook
Wednesday: Fish Tacos.cook
Thursday: Sheet Pan Chicken.cook
Friday: Pizza.cook
Saturday: Thai Curry.cook
Sunday: Roast Chicken.cook
```

### Planning Tips

**Weekday strategies:**
- Quick meals (< 30 min)
- One-pot dishes
- Sheet pan dinners
- Planned leftovers

**Weekend strategies:**
- Longer cook times OK
- Batch cooking for week
- Fun/involved recipes
- Family cooking time

**Reduce waste:**
- Use overlapping ingredients
- Plan leftover nights
- Buy proteins in bulk, portion
- Fresh produce early in week

### Combined Shopping List

```bash
# All recipes at once
cook shopping-list "Recipe1.cook" "Recipe2.cook" ...

# With scaling
cook shopping-list "Recipe1.cook:4" "Recipe2.cook:4"

# From menu file (if supported)
cook shopping-list --menu weekly.menu
```

### Scaling for Household

| Household | Typical Scale |
|-----------|---------------|
| 1 person | 0.5x (halve) |
| 2 people | 1x (as written if serves 2) |
| 4 people | 1x (most recipes) |
| 6 people | 1.5x |
| 8+ people | 2x or batch cook |

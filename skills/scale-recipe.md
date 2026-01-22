---
name: scale-recipe
description: Adjust recipe servings and display scaled ingredient quantities
---

# Scale Recipe

## Overview

Display a recipe with adjusted serving sizes. Shows original vs scaled quantities for easy comparison.

Use this skill when:
- Cooking for more or fewer people
- Halving or doubling a recipe
- Converting between serving sizes

## Process

### Step 1: Identify Recipe

Ask: "Which recipe do you want to scale?"

### Step 2: Determine Scale Factor

Ask: "How many servings do you need?"
- Or: "What scale factor?" (2 = double, 0.5 = half)

Calculate factor: `new_servings / original_servings`

### Step 3: Display Scaled Recipe

**Using CookCLI:**
```bash
cook recipe "Recipe.cook" --scale 2
```

**Or with colon notation:**
```bash
cook recipe "Recipe.cook:2"
```

### Step 4: Highlight Important Notes

Warn about:
- **Fixed quantities** (marked with `=`) - These don't scale
- **Timing** - Cooking times may need adjustment for larger batches
- **Equipment** - May need larger pots/pans

## Examples

**User:** "Scale the pasta recipe for 8 people"

**Original recipe (serves 4):**
```cooklang
---
title: Spaghetti Carbonara
servings: 4
---

Cook @spaghetti{400%g} in boiling water.
Fry @pancetta{150%g} until crispy.
Mix @eggs{4} with @parmesan{100%g}.
Season with @black pepper{} and @salt{=1%pinch}.
```

**Run:**
```bash
cook recipe "Spaghetti Carbonara.cook" --scale 2
```

**Scaled output (serves 8):**
```
Spaghetti Carbonara (scaled to 8 servings)

Ingredients:
- spaghetti: 800g (was 400g)
- pancetta: 300g (was 150g)
- eggs: 8 (was 4)
- parmesan: 200g (was 100g)
- black pepper: to taste
- salt: 1 pinch (FIXED - doesn't scale)

Steps:
[Recipe steps with scaled quantities inline]
```

**User:** "Halve the cake recipe"

**Run:**
```bash
cook recipe "Chocolate Cake.cook" --scale 0.5
```

## Reference

### Scaling Commands

```bash
# Double
cook recipe "Recipe.cook" --scale 2
cook recipe "Recipe.cook:2"

# Half
cook recipe "Recipe.cook" --scale 0.5
cook recipe "Recipe.cook:0.5"

# Specific servings (if original is 4, this makes 6)
cook recipe "Recipe.cook" --scale 1.5

# In shopping list
cook shopping-list "Recipe.cook:2"
```

### Fixed Quantities

Some ingredients shouldn't scale. Mark with `=`:

```cooklang
@salt{=1%tsp}        -- stays 1 tsp regardless of scale
@baking soda{=1%tsp} -- leavening is chemistry, be careful
@vanilla{=1%tsp}     -- flavor extracts often don't scale linearly
```

### Scaling Considerations

| Item | Scales? | Notes |
|------|---------|-------|
| Main ingredients | Yes | Meat, vegetables, pasta |
| Liquids | Yes | But may need adjustment |
| Seasonings | Partially | Start with less, adjust to taste |
| Leavening | Carefully | Baking soda/powder - use formulas |
| Cooking time | No | But larger batches may need more |
| Pan size | No | May need multiple batches |

### Tips

- Doubling is usually safe
- Halving works well for most recipes
- Beyond 2x, consider cooking in batches
- Baking is more sensitive to scaling than cooking
- Always taste and adjust seasonings

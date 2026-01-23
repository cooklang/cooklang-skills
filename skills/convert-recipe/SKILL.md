---
name: convert-recipe
description: Import recipes from URLs or plain text and convert to Cooklang format
---

# Convert Recipe

## Overview

Convert existing recipes into Cooklang format from:
- **URLs** - Import from recipe websites using CookCLI
- **Plain text** - Parse pasted recipes manually
- **Other formats** - JSON, YAML, markdown recipes

Use this skill when:
- Saving a recipe from a website
- Digitizing handwritten recipes
- Converting from another recipe format

## Process

### Step 1: Identify Source

Ask: "What would you like to convert?"
- **URL** - Website link to import
- **Pasted text** - Recipe copied from somewhere
- **File** - Existing file in another format

### Step 2: Import or Parse

**For URLs (using CookCLI):**
```bash
cook import "https://example.com/recipe"
```

If CookCLI import fails (unsupported site), fall back to manual conversion.

**For pasted text or unsupported sites:**
1. Extract title
2. Identify servings/yield
3. Parse ingredient list (look for quantities, units)
4. Separate instructions into steps
5. Note any cooking times mentioned
6. Identify required equipment

### Step 3: Generate Cooklang

Create properly formatted `.cook` file:

1. **Metadata** - YAML frontmatter with extracted info
2. **Ingredients** - Mark with `@` and proper quantity format
3. **Cookware** - Mark equipment with `#`
4. **Timers** - Extract times and mark with `~`
5. **Steps** - One paragraph per step

### Step 4: Fill Gaps

Prompt for missing information:
- "The recipe didn't specify servings. How many does it make?"
- "No cooking time mentioned. Approximately how long does it take?"

### Step 5: Review and Save

Show the converted recipe and ask:
- "Does this conversion look accurate?"
- "Where should I save it?"

## Examples

**User:** "Convert https://example.com/banana-bread"

**Run:**
```bash
cook import "https://example.com/banana-bread"
```

**If successful, output saved. If not, manual conversion:**

**User:** "Convert this recipe:
BANANA BREAD
Makes 1 loaf
3 ripe bananas, 1/3 cup melted butter, 3/4 cup sugar, 1 egg, 1 tsp vanilla, 1 tsp baking soda, pinch of salt, 1.5 cups flour
Preheat oven to 350F. Mash bananas, mix in butter, sugar, egg, vanilla. Add dry ingredients. Pour into loaf pan. Bake 60 minutes."

**Generated:**
```cooklang
---
title: Banana Bread
servings: 8
time: 1 hour 15 minutes
prep time: 15 minutes
cook time: 60 minutes
source: (add original source if known)
tags: [baking, breakfast, dessert]
---

Preheat #oven{} to 350°F.

In a #large mixing bowl{}, mash @ripe bananas{3} until smooth.

Mix in @melted butter{1/3%cup}, @sugar{3/4%cup}, @egg{1}, and @vanilla extract{1%tsp}.

Add @baking soda{1%tsp}, @salt{1%pinch}, and @all-purpose flour{1.5%cups}. Stir until just combined.

Pour batter into a greased #loaf pan{}.

Bake for ~oven{60%minutes} or until a toothpick inserted in the center comes out clean.

Let cool before slicing.
```

## Reference

### CookCLI Import

```bash
# Basic import
cook import "https://example.com/recipe"

# Save with specific name
cook import "https://example.com/recipe" -o "My Recipe.cook"
```

**Supported sites:** CookCLI uses recipe-scrapers library. Most major recipe sites work. If import fails, use manual conversion.

### Manual Conversion Patterns

**Ingredient patterns to recognize:**
- "3 large eggs" → `@large eggs{3}`
- "1 cup flour" → `@flour{1%cup}`
- "salt to taste" → `@salt`
- "2-3 cloves garlic" → `@garlic{2-3%cloves}`
- "1/2 tsp vanilla" → `@vanilla{1/2%tsp}`

**Time patterns:**
- "bake for 30 minutes" → `~oven{30%minutes}`
- "simmer 1 hour" → `~{1%hour}`
- "rest 10-15 min" → `~{10-15%minutes}`

**Equipment patterns:**
- "large bowl" → `#large mixing bowl{}`
- "9x13 pan" → `#9x13 baking pan{}`
- "in a skillet" → `#skillet{}`

### Metadata Extraction

Look for these common fields:
- **Title:** Recipe name, usually a heading
- **Servings:** "Serves 4", "Makes 12", "Yields 2 cups"
- **Time:** "Total time: 45 min", "Prep: 15, Cook: 30"
- **Source:** Original URL or "adapted from..."
- **Author:** Recipe creator if credited

### Cooklang Syntax Reminders

- YAML frontmatter with `---` (never `>>`)
- Multi-word ingredients: `@ground black pepper{}`
- Quantities with units: `{500%g}` not `{500g}`
- Separate steps with blank lines

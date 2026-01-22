---
name: create-recipe
description: Create a new Cooklang recipe interactively from a description or template
---

# Create Recipe

## Overview

Create new `.cook` recipe files using Cooklang syntax. Works in three modes:

1. **From description** - Describe the dish and get a formatted recipe
2. **From pasted text** - Convert plain text recipes to Cooklang
3. **Interactive** - Answer questions to build a recipe step-by-step

Use this skill when:
- Starting a new recipe from scratch
- Converting a recipe you found online (without URL)
- Documenting a family recipe from memory

## Process

### Step 1: Determine Input Mode

Ask: "How would you like to create this recipe?"
- **Describe it** - "Tell me about the dish and I'll draft a recipe"
- **Paste text** - "Paste your recipe and I'll convert it to Cooklang"
- **Guide me** - "I'll ask questions to build the recipe step-by-step"

### Step 2: Gather Information

**If describing or guided mode**, collect:
1. Recipe name
2. Servings (default: 4)
3. Total time / prep time / cook time
4. Ingredients with quantities and units
5. Step-by-step instructions
6. Any special equipment needed
7. Tags (cuisine, meal type, dietary info)

**If pasting text**, extract the above from the provided text.

### Step 3: Generate Draft

Create a `.cook` file with:

1. **YAML frontmatter** (always use `---` delimiters, never `>>` syntax):
```yaml
---
title: Recipe Name
servings: 4
time: 30 minutes
prep time: 10 minutes
cook time: 20 minutes
tags: [cuisine, meal-type]
source: (if provided)
---
```

2. **Recipe body** with proper Cooklang markup:
- Ingredients: `@ingredient{quantity%unit}` or `@multi word ingredient{}`
- Cookware: `#pan{}` or `#large mixing bowl{}`
- Timers: `~{15%minutes}`
- Sections for complex recipes: `= Section Name`
- Steps as separate paragraphs (blank line between each)

### Step 4: Refine Interactively

Show the draft and ask:
- "Does this look right?"
- "Any ingredients to add or adjust?"
- "Should I add section headers to organize the steps?"

Make requested changes.

### Step 5: Save File

Ask for the save location:
- Suggest: `<recipe-name>.cook` in current directory
- Or let user specify path

Write the file.

## Examples

**User input:**
> Create a recipe for simple pancakes

**Generated output:**
```cooklang
---
title: Simple Pancakes
servings: 4
time: 20 minutes
prep time: 5 minutes
cook time: 15 minutes
tags: [breakfast, quick]
---

Combine @flour{200%g}, @sugar{2%tbsp}, @baking powder{2%tsp}, and @salt{1/2%tsp} in a #large mixing bowl{}.

In a separate bowl, whisk @eggs{2}, @milk{240%ml}, and @melted butter{30%g}.

Pour wet ingredients into dry ingredients and stir until just combined. Small lumps are okay.

Heat a #non-stick pan{} over medium heat. Pour ~1/4 cup batter per pancake.

Cook until bubbles form on surface, about ~{2%minutes}. Flip and cook another ~{1%minute}.

Serve warm with your favorite toppings.
```

**User input:**
> Convert this recipe:
> Spaghetti Carbonara (serves 2)
> 200g spaghetti, 100g pancetta, 2 eggs, 50g parmesan, black pepper
> Cook pasta. Fry pancetta. Mix eggs and cheese. Combine all off heat.

**Generated output:**
```cooklang
---
title: Spaghetti Carbonara
servings: 2
tags: [pasta, italian, dinner]
---

Cook @spaghetti{200%g} in a #large pot{} of salted boiling water until al dente, about ~{10%minutes}.

While pasta cooks, cut @pancetta{100%g} into small cubes and fry in a #pan{} until crispy.

In a bowl, whisk @eggs{2} with @parmesan{50%g}(finely grated) and @black pepper{}(freshly ground).

Reserve ~1/2 cup pasta water, then drain the spaghetti.

Remove pan from heat. Add hot pasta to pancetta, then quickly pour in egg mixture, tossing constantly. The residual heat will cook the eggs into a creamy sauce.

Add pasta water a splash at a time if needed to loosen the sauce.

Serve immediately with extra parmesan and black pepper.
```

## Reference

### Cooklang Syntax Quick Reference

**Metadata** (YAML frontmatter - always use this format):
```yaml
---
title: Recipe Name
servings: 4
time: 30 minutes
prep time: 10 minutes
cook time: 20 minutes
tags: [tag1, tag2]
source: https://example.com
author: Name
---
```

**Ingredients:**
- Simple: `@salt` or `@pepper`
- With quantity: `@flour{500%g}` or `@eggs{3}`
- Multi-word: `@ground black pepper{}` or `@olive oil{2%tbsp}`
- Fixed (won't scale): `@salt{=1%tsp}`
- With prep: `@onion{1}(finely diced)`

**Cookware:**
- Simple: `#pot` or `#pan`
- Multi-word: `#large mixing bowl{}` or `#non-stick pan{}`

**Timers:**
- Anonymous: `~{15%minutes}` or `~{1%hour}`
- Named: `~oven{25%minutes}`

**Structure:**
- Sections: `= Main Course` or `== Sauce ==`
- Steps: Separate paragraphs (blank line between)
- Comments: `-- this is a comment`
- Notes: `> This is a tip or background note`

### Common Mistakes to Avoid

1. **Never use `>>` for metadata** - Always use YAML frontmatter with `---`
2. **Multi-word ingredients need `{}`** - `@ground black pepper{}` not `@ground black pepper`
3. **Units need `%`** - `@flour{500%g}` not `@flour{500g}`
4. **Steps need blank lines** - Each step must be its own paragraph

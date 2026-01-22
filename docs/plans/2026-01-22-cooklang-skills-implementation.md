# Cooklang Skills Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create a complete set of Claude skills for recipe authors working with Cooklang files and CookCLI.

**Architecture:** 10 markdown skill files in `skills/` directory, following Agent Skills specification with YAML frontmatter. Each skill is self-contained with embedded Cooklang syntax reference.

**Tech Stack:** Markdown files, Agent Skills specification, CookCLI commands

---

## Task 1: Project Scaffolding

**Files:**
- Create: `README.md`
- Create: `LICENSE`
- Create: `skills/` directory
- Create: `examples/sample-recipes/` directory

**Step 1: Create directory structure**

```bash
mkdir -p skills examples/sample-recipes
```

**Step 2: Create LICENSE file**

Create `LICENSE` with MIT license text:

```
MIT License

Copyright (c) 2026 Cooklang

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

**Step 3: Create README.md**

Create `README.md`:

```markdown
# Cooklang Skills

Claude skills for writing and managing recipes with [Cooklang](https://cooklang.org).

## Installation

### Claude Code

Add the `skills/` directory contents to your project's `/.claude/skills/` folder.

### Codex CLI

Add the `skills/` directory contents to `~/.codex/skills/`.

## Skills

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
brew install cooklang/tap/cookcli

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
```

**Step 4: Commit scaffolding**

```bash
git add README.md LICENSE skills/ examples/
git commit -m "Add project scaffolding with README and LICENSE"
```

---

## Task 2: Create Recipe Skill (Flagship)

**Files:**
- Create: `skills/create-recipe.md`

**Step 1: Create the skill file**

Create `skills/create-recipe.md`:

```markdown
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
```

**Step 2: Commit the skill**

```bash
git add skills/create-recipe.md
git commit -m "Add create-recipe skill for authoring new recipes"
```

---

## Task 3: Validate Recipes Skill

**Files:**
- Create: `skills/validate-recipes.md`

**Step 1: Create the skill file**

Create `skills/validate-recipes.md`:

```markdown
---
name: validate-recipes
description: Check Cooklang recipes for syntax errors, warnings, and best practice issues
---

# Validate Recipes

## Overview

Check `.cook` files for problems using CookCLI's doctor command. Reports:
- Syntax errors (invalid Cooklang)
- Warnings (deprecated syntax, missing recommended fields)
- Best practice issues (missing servings, inconsistent formatting)

Use this skill when:
- You've written new recipes and want to check them
- Something isn't working as expected
- Setting up CI/CD for a recipe collection
- Auditing an existing recipe library

## Process

### Step 1: Determine Scope

Ask: "What should I validate?"
- **Single recipe** - Specify file path
- **Directory** - Check all `.cook` files in a folder
- **Entire collection** - Check everything from current directory

### Step 2: Run Validation

**For syntax validation:**
```bash
cook doctor validate
```

**For strict mode (CI/CD):**
```bash
cook doctor validate --strict
```

**For specific directory:**
```bash
cook doctor validate -b /path/to/recipes
```

### Step 3: Report Results

Present findings organized by severity:
1. **Errors** - Must fix (invalid syntax, broken references)
2. **Warnings** - Should fix (deprecated syntax)
3. **Suggestions** - Nice to fix (missing metadata)

### Step 4: Offer Fixes

For common issues, offer to fix automatically:

| Issue | Fix |
|-------|-----|
| Deprecated `>>` metadata | Convert to YAML frontmatter |
| Missing `servings` | Add with sensible default |
| Multi-word ingredient without `{}` | Add braces |
| Missing blank lines between steps | Add them |

Ask: "Would you like me to fix these issues?"

### Step 5: Additional Checks

**Check aisle configuration completeness:**
```bash
cook doctor aisle
```

This reports ingredients not categorized in `aisle.conf`.

## Examples

**User:** "Validate my recipes"

**Run:**
```bash
cook doctor validate
```

**Output interpretation:**
```
Checking recipes...

ERROR in dinner/Pasta.cook:15
  Invalid ingredient syntax: @ground black pepper
  Fix: Use @ground black pepper{} for multi-word ingredients

WARNING in breakfast/Pancakes.cook:1
  Deprecated metadata syntax: >> title: Pancakes
  Fix: Use YAML frontmatter instead

INFO in desserts/Cake.cook
  Missing 'servings' in metadata
  Suggestion: Add servings for proper scaling

Checked 24 recipes: 1 error, 1 warning, 1 suggestion
```

**Offering fix:**
"I found 1 error and 1 warning. Would you like me to fix them?
- Convert `@ground black pepper` to `@ground black pepper{}`
- Convert deprecated `>>` metadata to YAML frontmatter"

## Reference

### Common Validation Errors

| Error | Cause | Solution |
|-------|-------|----------|
| Invalid ingredient | Multi-word without `{}` | Add braces: `@olive oil{}` |
| Invalid quantity | Missing `%` for unit | Add: `{500%g}` not `{500g}` |
| Deprecated metadata | Using `>>` syntax | Convert to YAML frontmatter |
| Broken reference | Recipe file not found | Check path in `@./path/Recipe{}` |
| Invalid timer | Bad format | Use `~{15%minutes}` |

### Strict Mode

Strict mode (`--strict`) treats warnings as errors. Use for:
- CI/CD pipelines
- Pre-commit hooks
- Enforcing standards in shared collections

### CookCLI Doctor Commands

```bash
cook doctor              # Run all checks
cook doctor validate     # Syntax validation only
cook doctor validate --strict  # Strict mode
cook doctor aisle        # Check aisle.conf coverage
cook doctor -b ~/recipes # Specify recipe directory
```
```

**Step 2: Commit the skill**

```bash
git add skills/validate-recipes.md
git commit -m "Add validate-recipes skill for checking recipe syntax"
```

---

## Task 4: Shopping List Skill

**Files:**
- Create: `skills/shopping-list.md`

**Step 1: Create the skill file**

Create `skills/shopping-list.md`:

```markdown
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
```

**Step 2: Commit the skill**

```bash
git add skills/shopping-list.md
git commit -m "Add shopping-list skill for generating grocery lists"
```

---

## Task 5: Convert Recipe Skill

**Files:**
- Create: `skills/convert-recipe.md`

**Step 1: Create the skill file**

Create `skills/convert-recipe.md`:

```markdown
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
```

**Step 2: Commit the skill**

```bash
git add skills/convert-recipe.md
git commit -m "Add convert-recipe skill for importing recipes"
```

---

## Task 6: Search Recipes Skill

**Files:**
- Create: `skills/search-recipes.md`

**Step 1: Create the skill file**

Create `skills/search-recipes.md`:

```markdown
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
```

**Step 2: Commit the skill**

```bash
git add skills/search-recipes.md
git commit -m "Add search-recipes skill for finding recipes"
```

---

## Task 7: Scale Recipe Skill

**Files:**
- Create: `skills/scale-recipe.md`

**Step 1: Create the skill file**

Create `skills/scale-recipe.md`:

```markdown
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
```

**Step 2: Commit the skill**

```bash
git add skills/scale-recipe.md
git commit -m "Add scale-recipe skill for adjusting servings"
```

---

## Task 8: Organize Collection Skill

**Files:**
- Create: `skills/organize-collection.md`

**Step 1: Create the skill file**

Create `skills/organize-collection.md`:

```markdown
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
```

**Step 2: Commit the skill**

```bash
git add skills/organize-collection.md
git commit -m "Add organize-collection skill for managing recipe libraries"
```

---

## Task 9: Meal Plan Skill

**Files:**
- Create: `skills/meal-plan.md`

**Step 1: Create the skill file**

Create `skills/meal-plan.md`:

```markdown
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
```

**Step 2: Commit the skill**

```bash
git add skills/meal-plan.md
git commit -m "Add meal-plan skill for weekly planning"
```

---

## Task 10: Manage Pantry Skill

**Files:**
- Create: `skills/manage-pantry.md`

**Step 1: Create the skill file**

Create `skills/manage-pantry.md`:

```markdown
---
name: manage-pantry
description: Track kitchen inventory, find expiring items, and discover recipes you can make now
---

# Manage Pantry

## Overview

Track what's in your kitchen using CookCLI's pantry features:
- Maintain inventory in `pantry.conf`
- Track expiration dates
- Find items running low
- Discover recipes you can make with what you have

Use this skill when:
- Setting up pantry tracking
- Checking what's about to expire
- Deciding what to cook based on available ingredients
- Updating inventory after shopping or cooking

## Process

### Step 1: Set Up Pantry File

Create or update `config/pantry.conf`:
```toml
[pantry]
flour = "2%kg"
sugar = "1%kg"
rice = "500%g"

[fridge]
milk = { quantity = "1%L", expire = "2026-01-28" }
eggs = "12"
butter = "250%g"

[freezer]
chicken breast = "1%kg"
frozen peas = "500%g"
```

### Step 2: Check Status

**Find depleted items:**
```bash
cook pantry depleted
```

**Find expiring items:**
```bash
cook pantry expiring --days 7
```

### Step 3: Find Recipes

**What can I make now?**
```bash
cook pantry recipes
```

Shows recipes where you have all (or most) ingredients.

### Step 4: Update After Cooking

When you cook a recipe, update quantities:
- Subtract used ingredients
- Note items that are now low

### Step 5: Update After Shopping

Add newly purchased items with quantities and expiration dates.

## Examples

**User:** "Set up pantry tracking"

**Created config/pantry.conf:**
```toml
# Kitchen Inventory
# Update quantities after shopping and cooking

[pantry]
# Dry goods - no expiration needed
flour = "2%kg"
sugar = "1%kg"
rice = "1%kg"
pasta = "500%g"
olive oil = "500%ml"
soy sauce = "200%ml"
salt = "500%g"
black pepper = "100%g"

[fridge]
# Fresh items - track expiration
milk = { quantity = "1%L", expire = "2026-01-28" }
eggs = { quantity = "12", expire = "2026-02-05" }
butter = "250%g"
parmesan = { quantity = "200%g", expire = "2026-02-15" }
cream = { quantity = "250%ml", expire = "2026-01-25" }

[freezer]
# Frozen items - longer dates
chicken breast = "1%kg"
ground beef = "500%g"
frozen peas = "500%g"
```

**User:** "What's expiring soon?"

**Run:**
```bash
cook pantry expiring --days 7
```

**Output:**
```
Items expiring within 7 days:

URGENT (1-2 days):
- cream: 250ml (expires Jan 25)

THIS WEEK:
- milk: 1L (expires Jan 28)

Suggestion: Use cream in Pasta Carbonara or Mushroom Risotto
```

**User:** "What can I make with what I have?"

**Run:**
```bash
cook pantry recipes
```

**Output:**
```
Recipes you can make now:

COMPLETE (have all ingredients):
- Pasta Aglio e Olio
- Fried Rice
- Scrambled Eggs

ALMOST (missing 1-2 items):
- Carbonara (need: pancetta)
- Stir Fry (need: vegetables)
- Pancakes (need: baking powder)
```

## Reference

### Pantry.conf Format

```toml
[section]
# Simple quantity
ingredient = "quantity%unit"

# With expiration
ingredient = { quantity = "amount%unit", expire = "YYYY-MM-DD" }

# With purchase date and low threshold
ingredient = { quantity = "1%kg", bought = "2026-01-15", low = "100%g" }
```

**Sections:** `[pantry]`, `[fridge]`, `[freezer]`, or custom

### CookCLI Pantry Commands

```bash
# Items that are low or out
cook pantry depleted

# Expiring within N days
cook pantry expiring --days 7
cook pantry expiring --days 3

# Recipes you can make
cook pantry recipes
```

### Inventory Attributes

| Attribute | Purpose | Example |
|-----------|---------|---------|
| `quantity` | Amount you have | `"500%g"` |
| `expire` | Expiration date | `"2026-02-15"` |
| `bought` | Purchase date | `"2026-01-10"` |
| `low` | Low stock threshold | `"100%g"` |

### Maintenance Tips

**After shopping:**
- Add new items with quantities
- Update expiration dates
- Reset quantities for restocked items

**After cooking:**
- Subtract used ingredients
- Note items now running low

**Weekly:**
- Check `cook pantry expiring --days 7`
- Plan meals around expiring items
- Check `cook pantry depleted` before shopping
```

**Step 2: Commit the skill**

```bash
git add skills/manage-pantry.md
git commit -m "Add manage-pantry skill for inventory tracking"
```

---

## Task 11: Export Recipe Skill

**Files:**
- Create: `skills/export-recipe.md`

**Step 1: Create the skill file**

Create `skills/export-recipe.md`:

```markdown
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
```

**Step 2: Commit the skill**

```bash
git add skills/export-recipe.md
git commit -m "Add export-recipe skill for format conversion"
```

---

## Task 12: Sample Recipes

**Files:**
- Create: `examples/sample-recipes/Easy Pancakes.cook`
- Create: `examples/sample-recipes/Pasta Carbonara.cook`
- Create: `examples/sample-recipes/Chicken Stir Fry.cook`

**Step 1: Create Easy Pancakes**

Create `examples/sample-recipes/Easy Pancakes.cook`:

```cooklang
---
title: Easy Pancakes
servings: 4
time: 20 minutes
prep time: 5 minutes
cook time: 15 minutes
tags: [breakfast, quick, vegetarian]
---

Combine @flour{200%g}, @sugar{2%tbsp}, @baking powder{2%tsp}, and @salt{1/2%tsp} in a #large mixing bowl{}.

In a separate bowl, whisk @eggs{2}, @milk{240%ml}, and @melted butter{30%g}.

Pour wet ingredients into dry ingredients and stir until just combined. Small lumps are okay.

> Don't overmix! Lumpy batter makes fluffy pancakes.

Heat a #non-stick pan{} over medium heat.

Pour about 1/4 cup batter per pancake.

Cook until bubbles form on surface and edges look set, about ~{2%minutes}.

Flip and cook another ~{1%minute} until golden brown.

Serve warm with maple syrup, fresh berries, or your favorite toppings.
```

**Step 2: Create Pasta Carbonara**

Create `examples/sample-recipes/Pasta Carbonara.cook`:

```cooklang
---
title: Pasta Carbonara
servings: 2
time: 25 minutes
prep time: 10 minutes
cook time: 15 minutes
tags: [italian, pasta, dinner]
source: Traditional Roman recipe
---

Bring a #large pot{} of salted water to boil. Cook @spaghetti{200%g} until al dente, about ~{10%minutes}.

> Reserve pasta water before draining - it's essential for the sauce!

While pasta cooks, cut @guanciale{100%g} into small cubes. Fry in a cold #pan{} over medium heat until crispy and fat renders, about ~{5%minutes}.

> Guanciale is traditional, but pancetta or bacon work too.

In a #bowl{}, whisk @eggs{2} with @egg yolks{2}, @pecorino romano{50%g}(finely grated), and generous @black pepper{}.

Reserve ~{1/2%cup} pasta water, then drain spaghetti.

Remove pan from heat. Add hot pasta to guanciale, tossing to coat in fat.

Working quickly, pour egg mixture over pasta while tossing constantly. The residual heat will create a creamy sauce without scrambling the eggs.

Add pasta water a splash at a time if sauce is too thick.

Serve immediately with extra pecorino and black pepper.
```

**Step 3: Create Chicken Stir Fry**

Create `examples/sample-recipes/Chicken Stir Fry.cook`:

```cooklang
---
title: Chicken Stir Fry
servings: 4
time: 25 minutes
prep time: 15 minutes
cook time: 10 minutes
tags: [asian, quick, dinner, healthy]
---

= Sauce

Whisk together @soy sauce{3%tbsp}, @oyster sauce{2%tbsp}, @sesame oil{1%tsp}, @rice vinegar{1%tbsp}, and @cornstarch{1%tsp} in a small #bowl{}. Set aside.

= Stir Fry

Cut @chicken breast{500%g} into bite-sized pieces. Season with @salt{} and @white pepper{}.

Prep vegetables: slice @bell pepper{2}(mixed colors), @broccoli florets{200%g}, @carrots{2}(julienned), and mince @garlic{3%cloves} and @ginger{1%inch piece}.

Heat @vegetable oil{2%tbsp} in a #wok{} or large pan over high heat until smoking.

Add chicken in a single layer. Cook without stirring for ~{2%minutes} until golden, then stir and cook another ~{2%minutes}. Remove and set aside.

Add more @vegetable oil{1%tbsp} if needed. Stir fry garlic and ginger for ~{30%seconds}.

Add carrots, cook ~{1%minute}. Add broccoli and peppers, cook ~{2%minutes}.

Return chicken to wok. Pour sauce over and toss until everything is coated and sauce thickens, about ~{1%minute}.

Serve immediately over @steamed rice{} with @sesame seeds{} and @green onions{}(sliced) as garnish.
```

**Step 4: Commit sample recipes**

```bash
git add examples/sample-recipes/
git commit -m "Add sample recipes for testing and demos"
```

---

## Task 13: Final Review and Commit

**Step 1: Verify all files exist**

```bash
ls -la skills/
ls -la examples/sample-recipes/
```

**Expected:**
- 10 skill files in `skills/`
- 3 sample recipes in `examples/sample-recipes/`
- README.md and LICENSE in root

**Step 2: Run validation on samples (if CookCLI installed)**

```bash
cook doctor validate -b examples/sample-recipes/
```

**Step 3: Final commit (if any changes)**

```bash
git status
# If clean, done. If not:
git add -A
git commit -m "Final cleanup and verification"
```

**Step 4: Summary**

Project complete with:
- 10 Claude skills for Cooklang
- 3 sample recipes
- README with installation instructions
- MIT license

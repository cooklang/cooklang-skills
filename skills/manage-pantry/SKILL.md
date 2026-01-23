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

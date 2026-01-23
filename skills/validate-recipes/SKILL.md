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

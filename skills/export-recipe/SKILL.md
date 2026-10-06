---
name: export-recipe
description: Use when the user wants a Cooklang recipe (.cook) or meal plan (.menu) in another format - Markdown for a blog or notes, JSON or YAML for an app, plain text to paste or print, HTML, LaTeX - or a reusable export template. Not for importing into Cooklang (recipe-import).
---

# Skill: export-recipe

Use when the user wants a recipe or plan turned into Markdown, JSON, YAML, plain text, HTML, LaTeX or another format to share, paste, print or feed to another program.

**Needs the Cook MCP server** (tools like `read_recipe` and `validate`). If these tools are missing, the Cook MCP server isn't connected: if you installed the cooklang plugin or extension, check that its `cook` server is running (e.g. `/mcp`) or reinstall it; otherwise add it from https://github.com/cook-md/cook-mcp. Do not rewrite a recipe from memory instead.

There is no export tool. Build the export from one of two sources, and never retype quantities yourself.

## Route 1: from `read_recipe` (one-off exports)

`read_recipe` (`path`, optional `scale`) returns the parsed recipe; build the format from it:

- `recipe.metadata.map` — frontmatter (title, servings, tags, times, source…). `title` is also top-level.
- `recipe.ingredients[]` — `name`, `note` (the `(…)` preparation), `quantity` (`null` when none), and `reference` set for `@./` sub-recipes. A quantity is `{unit, value}` where `value` is tagged by `type`: a plain number sits at `quantity.value.value.value` (`{"type": "number", "value": {"type": "regular", "value": 200.0}}`), but it can also be a range or free text, so don't assume a number.
- `recipe.cookware[]` — `name`; `recipe.timers[]` — `quantity` in the same shape.
- `recipe.sections[]` — optional `name`, then `content`: steps (`items` are text pieces plus `ingredient` / `cookware` / `timer` entries pointing by `index` into the lists above) and text blocks (notes). Rebuild a step's sentence by substituting each indexed item.
- With `scale`, every quantity is already scaled (scale-recipe skill).

Use this route for the structure (which fields, what shape). To print quantities and step sentences, Route 2 is safer: `{{ i.quantity }}` renders the amount and unit exactly as the apps do, ranges and text included, and steps come out with amounts filled in.

Good for JSON, where you choose the shape: keep it simple and say which fields you included, for example

```json
{
  "title": "Carbonara",
  "servings": 2,
  "tags": ["pasta"],
  "ingredients": [{"name": "spaghetti", "quantity": 200, "unit": "g", "note": null}],
  "cookware": ["large pot"],
  "steps": ["Cook 200 g spaghetti in a large pot for 10 minutes."]
}
```

If the user names a target schema (schema.org `Recipe` JSON-LD, another app's import format), map onto that instead.

## Route 2: `render_report` with a template (repeatable exports)

A Jinja template renders the same layout for any recipe, and can be saved and reused. Plain templates render locally with no login. The template context has `metadata`, `ingredients` (`.name`, `.quantity`, `.note`), `cookware` (`.name`), `sections` (each has `.name`; iterating one yields its steps, which print as numbered lines with quantities filled in) and `scale`. A Markdown export:

```jinja
# {{ metadata.title | default("Recipe") }}

{% if metadata.servings %}**Servings:** {{ metadata.servings }}
{% endif %}
## Ingredients

{% for i in ingredients -%}
- {% if i.quantity %}{{ i.quantity }} {% endif %}{{ i.name }}{% if i.note %} ({{ i.note }}){% endif %}
{% endfor %}
{% if cookware %}## Equipment

{% for c in cookware -%}
- {{ c.name }}
{% endfor %}{% endif %}
## Method
{% for section in sections %}
{% if section.name %}### {{ section.name }}
{% endif %}{% for content in section %}
{{ content }}
{%- endfor %}
{% endfor %}
```

Call `render_report` with `template` (inline) and `input_path` (plus `scale` if wanted). Plain text is the same template without the Markdown marks; HTML wraps the same loops in tags. Any text format works the same way, since the template is just Jinja: YAML and LaTeX come from a template written in that format (saved as `export.yaml.jinja` / `export.tex.jinja`). Mind whitespace control (`-%}`) where indentation matters, as in YAML. For a `.menu`, the template reads `plan` instead of `ingredients`; see the report-authoring skill for the plan context, filters and datastore functions.

If the user will export again, offer to save the template with `write_config` (`path` e.g. `reports/export.md.jinja`; the inner extension names the format: `.md.jinja`, `.txt.jinja`, `.html.jinja`, `.yaml.jinja`, `.tex.jinja`) and render it later with `template_path`.

## Where the export goes

- cook-mcp does not write export files: `write_recipe` / `write_menu` save Cooklang and `write_config` saves only config and templates. Show the export in the reply, or, if the user wants a file, save it with your client's own file tools and say where.
- Many recipes at once ("export all of Desserts/"): `list_recipes` with `dir`, then one `read_recipe` or `render_report` per file. Tell the user how many files first if it is more than about 10.

## Rules

- Quantities, names and steps come from the tools' output, not from your reading of the source. Keep the recipe's units; convert only if asked.
- Keep `source` / `author` from the frontmatter in the export so the original stays credited.
- Exporting never changes the `.cook` file.

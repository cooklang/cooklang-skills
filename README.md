# Cooklang Skills

Skills and an MCP server that let AI agents work with [Cooklang](https://cooklang.org) recipes: plain-text `.cook` recipes and `.menu` meal plans in a folder you own.

This repo packages two things for every agent client:

- **14 skills**: step-by-step guides the agent follows for writing, validating, searching, scaling, importing and exporting recipes, meal planning, shopping lists, pantry tracking, reports and nutrition.
- **The Cook MCP server** ([`@cookmd/mcp`](https://github.com/cook-md/cook-mcp)): the tools the skills call. It reads, searches, validates and writes your files, builds shopping lists, tracks a pantry and renders reports.

Everything runs locally and is free, with no account. Nutrition and importing from photos or social links use cook.md and need **Cook Basic** or **Cook Pro**.

The server runs through `npx`, so you need Node.js. Builds exist for macOS (arm64, x64) and Linux (x64, arm64). There are no Windows builds yet.

## Install

| Client | Skills | Cook MCP server |
|--------|--------|-----------------|
| [Claude Code](#claude-code) | plugin | plugin |
| [Codex](#codex) | plugin | `codex mcp add` |
| [Gemini CLI](#gemini-cli) | extension | extension |
| [Cursor](#cursor) | `skills/` copy | install link |
| [VS Code / GitHub Copilot](#vs-code--github-copilot) | plugin | install link |
| [Claude Desktop and other MCP clients](#claude-desktop-and-other-mcp-clients) | | JSON config |
| [Any agent, skills only](#skills-only) | `npx skills add` | |

### The recipe folder

The server works on one folder of recipes: `COOK_RECIPES_DIR` if set, otherwise the folder the client starts it in. The configs below point it at your open project or workspace, so open your recipe folder in the client. If the server starts in `/` or your home folder, recipe tools reply that no folder is set; set `COOK_RECIPES_DIR` to an absolute path in the server's config.

### Claude Code

```
/plugin marketplace add cooklang/cooklang-skills
/plugin install cooklang@cooklang-skills
```

The plugin adds the skills and starts the Cook server with your Claude Code project folder as the recipe folder. Check it with `/mcp` (look for `plugin:cooklang:cook`).

### Codex

Install the plugin for the skills, then add the server:

```sh
codex plugin marketplace add cooklang/cooklang-skills
codex plugin add cooklang@cooklang-skills
codex mcp add cook -- npx -y @cookmd/mcp
```

Codex starts a server added with `codex mcp add` in the folder you run Codex in, which becomes the recipe folder. The plugin does not start the server itself yet: plugin servers run inside the plugin's install folder, not your project.

Without plugins, copy the skills instead: `cp -R skills/* ~/.agents/skills/`.

### Gemini CLI

```sh
gemini extensions install https://github.com/cooklang/cooklang-skills
```

The extension adds the skills, a short `GEMINI.md` context file, and the Cook server with your workspace as the recipe folder. Check it with `gemini mcp list`.

### Cursor

Add the server with this link (paste it into your browser if it isn't clickable):

```
cursor://anysphere.cursor-deeplink/mcp/install?name=cook&config=eyJjb21tYW5kIjoibnB4IiwiYXJncyI6WyIteSIsIkBjb29rbWQvbWNwIl0sImVudiI6eyJDT09LX1JFQ0lQRVNfRElSIjoiJHt3b3Jrc3BhY2VGb2xkZXJ9In19
```

It installs this config, which you can also put in `.cursor/mcp.json` or `~/.cursor/mcp.json` by hand:

```json
{
  "mcpServers": {
    "cook": {
      "command": "npx",
      "args": ["-y", "@cookmd/mcp"],
      "env": { "COOK_RECIPES_DIR": "${workspaceFolder}" }
    }
  }
}
```

For the skills, copy `skills/*` into `~/.cursor/skills/` (all projects) or `.cursor/skills/` in your recipe folder. This repo is also an [Agent Plugin](https://agent-plugins.org) (root `plugin.json`), a format Cursor plugins accept.

### VS Code / GitHub Copilot

[Install the Cook server in VS Code](https://vscode.dev/redirect/mcp/install?name=cook&config=%7B%22type%22%3A%22stdio%22%2C%22command%22%3A%22npx%22%2C%22args%22%3A%5B%22-y%22%2C%22%40cookmd%2Fmcp%22%5D%2C%22env%22%3A%7B%22COOK_RECIPES_DIR%22%3A%22%24%7BworkspaceFolder%7D%22%7D%7D), or open this URL directly:

```
vscode:mcp/install?%7B%22name%22%3A%22cook%22%2C%22type%22%3A%22stdio%22%2C%22command%22%3A%22npx%22%2C%22args%22%3A%5B%22-y%22%2C%22%40cookmd%2Fmcp%22%5D%2C%22env%22%3A%7B%22COOK_RECIPES_DIR%22%3A%22%24%7BworkspaceFolder%7D%22%7D%7D
```

Or add it to `.vscode/mcp.json` in your recipe folder:

```json
{
  "servers": {
    "cook": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@cookmd/mcp"],
      "env": { "COOK_RECIPES_DIR": "${workspaceFolder}" }
    }
  }
}
```

For the skills, run **Chat: Install Plugin From Source** from the Command Palette and enter `https://github.com/cooklang/cooklang-skills`.

### Claude Desktop and other MCP clients

Any client that takes an `mcpServers` config. Desktop apps have no project folder, so set `COOK_RECIPES_DIR` to your recipes:

```json
{
  "mcpServers": {
    "cook": {
      "command": "npx",
      "args": ["-y", "@cookmd/mcp"],
      "env": { "COOK_RECIPES_DIR": "/absolute/path/to/recipes" }
    }
  }
}
```

In Claude Desktop this goes in Settings > Developer > Edit Config (`claude_desktop_config.json`).

### Skills only

As an alternative, install just the skills into any agent that reads Agent Skills:

```sh
npx skills add cooklang/cooklang-skills
```

The skills call the Cook server's tools, so add the server too (see your client above).

## Skills

| Skill | Use it for |
|-------|------------|
| `cooklang-editing` | Write a new recipe or edit and fix a `.cook` file |
| `cooklang-validation` | Check recipes, a folder or the whole collection for errors and broken references |
| `metadata` | Add or fix YAML frontmatter (title, tags, servings, times), including bulk changes |
| `recipe-import` | Import a recipe from a URL, photos or pasted text |
| `recipe-search` | Find recipes by ingredient, tag, cuisine, course or a remembered phrase |
| `scale-recipe` | Show a recipe for more or fewer servings |
| `export-recipe` | Turn a recipe into Markdown, JSON, plain text or HTML |
| `organize-collection` | Folder layout, metadata audit, aisle and pantry config, whole-library checks |
| `meal-planning` | Build or edit a `.menu` meal plan |
| `shopping-list` | Shopping lists from recipes or plans, grouped by aisle, minus the pantry |
| `pantry` | Track stock, expiry and low items; what can I cook with what I have |
| `report-authoring` | Custom Jinja reports and printouts with `render_report` |
| `nutrition-reports` | Nutrition evaluation and screening (Cook Basic or Pro) |
| `nutrition-goals` | Change a recipe or plan to hit nutrition targets (Cook Basic or Pro) |

Things to ask:

- "Plan dinners for next week from my recipes and make the shopping list."
- "What can I cook with what's in my pantry?"
- "Check my whole collection for broken references."
- "Import https://example.com/some-recipe as a recipe."
- "How much protein is in this week's plan?" (Cook Basic or Pro)

`examples/sample-recipes/` has three recipes to try this on.

## Upgrading from 1.x

- The skills now call the Cook MCP server instead of CookCLI shell commands. CookCLI is no longer required, though it still reads the same files.
- The 10 old skills are replaced by the 14 above. `create-recipe` is now `cooklang-editing`, `convert-recipe` is `recipe-import`, `validate-recipes` is `cooklang-validation`, `search-recipes` is `recipe-search`, `meal-plan` is `meal-planning` and `manage-pantry` is `pantry`.
- In Claude Code, update with `/plugin marketplace update cooklang-skills`, then reinstall or update the `cooklang` plugin.
- If you added the server by hand with `claude mcp add cook`, remove it (`claude mcp remove cook`) so only one copy is configured. While both exist, Claude Code uses yours and skips the plugin's.

## Repository layout

| Path | For |
|------|-----|
| `skills/<name>/SKILL.md` | The skills, read by every client |
| `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` | Claude Code plugin and marketplace (Codex also reads the marketplace) |
| `plugin.json` | [Agent Plugins](https://agent-plugins.org) manifest (Codex, Cursor, VS Code) |
| `gemini-extension.json`, `GEMINI.md` | Gemini CLI extension and its context file |
| `AGENTS.md` | The same short guide for agents that read `AGENTS.md` |
| `scripts/sync-skills.sh` | Copies `skills/` from cook-mcp |

`skills/` is a copy. The canonical skills live in [cook-md/cook-mcp](https://github.com/cook-md/cook-mcp) next to the server, which also serves them as `cooklang://skills/<name>` resources. Don't edit them here: change them in cook-mcp, then run `scripts/sync-skills.sh [ref]` (default: the latest cook-mcp release). A weekly CI check fails when `skills/` drifts from cook-mcp `main`.

## Links

- [Cook MCP server](https://github.com/cook-md/cook-mcp): tools, environment variables, building from source
- [Cooklang specification](https://cooklang.org/docs/spec/)
- [Cooklang on GitHub](https://github.com/cooklang)

## License

MIT

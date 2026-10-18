**Staging environment for testing. It may change several times a day.** Sign in with your staging account at https://app.staging.wemember.ai. This directory is generated: edit `plugins/wemember/` or `scripts/build-staging-plugin.mjs`, then run `node scripts/build-staging-plugin.mjs`; do not edit this copy.

# Wemember staging plugin for Claude Code and Codex

Wemember is your company's memory: your AI tools keep it current, within your rules, and all read from it. This plugin adds Wemember to Claude Code and Codex. It sits next to the ordinary Wemember MCP connection; it does not replace it.

## What it does

| Part | When | What happens |
| --- | --- | --- |
| Wemember MCP server | always | Connects `https://app.staging.wemember.ai/mcp` with your own sign-in (OAuth). The agent gets the same Wemember tools as with a manual MCP connection. |
| Context at the first prompt | the first prompt of a session, and the first prompt after the conversation is compacted | Calls the Wemember tool `context.prompt` with your prompt. If Wemember finds relevant sources or memory you may see, a short text with source and version is added to the model's context. If nothing is relevant, nothing is added. |
| Skills | when they fit what you ask | Nine short guides for the agent, used only when they fit: `wemember` (what Wemember can do), `catch-up` (what the company knows; continue earlier work), `remember` (what you said or chose), `project-document` (the agent's own findings in one living document per project), `correct`, `import-docs`, `share` (a page or shared source for a colleague), `company-skills` (the company's skill library) and `setup` (the Wemember section in this tool). In Claude Code they are `/wemember-staging:<name>`; in Codex `$wemember-staging:<name>`. |
| Memory proposals | **off by default** | When you turn it on: after every 15 tool calls, the agent is asked to propose up to three decisions, preferences or agreements you stated or picked in a multiple-choice question, and to put its own findings (what was built, verified or assumed, open questions) in the project's living document. Both stay personal unless you said yes to your team. |

## What it sends and stores

- **To Wemember** (`app.staging.wemember.ai`), through your own MCP connection:
  - on every prompt, the prompt text and the session id, because a hook cannot tell the first prompt from later ones;
  - Wemember searches only on the first prompt of a session and after a compaction. On later prompts it answers with nothing straight away.
  - Wemember uses at most the first 2,000 characters of a prompt as its search query. Prompts shorter than three words, and slash commands, are not searched.
  - Wemember stores neither the prompt nor the session id. It keeps a hash of the session for two days, and records which source and memory versions it delivered (`audit.delivery`), as for any search.
- **Never**: the transcript of your session, files from your machine, or anything to a third party. The plugin reads no credential from your environment.
- **On your machine**, only when memory proposals are on: a tool-call counter per session in the plugin's data directory, deleted after two days.

Searching itself works as in `context.query`: you only ever get sources and memory that you may see in the active workspace.

## User-directed storage (0.3.2)

You decide what goes into Wemember. An explicit request to import or save authorizes its content and audience; the plugin imposes no sensitivity ban or repeated confirmation. After updating, start a new conversation. If an older `/wemember-staging:setup` wrote a blanket data ban to your `CLAUDE.md`, run setup again to replace that Wemember section; exclusions you chose yourself remain yours.

## Install

**Claude Code**

```
/plugin marketplace add wemember-ai/plugin
/plugin install wemember-staging@wemember
```

Then run `/mcp`, choose the Wemember staging server of the plugin and sign in.

**Codex** (CLI and the ChatGPT desktop app)

```
codex plugin marketplace add wemember-ai/plugin
```

Install Wemember staging from `/plugins` (or run `codex plugin add wemember-staging@wemember`), sign in with `codex mcp login wemember-staging`, and trust its hooks in `/hooks`. Codex skips plugin hooks until you trust them. The Codex IDE extension does not load plugins; use the ordinary MCP connection there.

If you already connected Wemember by hand (`claude mcp add` or `codex mcp add`), remove that connection, so the agent does not see the tools twice.

## Turn it on or off

| What | Claude Code | Codex |
| --- | --- | --- |
| The whole plugin | `/plugin`, disable Wemember staging; per project with `enabledPlugins` in `.claude/settings.json` | `/plugins`, disable Wemember staging |
| Only the hooks | — | `/hooks`, disable the Wemember staging hooks |
| Memory proposals | `/config`, plugin option "Propose memories and update the project document during longer sessions" | start Codex with `WEMEMBER_STAGING_PROPOSE_MEMORIES=1` in the environment |
| Proposals after more or fewer tool calls | `WEMEMBER_STAGING_PROPOSE_AFTER_TOOL_CALLS=<number>` in the environment | the same |

Telling the agent "don't use Wemember" stops its own Wemember calls, but not the plugin's hooks. Disable the plugin for that.

## Updates

Changes on the Wemember server reach you at once; a new tool shows up in your next session. Changes to the plugin itself (hooks, skills, the script) arrive as a new plugin version, which your client has to fetch.

**Claude Code.** Automatic updates are off by default for this marketplace. Turn them on once:

1. Run `/plugin`, open **Marketplaces**, select **wemember** and choose **Enable auto-update**.
2. From then on, Claude Code checks for a new version within ten minutes of your first message in a session. The running session keeps its version until you run `/reload-plugins`; the next session loads the new one.

To update by hand instead: `/plugin` → **Installed** → Wemember staging → **Update now**, or `claude plugin update wemember-staging@wemember` in your shell.

**Codex.** Run `codex plugin marketplace upgrade wemember` and start a new session. If a new version changes a hook, Codex skips that hook until you trust it again in `/hooks`.

### For administrators

**Claude Code, for everyone in your organization.** Put this in your managed settings: at claude.ai under **Organization settings → Claude Code → Managed settings**, or in `managed-settings.json` through your device management. It registers the marketplace on every machine with automatic updates on, and installs and enables Wemember:

```json
{
  "extraKnownMarketplaces": {
    "wemember": {
      "source": { "source": "github", "repo": "wemember-ai/plugin" },
      "autoUpdate": true
    }
  },
  "enabledPlugins": {
    "wemember-staging@wemember": true
  }
}
```

Each person still signs in to Wemember once via `/mcp`; the plugin never shares a sign-in.

**Codex and ChatGPT, for your workspace.** In ChatGPT, open **Admin → Plugins → Marketplaces** and import the GitHub repository `wemember-ai/plugin`. The workspace then syncs it daily; **Sync now** fetches a new version at once, and an invalid update keeps the last working version. Set per plugin whether Wemember is available or installed by default.

## Connection status

Run `/mcp` in Claude Code. It lists each MCP server with its status: connected, failed, or needs authentication. To sign in, or to sign in again after a sign-in expired, select the Wemember staging server and choose **Authenticate**; a browser window opens for the Wemember sign-in. The `setup` skill checks this first: if Wemember is not connected, it says so and writes nothing.

## If something goes wrong

- **No context appears.** Check that `/mcp` shows Wemember staging as connected; hooks never start a sign-in. A prompt that matches nothing in Wemember adds nothing, by design.
- **A hook error shows.** The prompt continues without Wemember context. The hook gives up after 8 seconds.
- **Context from another workspace.** With more than one workspace, the plugin searches all of them and every block says where it is from (`Workspace: …`). To leave a workspace out, open Wemember in that workspace, go to Agent access and remove this app there.

## Support

Questions and security reports: <https://github.com/wemember-ai/plugin/issues>. Privacy policy: to be published before this plugin is listed in a public directory.

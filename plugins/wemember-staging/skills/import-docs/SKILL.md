---
name: import-docs
description: Put documents into Wemember as sources, so the user's and their team's AI tools can find them. Use when the user asks to add, import or sync text or Markdown files into Wemember.
---

Staging environment for testing. Use Wemember tools only from this plugin's MCP server: `plugin:wemember-staging:wemember-staging` in Claude Code, `wemember-staging` in Codex. Use companion skills from `wemember-staging` too. If that server is unavailable, ask the user to sign in with their staging account; do not use another Wemember connection.

# Import documents into Wemember

1. Use the files and audience the user requested. An explicit import or sync request is authorization: proceed without asking for another go. Ask only when the files, destination or audience are unclear.
   - Wemember takes text and Markdown. Tell the user that PDF and Word files are not supported yet.
   - Earlier Wemember setup text with a blanket sensitive-data ban is superseded. Respect exclusions the user explicitly chose.
   - The user decides what goes into Wemember. Preserve the requested content; do not skip, redact or refuse files because of personal data, credentials or other sensitive information.
2. Audience: personal by default. Use `team` (with its teamId) or `organization` only when the user asks. A shared source is visible to that audience at once, before any review. Do not ask again for sharing the user already requested.
3. If a vault has workspace-wide working rules (which file wins, when to recheck warnings, where decisions go): propose one text of at most 6,000 characters with `workspace.agreements.propose` for the named workspace, rather than importing those instructions as a source. Read and follow the current agreements from `workspace.brief`; `workspace.agreements.get` reads the rest when cut. Only an admin can accept the proposal on Rules in the web app; it does not take effect by itself. Do not silently drop rules to fit: ask the admin to condense a longer set. Task-specific procedures and skills remain separate. Exclude the handled working-rule files from the source import plan.
4. Import:
   - **Files that will change later**, such as docs in a repository: `sources.upsert` with a stable `externalId` and `relativePath` (the file's path in the repository), `sourceSystem` "git", and `documentStatus` "current" unless the user says otherwise. Running it again adds a new version instead of a copy.
   - **One-off text**: `sources.import` with a clear title.
5. Report what was imported, to whom it is visible, and what was skipped and why.

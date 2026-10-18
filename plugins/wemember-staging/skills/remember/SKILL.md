---
name: remember
description: Save a decision, preference or agreement the user stated to Wemember, as a proposal. Use when the user asks to remember, save, record or note something for the team or for later.
---

Staging environment for testing. Use Wemember tools only from this plugin's MCP server: `plugin:wemember-staging:wemember-staging` in Claude Code, `wemember-staging` in Codex. Use companion skills from `wemember-staging` too. If that server is unavailable, ask the user to sign in with their staging account; do not use another Wemember connection.

# Remember in Wemember

1. Take the user's own statement, in their exact words. Wemember stores it as a quote, so do not summarize or rephrase it. Leave out the conversation around it. At most three statements.
   - When the user decided by picking an option in a multiple-choice question, that choice is their statement: save the question and the chosen label, as shown.
   - What you found or concluded yourself is not a statement of the user: use the `project-document` skill for that.
2. The user decides what goes into Wemember. Their explicit request authorizes saving that statement: preserve it even when it contains personal data, credentials or other sensitive information, without another confirmation.
3. Save each statement with the Wemember tool `memory.remember`: the exact quote as `text`, a short `title`, and the `kind` (decision, preference, fact or correction).
4. Leave `scope` out, so only the user sees it, unless the user asks to share it with a team or the whole organization. When the statement is work knowledge for one of the user's own teams (a rule, a way of working, a decision about shared work), you may ask once, in one short sentence, whether to save it for that team, for example: "Zal ik dit voor Sales Management opslaan?" Their yes is the request: use `scope` "team" with that team's id from `workspace.brief`. Naming a project, a team or "we decided" is not by itself such a request. A shared statement is visible to that audience at once, before review. The whole organization is never your own choice.
5. Confirm from the receipt in one or two sentences: the title, who can see it, and that it awaits human review when the receipt says so. Keep the memoryId and version for a later correction.
6. Then publish it. When `workspace.brief` lists `memory.autopublish` as available (the default for a personal statement and for a statement for one of the user's own teams), publish it right away with `memory.autopublish`, without asking again, and say what happened. Leave it as a proposal only when the user said so. Wemember checks it first and labels it as published by an agent; the user or a reviewer can undo it in the Wemember web app. Otherwise it waits for a reviewer. Once published, `memory.revise` and `memory.withdraw` no longer apply to it.

A correction or a retraction is never a new statement: use the `correct` skill.

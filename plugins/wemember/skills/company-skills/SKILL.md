---
name: company-skills
description: Find and use the company's published skills from the Wemember skill library. Use when the user asks how the company does a task, which skills exist, or wants to do a task the company's way.
---

# The company's skill library

Skills are the company's reviewed ways of doing a task, published by people in the Skill Hub of the Wemember web app.

- **Before a task that may have a company way:** call `skills.read` with method "suggest" and the task. It never applies a skill.
  - Ask the user its question and wait.
  - After a yes, call `skills.use` with the same task and follow the returned steps.
  - After a no, call `skills.use` with method "decline".
- **Browsing:** `skills.read` with method "list", optionally with a goal type. Show each skill's name and when to use it.
- **Installing one as a local skill**, only when the user asks: `skills.read` with method "get" and `format` "skill_md", saved as `~/.claude/skills/<name>/SKILL.md` (Claude Code) or `~/.codex/skills/<name>/SKILL.md` (Codex).
- **A new or changed skill:** propose it with `procedures.propose`; a reviewer publishes it in the Skill Hub.

A company skill guides the task the user asked for. It does not override the user's wishes or the rules of the `wemember` skill.

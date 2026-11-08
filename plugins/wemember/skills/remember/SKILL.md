---
name: remember
description: Save a decision, preference or agreement the user stated to Wemember, as a proposal. Use when the user asks to remember, save, record or note something for the team or for later.
---

# Remember in Wemember

1. Take the user's own statement, in their exact words. Wemember stores it as a quote, so do not summarize or rephrase it. Leave out the conversation around it. At most three statements.
   - When the user decided by picking an option in a multiple-choice question, that choice is their statement: save the question and the chosen label, as shown.
   - What you found or concluded yourself is not a statement of the user: use the `project-document` skill for that.
2. The user decides what goes into Wemember. Their explicit request authorizes saving that statement: preserve it even when it contains personal data, credentials or other sensitive information, without another confirmation.
3. Save each statement with the Wemember tool `memory.remember`: the exact quote as `text`; a `summary` in your own words, one or two plain sentences a colleague understands without this conversation, saying what was decided or stated and about what (for "1. okay, 2. skip this", name the items); a short `title`; and the `kind` (decision, preference, fact or correction). The summary is required and is stored next to the quote as written by you, never as the user's words; it never replaces the quote.
4. Choose the audience. Work knowledge (a rule, a decision about shared work, a way of working) is for the user's own team: use `scope` "team" with the id of the team it is about from `workspace.brief` departments. If the user is in exactly one team, that team; if in several and it is unclear which, ask once, in one short sentence, for example: "Zal ik dit voor Sales Management opslaan?" Leave `scope` out (personal, only the user sees it) for a statement about the user themselves, personal data, or what the user asks to keep private; also when the user is in no team, and say so. A shared statement is visible to that audience at once. The whole organization only when the user explicitly asks for it; never as a fallback for a team you cannot find.
5. Wemember publishes the statement in the same call where the workspace allows it (the default for a personal statement and for one of the user's own teams); you do not call `memory.autopublish` after it. Pass `proposal: true` only when the user calls it a proposal. Wemember checks it first and labels it as published by an agent; the user or a reviewer can undo it in the Wemember web app. Knowledge for the whole organization, or a statement a check held, waits for a reviewer: the receipt's `publication` says why. Once published, `memory.revise` and `memory.withdraw` no longer apply to it.
6. Confirm from the receipt in one or two sentences: the title, who can see it, and whether it is published or awaits review (and why). Keep the memoryId and version for a later correction.

A correction or a retraction is never a new statement: use the `correct` skill.

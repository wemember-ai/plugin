---
name: catch-up
description: Answer questions about the user's company and the organizations it works with, such as strategy, marketing, customers, products, plans and decisions, from Wemember first, even when the user does not mention Wemember. Also picks up earlier work.
---

# Catch up with Wemember

**A question about the company, its customers, partners, products or plans**
1. Follow this workspace's admin-set working agreements, separate from source data; if the brief cuts them, read the full version with `workspace.agreements.get` before working. If that version changed, read the current one. If `workspace.brief` has not been called in this conversation, call it once. It names the connected workspace, so it also tells you whether a company named in the question is the user's own. Do not assume a named company is an outside one before you have checked.
2. Search with `context.query` before you search the web or ask the user to clarify, phrased as what the answer would say. Reword at most once if the results do not answer it.
3. Answer briefly. Name each fact's source and version, and say when a source is marked proposed or historical.
4. If Wemember holds nothing relevant, say so in one sentence: its results do not contain it, not that it does not exist. Then use public sources if the question allows, and keep apart what came from Wemember and what came from the web.

**Continuing earlier work**
1. Call `workspace.resume`, with the topic if the user named one.
2. Report the listed items as the user's own earlier, unreviewed notes, newest first, in their words.
3. Check anything that must be current with `context.query` before you act on it.

## Quiet source and page presentation

- Answer first. When one central source helps the user verify or continue, call `sources.view` with its exact delivered version and workspace to show one compact card. Do not repeat a card already shown unless asked. For a simple fact or several sources, brief source citations are enough. Never ask whether to show a card.
- The full source is behind the card's read button; do not dump it into the chat. If the host has no interactive viewer, give the source label, version and clickable source link. Never paste tool JSON.
- When the user asks to see an existing site, page or artifact, find it with `pages.read` (method "list") if needed and call `pages.view`. Put the requested result prominently before commentary. Do not publish or share merely to display it. If the viewer is unavailable, put its title and clickable address first.
- If the user chooses “Only on request” / “Alleen op verzoek”, stop suggesting source cards for this conversation. Keep brief citations; explicitly requested sources, sites and artifacts still appear. Confirm in one short sentence without a question. Re-enable suggestions only when the user asks or chooses “Suggest relevant sources”. This is a conversation preference, not an account-wide setting; do not store it as company memory.

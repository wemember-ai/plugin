---
name: project-document
description: Keep a living project document in Wemember with what you found yourself: what was built, what is verified or only assumed, open questions. Use at the end of project work or when asked for the project status.
---

# Keep the project document

Your own findings go here, never into `memory.remember`: a memory is only what the user said or chose. One document per project, changed in place, so the team reads the current state instead of loose notes.

1. **What goes in.** What others need to continue: what was built or changed (with the pull request or file), what is verified and how, what is only assumed, and open questions with whom they are for. Not the conversation, not code or git history.
2. **When.** When the user asks, or when the Wemember hook asks you (the user turned that on). Otherwise offer it once, in one short sentence, and write nothing without a yes.
3. **Which project and workspace.** A short, stable slug for the project, from the repository or the customer project, for example `eazier-business-central`; reuse the slug the document already has. Use the workspace the user named or confirmed (argument `workspace`); ask when that is unclear.
4. **Find it** with `sources.provenance`: `sourceSystem` "project" and `externalId` the slug. It gives the version, contentHash, scope and team.
5. **Not there yet:** create it with `sources.upsert`:
   - `sourceSystem` "project", `externalId` the slug, `relativePath` "projects/<slug>.md", `documentStatus` "current";
   - title "<Project>: status and open questions", in the user's language;
   - `scope` "personal", unless the user said yes to one of their own teams: then "team" with the teamId from `workspace.brief`. Never the whole organization on your own;
   - Markdown text with the sections Status, Built, Verified, Assumed and Open questions; date each line.
6. **Already there:**
   - New findings: `sources.append` with `sourceSystem`, `externalId`, `expectedVersion` and the new dated lines.
   - Something changed (a question answered, an assumption proven or refuted, the status moved): read the text with `sources.get`, change those lines, and save the whole text with `sources.upsert` and `expectedVersion`. Keep `title`, `relativePath`, `scope` and `teamId` as they are: changing the scope changes who can see it.
   - On `stale_version`: re-read and retry once with the new version.
   - On `not_found` while saving: the slug belongs to someone else's document, possibly one you cannot see. Make no copy under another name: tell the user, and give them the lines for the owner.
7. **The user's decisions** go with the `remember` skill, in their own words. The document may refer to a decision ("decided on 18 October, in Wemember") but does not quote anyone.
8. **Report** in one or two sentences: the document title, what was added or changed, and who can see it.

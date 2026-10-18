#!/bin/sh
# Wemember plugin: optional proposals during a longer session (README.md, "Memory proposals").
#
# Off unless the user turns it on: the plugin option propose_memories in Claude Code, or WEMEMBER_STAGING_PROPOSE_MEMORIES=1 in
# the environment Claude Code or Codex starts from. When off, every call exits at once and writes nothing.
#
#   propose-memories.sh count        PostToolUse: count this session's tool calls since the last ask
#   propose-memories.sh stop-claude  Stop in Claude Code: ask after enough tool calls, then count again from zero
#   propose-memories.sh stop-codex   Stop in Codex: the same, in Codex's Stop format
#
# It asks again after every threshold of tool calls, not once per session: a decision taken late in a session, after
# an earlier ask, is otherwise never asked about.
#
# It reads only session_id and stop_hook_active from the hook event on stdin. It never reads the transcript, sends
# nothing over the network and keeps only a counter per session in the plugin's data directory, deleted after two days.

set -u

case "${CLAUDE_PLUGIN_OPTION_PROPOSE_MEMORIES:-}${WEMEMBER_STAGING_PROPOSE_MEMORIES:-}" in
  *true*|*1*) ;;
  *) exit 0 ;;
esac

data="${CLAUDE_PLUGIN_DATA:-${PLUGIN_DATA:-}}"
[ -n "$data" ] || exit 0

event=$(tr -d '\n\r')
session=$(printf '%s' "$event" | sed -n 's/.*"session_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | tr -cd 'A-Za-z0-9._-' | cut -c1-120)
[ -n "$session" ] || exit 0

dir="$data/wemember-staging-sessions"
mkdir -p "$dir" 2>/dev/null || exit 0
count_file="$dir/$session.calls"
threshold="${WEMEMBER_STAGING_PROPOSE_AFTER_TOOL_CALLS:-15}"
case "$threshold" in ''|*[!0-9]*) threshold=15 ;; esac

reason='Use only the wemember-staging MCP server in Codex or plugin:wemember-staging:wemember-staging in Claude Code. Wemember staging (you turned on proposals) has two separate routes. 1) What the user said: if the user stated a decision, a preference or an agreement since the last ask that is worth keeping for the team, propose at most three, each with Wemember memory.remember in the exact words of the user. An option the user picked in a multiple-choice question counts as their statement: save the question and the chosen label. Personal scope, unless the user said yes to saving it for one of their own teams. The user decides what is stored; preserve their statement without a content safeguard. 2) What you found yourself: what you built, what is verified and what only assumed, and open questions with whom they are for, go to the living document of this project with the project-document skill (sources.provenance, then sources.append or sources.upsert), personal unless the user said yes to their team. Never store your own findings with memory.remember or as words of the user. With more than one workspace, name the workspace each one belongs to (argument workspace); ask the user when that is unclear. Then confirm in one short sentence what you saved where. If nothing qualifies, save nothing and reply only: Nothing to propose to Wemember.'

case "${1:-}" in
  count)
    calls=0
    # A new session clears out the files of sessions older than two days.
    [ -f "$count_file" ] || find "$dir" -type f -mtime +2 -exec rm -f {} + 2>/dev/null
    [ -f "$count_file" ] && calls=$(cat "$count_file" 2>/dev/null)
    case "$calls" in ''|*[!0-9]*) calls=0 ;; esac
    printf '%s\n' $((calls + 1)) > "$count_file"
    ;;
  stop-claude|stop-codex)
    printf '%s' "$event" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true' && exit 0
    calls=0
    [ -f "$count_file" ] && calls=$(cat "$count_file" 2>/dev/null)
    case "$calls" in ''|*[!0-9]*) calls=0 ;; esac
    [ "$calls" -ge "$threshold" ] || exit 0
    printf '0\n' > "$count_file"
    if [ "$1" = stop-claude ]; then
      printf '{"hookSpecificOutput":{"hookEventName":"Stop","additionalContext":"%s"}}\n' "$reason"
    else
      printf '{"decision":"block","reason":"%s"}\n' "$reason"
    fi
    ;;
esac
exit 0

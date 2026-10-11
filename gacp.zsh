# gacp: git add, commit, push, in one command.
#   gacp     add everything, commit as "claude update", ask whether to push
#   gacp -m  same, but Claude (Haiku, via the Claude Code CLI) writes a one-line message from the staged diff
gacp() {
    git add . || return 1
    git diff --cached --quiet && { echo "Nothing to commit."; return 1; }
    local msg="claude update"
    if [[ $1 == -m ]]; then
        command -v claude >/dev/null || { echo "gacp -m needs the Claude Code CLI (claude)."; return 1; }
        echo "Writing commit message…"
        msg=$( { git diff --cached --stat; echo; git diff --cached | head -c 60000; } |
            claude -p --model haiku --tools "" --no-session-persistence \
                "Write a one-line git commit message for this staged diff: an imperative summary of what changed, at most 72 characters. Output only that line: no quotes, no Markdown, no preamble." | head -1 )
        [[ -z $msg ]] && { echo "Could not write a message; nothing committed."; return 1; }
    fi
    git commit -q -m "$msg" || return 1
    echo "→ $msg"

    if read -q "?Push to remote? (y/n) "; then
        echo
        git push
    else
        echo
        echo "Skipped push."
    fi
}

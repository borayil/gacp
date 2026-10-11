# gacp

`git add` + `commit` + `push` in one zsh command, with an optional commit message written by Claude.

```
$ gacp -m
Writing commit message…
→ Add sub function and type add/sub parameters
Push to remote? (y/n)
```

## Usage

| Command | What it does |
|---|---|
| `gacp` | Adds everything, commits as "claude update", asks whether to push |
| `gacp -m` | Same, but Claude writes a one-line message from the staged diff |

- With nothing to commit, it says so and stops.
- If no message comes back, nothing is committed: it never falls back to the default message.
- Don't like the message? `git commit --amend` before answering `y`.

## Install

Needs **zsh**, and for `-m` the [Claude Code CLI](https://docs.claude.com/en/docs/claude-code) (`claude`), logged in.

```sh
git clone https://github.com/borayil/gacp ~/gacp
echo '[ -f ~/gacp/gacp.zsh ] && source ~/gacp/gacp.zsh' >> ~/.zshrc
source ~/.zshrc
```

## Good to know

- `-m` sends `git diff --stat` and the first 60 KB of the staged diff to Anthropic through Claude Code (model: Haiku,
  no tools, no saved session). Don't use it on code you may not share with them.
- `git add .` stages **everything** not in `.gitignore`. Check `git status` first if you keep secrets or data files
  in the working tree.
- Each `-m` is one small Claude call, counted against your Claude plan or API usage.

## License

MIT

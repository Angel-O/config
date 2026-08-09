# config

Git config file with useful aliases, enjoy.

Files:
- `gitconfig template`: documented git alias template, including the worktree aliases.
- `worktree-functions.zsh`: `zsh` worktree helpers (`gwtl`, `gwtp`, `gwtco`, `gwtrm`, `gwts`) plus Git-aware navigation helpers.

Worktree layout:
- New worktrees use `~/workspace/worktrees/<repo>/<branch-slug>` to match Herdr.
- Configure Herdr with `[worktrees]` and `directory = "~/workspace/worktrees"`.
- Branch slugs are lowercase and replace non-alphanumeric runs with `-`, so `feature/login` becomes `feature-login`.
- Existing worktrees in other locations remain supported because navigation and removal resolve paths from `git worktree list`.
- Slug-equivalent branches such as `feature/login` and `feature-login` cannot use the default path simultaneously.

Requirements:
- `gwts` requires `fzf` to be installed. On macOS with Homebrew: `brew install fzf`
- Optional: enable `fzf` zsh key bindings and completion with `source <(fzf --zsh)`

# config

Git config file with useful aliases, enjoy.

Files:
- `gitconfig template`: documented git alias template, including the worktree aliases.
- `worktree-functions.zsh`: `zsh` worktree helpers (`gwtl`, `gwtp`, `gwtco`, `gwtrm`, `gwts`) plus navigation helpers for moving between the main checkout and sibling worktrees.

Requirements:
- `gwts` requires `fzf` to be installed. On macOS with Homebrew: `brew install fzf`
- Optional: enable `fzf` zsh key bindings and completion with `source <(fzf --zsh)`

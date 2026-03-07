# Oh My Zsh-style wrappers around the git worktree aliases defined in the
# gitconfig template.
alias gwtl='git wtl'
alias gwtp='git wtp'
alias gwtrm='git wtrm'

# Create or attach the requested worktree via `git wtco`, then cd into it so
# the command feels closer to `gco` in day-to-day use.
gwtco() {
  local top repo branch worktree_path

  top=$(command git rev-parse --show-toplevel) || return
  repo="${top:t}"

  if [ "$1" = "-b" ]; then
    branch="$2"
  else
    branch="$1"
  fi

  worktree_path="../${repo}-worktrees/${branch}"

  if [ -d "$worktree_path" ]; then
    cd "$worktree_path" || return
    return
  fi

  command git wtco "$@" || return
  cd "$worktree_path" || return
}

# cd into the directory associated to the given worktree. Assumes the
# worktree lives in a sibling directory suffixed with `-worktrees`.
cdwt() {
  local top repo
  top=$(command git rev-parse --show-toplevel) || return
  repo="${top:t}"
  cd "../${repo}-worktrees/$1" || return
}

# cd back into the project the worktree was created from. Assumes the same
# folder structure and naming convention as `cdwt`, and is intended to be run
# from inside a repo located under a `*-worktrees` directory.
cdmain() {
  local top parent base
  top=$(git rev-parse --show-toplevel) || return
  parent=$(dirname "$top")
  base=$(basename "$parent")

  case "$base" in
    *-worktrees)
      cd "$(dirname "$parent")/${base%-worktrees}" || return
      ;;
    *)
      printf 'cdmain: current repo is not inside a *-worktrees directory\n' >&2
      return 1
      ;;
  esac
}

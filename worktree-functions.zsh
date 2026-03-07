# Oh My Zsh-style shorthand wrappers around the git worktree aliases defined in
# the gitconfig template.
alias gwtl='git wtl'
alias gwtp='git wtp'
alias gwtco='git wtco'
alias gwtrm='git wtrm'

# cd into the directory associated to the given worktree. Assumes the
# worktree lives in a sibling directory suffixed with `-worktrees`.
cdwt() {
  local repo
  repo=$(basename "$(git rev-parse --show-toplevel)") || return
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

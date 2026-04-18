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

# Interactively select a worktree with fzf and cd into it. Requires fzf to be
# installed and available either on PATH or via the default Homebrew location.
gwts() {
  local selected worktree_path fzf_bin

  if command -v fzf >/dev/null 2>&1; then
    fzf_bin=$(command -v fzf)
  elif [ -x /opt/homebrew/bin/fzf ]; then
    fzf_bin=/opt/homebrew/bin/fzf
  else
    printf 'gwts: fzf is not installed. Install it with: brew install fzf\n' >&2
    return 1
  fi

  selected=$(
    command git worktree list --porcelain | awk '
      /^worktree / {
        path = substr($0, 10)
      }
      /^branch / {
        branch = $2
        sub(/^refs\/heads\//, "", branch)
        printf "%s\t%s\n", branch, path
      }
      /^detached$/ {
        printf "(detached)\t%s\n", path
      }
    ' | "$fzf_bin" \
      --height=40% \
      --reverse \
      --border \
      --prompt='Worktree> ' \
      --info='inline-right:?: toggle preview  ' \
      --no-separator \
      --bind 'pgup:preview-page-up,pgdn:preview-page-down,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,?:toggle-preview' \
      --delimiter=$'\t' \
      --with-nth=1 \
      --preview-window='right:60%' \
      --preview-label=' ctrl-u/d: scroll preview ' \
      --preview 'printf "Path: %s\n\n" {2}; git -C {2} status --short --branch'
  ) || return

  worktree_path="${selected#*$'\t'}"
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

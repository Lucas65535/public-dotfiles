# Environment and PATH (idempotent)

typeset -gU path PATH

# OS-specific defaults
case "$(uname -s)" in
  Darwin)
    path=(/usr/local/bin $path)
    ;;
  Linux)
    path=(/usr/local/sbin /usr/local/bin $path)
    ;;
esac

# User binaries
path=(
  "$HOME/.local/bin"
  "$HOME/.bun/bin"
  "$HOME/.antigravity/antigravity/bin"
  $path
)

export BUN_INSTALL="$HOME/.bun"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export LS_COLORS="${LS_COLORS:+$LS_COLORS:}di=38;2;56;98;144"
export PSQL_PAGER="${PSQL_PAGER:-less -RSX}"
export PATH

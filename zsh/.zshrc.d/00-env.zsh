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
export PATH

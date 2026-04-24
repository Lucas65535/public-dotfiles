# Shell functions

startgit() {
  local top
  top="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo 'Not inside a git repository.'
    return 1
  }

  cd "$top" || return
  git checkout main && git pull
}

dtags() {
  local image="$1"
  if [[ -z "$image" ]]; then
    echo 'Usage: dtags <docker-image>'
    return 1
  fi

  curl -s -S "https://registry.hub.docker.com/v2/repositories/library/${image}/tags/" \
    | jq '.["results"][]["name"]' \
    | sort
}

# Wrapper: quit yazi and cd to the directory you navigated to.
y() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)" || return
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

wiki() {
  local session_name="wiki"
  local session_dir="$HOME/workspace/ob-docs"
  local cols lines

  command -v tmux >/dev/null 2>&1 || {
    echo 'tmux not found.'
    return 1
  }
  command -v sesh >/dev/null 2>&1 || {
    echo 'sesh not found.'
    return 1
  }
  [[ -d "$session_dir" ]] || {
    echo "wiki: directory not found: $session_dir"
    return 1
  }

  if ! tmux has-session -t "$session_name" 2>/dev/null; then
    cols="${COLUMNS:-$(tput cols 2>/dev/null)}"
    lines="${LINES:-$(tput lines 2>/dev/null)}"

    if [[ "$cols" =~ '^[0-9]+$' && "$lines" =~ '^[0-9]+$' ]]; then
      tmux new-session -d -s "$session_name" -c "$session_dir" -x "$cols" -y "$lines"
    else
      tmux new-session -d -s "$session_name" -c "$session_dir"
    fi
  fi

  sesh connect "$session_name"
}

azswitch() {
  command -v az >/dev/null 2>&1 || {
    echo 'Azure CLI not found.'
    return 1
  }
  command -v fzf >/dev/null 2>&1 || {
    echo 'fzf not found.'
    return 1
  }

  local sub_info sub_id
  sub_info="$(az account list --query "[].{name:name, id:id, isDefault:isDefault}" -o tsv | column -t -s $'\t' | fzf --header 'Select Azure Subscription' --query "$1")"

  if [[ -n "$sub_info" ]]; then
    sub_id="$(echo "$sub_info" | awk '{print $(NF-1)}')"
    if [[ -n "$sub_id" ]]; then
      az account set --subscription "$sub_id"
      echo "Switched to: $(az account show --query name -o tsv)"
    fi
  fi
}

dotfiles_theme_mode() {
  if [[ -n "${DOTFILES_THEME_MODE:-}" ]]; then
    print -r -- "$DOTFILES_THEME_MODE"
    return 0
  fi

  if [[ "$(uname -s)" == "Darwin" ]]; then
    if ! defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
      print -r -- "light"
      return 0
    fi
  fi

  print -r -- "dark"
}

dotfiles_lazygit_config() {
  local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"

  if [[ "$(dotfiles_theme_mode)" == "light" ]]; then
    print -r -- "${config_home}/lazygit/config-light.yml"
    return 0
  fi

  print -r -- "${config_home}/lazygit/config-dark.yml"
}

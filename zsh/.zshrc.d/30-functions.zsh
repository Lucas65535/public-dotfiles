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

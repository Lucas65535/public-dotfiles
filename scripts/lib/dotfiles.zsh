#!/usr/bin/env zsh

dotfiles_repo_root() {
  print -r -- "${${(%):-%x}:A:h:h:h}"
}

dotfiles_config_home() {
  print -r -- "${XDG_CONFIG_HOME:-$HOME/.config}"
}

dotfiles_info() {
  print -r -- "==> $*"
}

dotfiles_warn() {
  print -u2 -- "warning: $*"
}

dotfiles_require_command() {
  local name="$1"

  command -v "$name" >/dev/null 2>&1 || {
    print -u2 -- "missing required command: $name"
    return 1
  }
}

dotfiles_run() {
  dotfiles_info "$*"
  "$@"
}

dotfiles_link_path() {
  local src="$1"
  local dest="$2"
  local parent="${dest:h}"

  [[ -e "$src" ]] || {
    print -u2 "missing source: $src"
    return 1
  }

  mkdir -p "$parent"

  if [[ -L "$dest" ]]; then
    rm -- "$dest"
  elif [[ -d "$dest" ]]; then
    if [[ -z "$(command ls -A -- "$dest")" ]]; then
      rmdir -- "$dest"
    else
      print -u2 "refusing to replace non-empty directory: $dest"
      return 1
    fi
  elif [[ -e "$dest" ]]; then
    print -u2 "refusing to replace regular file: $dest"
    return 1
  fi

  ln -s "$src" "$dest"
  print -r -- "$dest -> $src"
}

dotfiles_install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  dotfiles_info "installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

dotfiles_brew_bundle() {
  local repo_root="$1"

  dotfiles_require_command brew
  dotfiles_run brew bundle --file="$repo_root/Brewfile"
}

dotfiles_dump_brewfile() {
  local repo_root="$1"

  dotfiles_require_command brew
  dotfiles_run brew bundle dump --force --file="$repo_root/Brewfile"
}

dotfiles_sync_oh_my_tmux() {
  local tmux_dir="$HOME/.local/share/tmux/oh-my-tmux"

  if [[ -d "$tmux_dir/.git" ]]; then
    dotfiles_run git -C "$tmux_dir" pull --ff-only
    return 0
  fi

  mkdir -p "${tmux_dir:h}"
  dotfiles_run git clone https://github.com/gpakosz/.tmux.git "$tmux_dir"
}

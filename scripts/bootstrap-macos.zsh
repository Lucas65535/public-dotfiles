#!/usr/bin/env zsh
set -euo pipefail

source "${0:A:h}/lib/dotfiles.zsh"

repo_root="$(dotfiles_repo_root)"

if [[ "$(uname -s)" != "Darwin" ]]; then
  print -u2 -- "bootstrap-macos.zsh only supports macOS"
  exit 1
fi

dotfiles_install_homebrew

dotfiles_info "installing Homebrew bundle"
dotfiles_brew_bundle "$repo_root"

dotfiles_info "syncing oh-my-tmux"
dotfiles_sync_oh_my_tmux

dotfiles_info "creating symlinks"
"$repo_root/scripts/relink.zsh"

dotfiles_info "bootstrap complete; restart your shell with: exec \$SHELL -l"

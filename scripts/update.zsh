#!/usr/bin/env zsh
set -euo pipefail

source "${0:A:h}/lib/dotfiles.zsh"

repo_root="$(dotfiles_repo_root)"

dotfiles_info "updating Brewfile from installed Homebrew packages"
dotfiles_dump_brewfile "$repo_root"

dotfiles_info "syncing oh-my-tmux"
dotfiles_sync_oh_my_tmux

dotfiles_info "refreshing symlinks"
"$repo_root/scripts/relink.zsh"

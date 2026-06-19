#!/usr/bin/env zsh
set -euo pipefail

source "${0:A:h}/lib/dotfiles.zsh"

repo_root="$(dotfiles_repo_root)"
config_home="$(dotfiles_config_home)"

link_path() {
  dotfiles_link_path "$@"
}

link_path "$repo_root/zsh/.zshrc" "$HOME/.zshrc"
link_path "$repo_root/starship/starship.toml" "$config_home/starship.toml"

for dir in nvim ghostty lazygit atuin bat btop lsd yazi k9s; do
  link_path "$repo_root/$dir" "$config_home/$dir"
done

link_path "$HOME/.local/share/tmux/oh-my-tmux/.tmux.conf" "$config_home/tmux/tmux.conf"
link_path "$repo_root/tmux/tmux.conf.local" "$config_home/tmux/tmux.conf.local"
link_path "$repo_root/tmux/sesh-browser.sh" "$config_home/tmux/sesh-browser.sh"

link_path "$repo_root/codex/themes" "$HOME/.codex/themes"

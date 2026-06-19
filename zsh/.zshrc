# Modular zsh entrypoint.
# This file is intended to be sourced by ~/.zshrc (or symlinked directly).

# Resolve this file's directory robustly.
_ZSHRC_DIR="${${(%):-%N}:A:h}"
export DOTFILES_HOME="${DOTFILES_HOME:-${_ZSHRC_DIR:h}}"

# Always load environment + history for shell consistency.
[[ -f "${_ZSHRC_DIR}/.zshrc.d/00-env.zsh" ]] && source "${_ZSHRC_DIR}/.zshrc.d/00-env.zsh"
[[ -f "${_ZSHRC_DIR}/.zshrc.d/10-history.zsh" ]] && source "${_ZSHRC_DIR}/.zshrc.d/10-history.zsh"

# Heavy logic only for interactive shells.
[[ $- != *i* ]] && return

# Load Kaku before local aliases so dotfiles aliases remain authoritative.
[[ ":$PATH:" != *":$HOME/.config/kaku/zsh/bin:"* ]] && export PATH="$HOME/.config/kaku/zsh/bin:$PATH" # Kaku PATH Integration
[[ -f "$HOME/.config/kaku/zsh/kaku.zsh" ]] && source "$HOME/.config/kaku/zsh/kaku.zsh" # Kaku Shell Integration

for _file in \
  "${_ZSHRC_DIR}/.zshrc.d/20-aliases.zsh" \
  "${_ZSHRC_DIR}/.zshrc.d/30-functions.zsh" \
  "${_ZSHRC_DIR}/.zshrc.d/40-completion.zsh" \
  "${_ZSHRC_DIR}/.zshrc.d/50-tools.zsh" \
  "${_ZSHRC_DIR}/.zshrc.d/99-local.zsh"
do
  [[ -f "${_file}" ]] && source "${_file}"
done

unset _ZSHRC_DIR _file

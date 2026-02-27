# Tool integrations (guarded for portability and startup resilience)

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
  export FZF_DEFAULT_OPTS="\
  --height=40% --layout=reverse --border=rounded --margin=0,1 \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a \
  --prompt='❯ ' --pointer='▶' --marker='✓' \
  --bind='ctrl-d:half-page-down,ctrl-u:half-page-up'"
fi

# zsh-autosuggestions / zsh-syntax-highlighting (Homebrew Intel/Apple Silicon)
for _plugin in \
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
do
  if [[ -f "$_plugin" ]]; then
    source "$_plugin"
    break
  fi
done

for _plugin in \
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
do
  if [[ -f "$_plugin" ]]; then
    source "$_plugin"
    break
  fi
done
unset _plugin

# Apply Catppuccin Mocha Theme (after syntax-highlighting)
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=#6c7086,italic'
ZSH_HIGHLIGHT_STYLES[pipeline]='fg=#89b4fa,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=#89b4fa'
ZSH_HIGHLIGHT_STYLES[keyword]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[string]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[bracket]='fg=#94e2d5'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[function]='fg=#89b4fa'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#cba6f7,italic'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#f5e0dc'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#f5e0dc'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#f5e0dc'
ZSH_HIGHLIGHT_STYLES[path]='fg=#f5e0dc,underline'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#f38ba8'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#f5e0dc'
ZSH_HIGHLIGHT_STYLES[path_prefix_separator]='fg=#f38ba8'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#f5e0dc'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#f5e0dc'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#f5e0dc'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#f5e0dc'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#f5e0dc'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#f5e0dc'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#f5e0dc'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#f5e0dc'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[root]='fg=#f38ba8,bold'
ZSH_HIGHLIGHT_STYLES[cursor]='bg=#f5e0dc'

[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

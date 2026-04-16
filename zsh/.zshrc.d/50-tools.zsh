# Tool integrations (guarded for portability and startup resilience)

_theme_mode="$(dotfiles_theme_mode)"

# ── FZF — Claude Code palette ──
if [[ "$_theme_mode" == "light" ]]; then
  export FZF_DEFAULT_OPTS="\
  --height=40% --layout=reverse --border=rounded --margin=0,1 \
  --color=bg+:#E8E6DB,bg:#FFFCF0,spinner:#6A5BCC,hl:#CC785C \
  --color=fg:#1A1917,header:#207FDE,info:#8A6220,pointer:#CC785C \
  --color=marker:#2E7C4C,fg+:#1A1917,prompt:#CC785C,hl+:#B85F3D \
  --color=selected-bg:#ECE9DF \
  --prompt='❯ ' --pointer='▶' --marker='✓' \
  --bind='ctrl-d:half-page-down,ctrl-u:half-page-up'"
else
  export FZF_DEFAULT_OPTS="\
  --height=40% --layout=reverse --border=rounded --margin=0,1 \
  --color=bg+:#2B2A27,bg:#141413,spinner:#9B87F5,hl:#D4967E \
  --color=fg:#EAE7DF,header:#61AAF2,info:#E8C96B,pointer:#D4967E \
  --color=marker:#9ACA86,fg+:#F5F2E9,prompt:#D4967E,hl+:#E0AB96 \
  --color=selected-bg:#332F29 \
  --prompt='❯ ' --pointer='▶' --marker='✓' \
  --bind='ctrl-d:half-page-down,ctrl-u:half-page-up'"
fi

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
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

# ── Theme — Claude Code palette ──
# Apply after syntax-highlighting so command validity remains readable
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES
if [[ "$_theme_mode" == "light" ]]; then
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8D877D"
  ZSH_HIGHLIGHT_STYLES[default]='fg=#1A1917'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#6B665F,italic'
  ZSH_HIGHLIGHT_STYLES[pipeline]='fg=#207FDE,bold'
  ZSH_HIGHLIGHT_STYLES[command]='fg=#207FDE,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#6A5BCC,bold'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#179299,bold'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#CC785C,bold'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#CC785C'
  ZSH_HIGHLIGHT_STYLES[keyword]='fg=#6A5BCC'
  ZSH_HIGHLIGHT_STYLES[string]='fg=#2D7F4D'
  ZSH_HIGHLIGHT_STYLES[bracket]='fg=#179299'
  ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#6B665F'
  ZSH_HIGHLIGHT_STYLES[redirection]='fg=#CC785C'
  ZSH_HIGHLIGHT_STYLES[arg0]='fg=#1A1917'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#2D7F4D,underline'
  ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#6A5BCC'
  ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#1A1917'
  ZSH_HIGHLIGHT_STYLES[path_prefix_separator]='fg=#6A5BCC'
  ZSH_HIGHLIGHT_STYLES[globbing]='fg=#6A5BCC'
  ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#6A5BCC'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#A84B3A'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#A84B3A'
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#1A1917'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#2D7F4D'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#2D7F4D'
  ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#1A1917'
  ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#2D7F4D'
  ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#1A1917'
  ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#1A1917'
  ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#1A1917'
  ZSH_HIGHLIGHT_STYLES[assign]='fg=#CC785C'
  ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#CC785C'
  ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#CC785C'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#A84B3A,bold'
  ZSH_HIGHLIGHT_STYLES[unknown-command]='fg=#A84B3A,bold'
  ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#6A5BCC'
  ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#6A5BCC'
  ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#6A5BCC'
  ZSH_HIGHLIGHT_STYLES[root]='fg=#A84B3A,bold'
  ZSH_HIGHLIGHT_STYLES[cursor]='bg=#E8E6DB'
else
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6B665F"
  ZSH_HIGHLIGHT_STYLES[default]='fg=#EAE7DF'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#6B665F,italic'
  ZSH_HIGHLIGHT_STYLES[pipeline]='fg=#A2D2FF,bold'
  ZSH_HIGHLIGHT_STYLES[command]='fg=#A2D2FF,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#C9BCFF,bold'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#94E2D5,bold'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#E0AB96,bold'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#E0AB96'
  ZSH_HIGHLIGHT_STYLES[keyword]='fg=#C9BCFF'
  ZSH_HIGHLIGHT_STYLES[string]='fg=#B6E0A5'
  ZSH_HIGHLIGHT_STYLES[bracket]='fg=#94E2D5'
  ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#D9D5CC'
  ZSH_HIGHLIGHT_STYLES[redirection]='fg=#E0AB96'
  ZSH_HIGHLIGHT_STYLES[arg0]='fg=#EAE7DF'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#B6E0A5,underline'
  ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#C9BCFF'
  ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#EAE7DF'
  ZSH_HIGHLIGHT_STYLES[path_prefix_separator]='fg=#C9BCFF'
  ZSH_HIGHLIGHT_STYLES[globbing]='fg=#C9BCFF'
  ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#C9BCFF'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#D4967E'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#D4967E'
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#EAE7DF'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#B6E0A5'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#B6E0A5'
  ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#EAE7DF'
  ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#B6E0A5'
  ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#EAE7DF'
  ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#EAE7DF'
  ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#EAE7DF'
  ZSH_HIGHLIGHT_STYLES[assign]='fg=#E0AB96'
  ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#E0AB96'
  ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#E0AB96'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#F09884,bold'
  ZSH_HIGHLIGHT_STYLES[unknown-command]='fg=#F09884,bold'
  ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#C9BCFF'
  ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#C9BCFF'
  ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#C9BCFF'
  ZSH_HIGHLIGHT_STYLES[root]='fg=#F09884,bold'
  ZSH_HIGHLIGHT_STYLES[cursor]='bg=#4A473F'
fi

[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
if command -v starship >/dev/null 2>&1; then
  export STARSHIP_CONFIG="${HOME}/.config/starship.toml"
  eval "$(starship init zsh)"
fi

unset _theme_mode

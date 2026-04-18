# Claude Code Theme — ZSH Configuration
# Source this file from .zshrc:  source ~/code/public-dotfiles/claude-theme/zsh/claude-theme.zsh
#
# Requires: zsh-syntax-highlighting, zsh-autosuggestions, fzf

# ── Dark / Light detection ──
# Override: export CLAUDE_THEME=light  (or dark)
# Auto-detect macOS appearance if unset
if [[ -z "$CLAUDE_THEME" ]]; then
  if [[ "$(uname)" == "Darwin" ]]; then
    if defaults read -g AppleInterfaceStyle &>/dev/null 2>&1; then
      CLAUDE_THEME="dark"
    else
      CLAUDE_THEME="light"
    fi
  else
    CLAUDE_THEME="dark"
  fi
fi

if [[ "$CLAUDE_THEME" == "light" ]]; then
  # ── Light Mode ──

  # zsh-autosuggestions
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8D877D"

  # zsh-syntax-highlighting
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[default]="fg=#1A1917"
  ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=#A84B3A,underline"
  ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=#B84A2A,bold"
  ZSH_HIGHLIGHT_STYLES[alias]="fg=#AE4E30"
  ZSH_HIGHLIGHT_STYLES[builtin]="fg=#AE4E30"
  ZSH_HIGHLIGHT_STYLES[function]="fg=#AE4E30"
  ZSH_HIGHLIGHT_STYLES[command]="fg=#2E7C4C"
  ZSH_HIGHLIGHT_STYLES[precommand]="fg=#2E7C4C,underline"
  ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=#6A645C"
  ZSH_HIGHLIGHT_STYLES[path]="fg=#1A1917,underline"
  ZSH_HIGHLIGHT_STYLES[path_pathseparator]="fg=#877C70"
  ZSH_HIGHLIGHT_STYLES[globbing]="fg=#6A5BCC"
  ZSH_HIGHLIGHT_STYLES[history-expansion]="fg=#6A5BCC"
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=#946A1E"
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=#946A1E"
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument]="fg=#6A5BCC"
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=#2D7F4D"
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=#2D7F4D"
  ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]="fg=#2D7F4D"
  ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="fg=#BD5341"
  ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]="fg=#BD5341"
  ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]="fg=#BD5341"
  ZSH_HIGHLIGHT_STYLES[assign]="fg=#1A1917"
  ZSH_HIGHLIGHT_STYLES[redirection]="fg=#CC785C,bold"
  ZSH_HIGHLIGHT_STYLES[comment]="fg=#8D877D,italic"
  ZSH_HIGHLIGHT_STYLES[arg0]="fg=#2E7C4C"

  # fzf
  export FZF_DEFAULT_OPTS="
    --color=bg:#FFFCF0,bg+:#E8E6DB,fg:#1A1917,fg+:#1A1917
    --color=hl:#CC785C,hl+:#B85F3D,info:#8A6220,marker:#2E7C4C
    --color=prompt:#CC785C,spinner:#6A5BCC,pointer:#CC785C,header:#386290
    --color=border:#D9D5CC,separator:#D9D5CC,scrollbar:#A9A39A
    --color=label:#6B665F,query:#1A1917
    --border=rounded --separator='─'
  "

else
  # ── Dark Mode ──

  # zsh-autosuggestions
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6B665F"

  # zsh-syntax-highlighting
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[default]="fg=#EAE7DF"
  ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=#D47563,underline"
  ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=#E2A48B,bold"
  ZSH_HIGHLIGHT_STYLES[alias]="fg=#FFC1A6"
  ZSH_HIGHLIGHT_STYLES[builtin]="fg=#FFC1A6"
  ZSH_HIGHLIGHT_STYLES[function]="fg=#FFC1A6"
  ZSH_HIGHLIGHT_STYLES[command]="fg=#9ACA86"
  ZSH_HIGHLIGHT_STYLES[precommand]="fg=#9ACA86,underline"
  ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=#E2D8CC"
  ZSH_HIGHLIGHT_STYLES[path]="fg=#EAE7DF,underline"
  ZSH_HIGHLIGHT_STYLES[path_pathseparator]="fg=#C6BDB2"
  ZSH_HIGHLIGHT_STYLES[globbing]="fg=#9B87F5"
  ZSH_HIGHLIGHT_STYLES[history-expansion]="fg=#9B87F5"
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=#F4DC90"
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=#F4DC90"
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument]="fg=#9B87F5"
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=#B5E6A0"
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=#B5E6A0"
  ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]="fg=#B5E6A0"
  ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="fg=#FFB19D"
  ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]="fg=#FFB19D"
  ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]="fg=#FFB19D"
  ZSH_HIGHLIGHT_STYLES[assign]="fg=#EAE7DF"
  ZSH_HIGHLIGHT_STYLES[redirection]="fg=#D4967E,bold"
  ZSH_HIGHLIGHT_STYLES[comment]="fg=#6B665F,italic"
  ZSH_HIGHLIGHT_STYLES[arg0]="fg=#9ACA86"

  # fzf
  export FZF_DEFAULT_OPTS="
    --color=bg:#141413,bg+:#2B2A27,fg:#EAE7DF,fg+:#F5F2E9
    --color=hl:#D4967E,hl+:#E0AB96,info:#E8C96B,marker:#9ACA86
    --color=prompt:#D4967E,spinner:#9B87F5,pointer:#D4967E,header:#61AAF2
    --color=border:#4A473F,separator:#4A473F,scrollbar:#6B665F
    --color=label:#A9A39A,query:#EAE7DF
    --border=rounded --separator='─'
  "

fi

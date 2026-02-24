
# aliases
alias ls="lsd"
alias la="lsd -AF"
alias ll="lsd -lhF"
alias lla="lsd -lahF"
alias lt='du -sh * | sort -h'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias j='jobs -l'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias g=git
alias vim=nvim
alias v=nvim
alias vv='nvim .'
alias gs="git status"
alias gl="git log --oneline --graph --decorate=full"
alias glc="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ad)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)' --all --decorate=full"
alias gd="git diff --color-words"
alias gad="git diff --staged --color-words"
alias gc="git commit -m"
alias gcamend="git commit --amend -m"
alias gcamendnoedit="git commit --amend --no-edit"
alias ga="git add ."
alias gp="git push"
alias startgit="cd \$(git rev-parse --show-toplevel) && git checkout main && git pull"
alias ya="yarn"
alias p="pnpm"
alias b="bun"
alias nn='/opt/homebrew/bin/n'
alias n='npm'
alias t="tmux -f ~/.config/tmux/tmux.conf"

alias '..'='cd ../'
alias '...'='cd ../../'
alias '....'='cd ../../../'
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"

# httpie
alias h='http'
alias hs='https'
# get web servers headers
alias header="curl -I"
alias xheader="xh -h"
# find out if remote server supports gzip / mod_deflate or not
alias headerc="curl -I --compressed"

# kubernetes
alias k="kubectl"

# multipass
alias m="multipass"

# Docker alias
alias d="docker"
dtags() {
  local image="${1}"
  curl -s -S "https://registry.hub.docker.com/v2/repositories/library/${image}/tags/" \
    | jq '."results"[]["name"]' \
    | sort
}
# Docker Images
alias di="docker images"
alias dirm="docker rmi"
# Get latest container ID
alias dl="docker ps -l -q"
# Get container process
alias dps="docker ps"
# Build docker image
alias dkb="docker buildx build --platform linux/amd64"

# Docker Containers
# Get process included stop container
alias dpsa="docker ps -a"
# Get container IP
alias dcip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
# Run deamonized container, e.g., $dkd base /bin/echo hello
alias dcd="docker container run -d -P"
# Run interactive container, e.g., $dki base /bin/bash
alias dci="docker container run -it -P"
# Execute interactive container, e.g., $dex base /bin/bash
alias dcke="docker exec -it"

# ==========================
alias tf=terraform
alias cdcode="cd $HOME/code"
alias cdwork="cd $HOME/workspace"
alias code="code ."
alias kiro="kiro ."
alias agy="agy ."
alias open="open ."

alias reload='exec $SHELL -l'
alias connections='lsof -PiTCP -n'
alias conns-nali='lsof -PiTCP -n | nali'
alias conns-estab-nali='lsof -PiTCP -n -sTCP:ESTABLISHED | nali'
alias my='curl ifconfig.io'

# path of bun and local bin
export PATH="$HOME/.bun/bin:$HOME/.local/bin:$PATH"

# path of node version management (n which lts)
export PATH="/usr/local/bin:$PATH"
# ── auto completion ──────────────────────────────────────────────────────────
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

# ── fzf ──────────────────────────────────────────────────────────────────────
eval "$(fzf --zsh)"
export FZF_DEFAULT_OPTS="\
  --height=40% --layout=reverse --border=rounded --margin=0,1 \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a \
  --prompt='❯ ' --pointer='▶' --marker='✓' \
  --bind='ctrl-d:half-page-down,ctrl-u:half-page-up'"
# Optimize Homebrew plugin loading by avoiding $(brew --prefix) call
if [[ -d /opt/homebrew ]]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    # Fallback to default or Intel path
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Apply Catppuccin Mocha Theme (after sourcing)
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
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f9e2af' # Changed to Yellow for testing
ZSH_HIGHLIGHT_STYLES[root]='fg=#f38ba8,bold'
ZSH_HIGHLIGHT_STYLES[cursor]='bg=#f5e0dc'

# [ -f ~/.inshellisense/key-bindings.zsh ] && source ~/.inshellisense/key-bindings.zsh
# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

eval "$(atuin init zsh)"

# ── zoxide (smart cd) ────────────────────────────────────────────────────────
eval "$(zoxide init zsh)"

# ── yazi (file manager) ─────────────────────────────────────────────────────
# Wrapper: quit yazi and cd to the directory you navigated to
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(starship init zsh)"
source <(kubectl completion zsh)


# Azure Subscription Switcher
azswitch() {
    # Get subscription list: Name (tab) ID (tab) IsDefault
    # Use column to format it nicely for fzf
    local sub_info=$(az account list --query "[].{name:name, id:id, isDefault:isDefault}" -o tsv | column -t -s $'\t' | fzf --header "Select Azure Subscription" --query "$1")
    
    if [[ -n "$sub_info" ]]; then
        # ID is the second to last column. 
        # We use awk to extract it safely (ID itself has no spaces).
        local sub_id=$(echo "$sub_info" | awk '{print $(NF-1)}') 
        
        if [[ -n "$sub_id" ]]; then
            az account set --subscription "$sub_id"
            echo "Switched to: $(az account show --query name -o tsv)"
        fi
    fi
}


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# Aliases (interactive only)

if command -v lsd >/dev/null 2>&1; then
  alias ls="lsd"
  alias la="lsd -AF"
  alias ll="lsd -lhF"
  alias lla="lsd -lahF"
fi

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
alias gs='git status'
alias gl='git log --oneline --graph --decorate=full'
alias glc="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ad)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)' --all --decorate=full"
alias gd='git diff --color-words'
alias gad='git diff --staged --color-words'
alias gc='git commit -m'
alias gcamend='git commit --amend -m'
alias gcamendnoedit='git commit --amend --no-edit'
alias ga='git add .'
alias gp='git push'

alias ya='yarn'
alias p='pnpm'
alias b='bun'
alias nn='/opt/homebrew/bin/n'
alias n='npm'
alias t='tmux -f ~/.config/tmux/tmux.conf'
alias cx='codex'
alias cc='claude'
alias co='opencode'

alias '..'='cd ../'
alias '...'='cd ../../'
alias '....'='cd ../../../'
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'

# httpie
alias h='http'
alias hs='https'
alias header='curl -I'
alias xheader='xh -h'
alias headerc='curl -I --compressed'

# kubernetes / infra
alias k='kubectl'
alias m='multipass'
alias d='docker'
alias di='docker images'
alias dirm='docker rmi'
alias dl='docker ps -l -q'
alias dps='docker ps'
alias dkb='docker buildx build --platform linux/amd64'
alias dpsa='docker ps -a'
alias dcip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias dcd='docker container run -d -P'
alias dci='docker container run -it -P'
alias dcke='docker exec -it'
alias tf='terraform'

alias cdcode='cd "$HOME/code"'
alias cdwork='cd "$HOME/workspace"'

# Keep original commands intact; use explicit "dot" helpers for cwd-open behaviors.
alias c.='code .'
alias k.='kiro .'
alias a.='agy .'
alias o.='open .'

alias reload='exec "$SHELL" -l'
alias connections='lsof -PiTCP -n'
alias conns-nali='lsof -PiTCP -n | nali'
alias conns-estab-nali='lsof -PiTCP -n -sTCP:ESTABLISHED | nali'
alias my='curl ifconfig.io'

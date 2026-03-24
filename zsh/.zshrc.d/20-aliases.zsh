# Aliases (interactive only)

if command -v lsd >/dev/null 2>&1; then
  alias ls="lsd"
  alias la="lsd -AF"
  alias ll="lsd -lhF"
  alias lla="lsd -lahF"
fi

alias lt='du -sh * | sort -h'
alias grep='grep --color=auto'
alias egrep='grep -E --color=auto'
alias fgrep='grep -F --color=auto'
alias j='jobs -l'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias lg='lazygit'
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

alias p='pnpm'
alias b='bun'
alias nn='/opt/homebrew/bin/n'
alias n='npm'
alias t='tmux -f ~/.config/tmux/tmux.conf'
alias cx='codex'
alias cc='claude'
alias oc='opencode'
alias og='gemini'

alias '..'='cd ../'
alias '...'='cd ../../'
alias '....'='cd ../../../'
my() { curl -fsS ifconfig.io; echo; }

# httpie
alias h='http'
alias hs='https'
alias header='curl -I'
alias xheader='xh -h'
alias headerc='curl -I --compressed'

# kubernetes / infra
# alias k='kubectl'
alias k='kubecolor'
alias m='multipass'
alias d='docker'
alias di='docker images'
drmi() {
  if [[ -t 0 ]]; then
    print -n "docker rmi $* (y/N) "
    read -r reply
    [[ "$reply" == "y" || "$reply" == "Y" ]] || return 1
  fi
  docker rmi "$@"
}
alias dpslast='docker ps -l -q'
alias dl='dpslast'
alias dps='docker ps'
alias dkb='docker buildx build --platform linux/amd64'
alias dpsa='docker ps -a'
alias dcip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias dcd='docker container run -d -P'
alias dci='docker container run -it -P'
alias dcke='docker exec -it'

# kubernetes helpers
alias kpods='k get pods'
alias kpodsall='k get pods -A'
kpodsns() { k get pods -n "$1" -owide; }

alias knodes='k get nodes'
alias klogs='k logs'
alias kcfg='k config view'
alias kctx='k config get-contexts'
alias kcx='kubectx'
alias kns='kubens'

alias kpoddesc='k describe pod'
kpoddescns() { k describe pod -n "$1" "$2"; }

# gitlab-runner helpers
alias krunnerpods='k get pods -n gitlab-runner -owide'
alias krunnerwatch='k get pods -n gitlab-runner -w'
alias krunnerpodscount='k get pods -n gitlab-runner --no-headers | wc -l'
alias krunnernodescount='k get nodes --no-headers | grep "runner" | wc -l'
alias krunnernodescountby='k get pods -n gitlab-runner -o custom-columns="NODE:.spec.nodeName" --no-headers | sort | uniq -c'
alias knodescountby='k get pods -A -o custom-columns="NODE:.spec.nodeName" --no-headers | sort | uniq -c'

# grafana (no public IP, local access)
kgrafana() { k port-forward -n monitoring svc/prometheus-grafana 3000:80; }
kgrafanabg() { k port-forward -n monitoring svc/prometheus-grafana 3000:80 >/dev/null 2>&1 & }
kgrafanapass() { k get secret prometheus-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 -d; echo; }
kgrafanastop() { pkill -f "kubecolor port-forward -n monitoring svc/prometheus-grafana 3000:80" || pkill -f "kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80"; }

alias gpull='g pull'
gnew() { g checkout -b "$1"; }
gdefault() {
  local remote branch remote_head

  if ! g rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "gdefault: not in a git repository" >&2
    return 1
  fi

  remote="${1:-origin}"
  if ! g config --get "remote.${remote}.url" >/dev/null 2>&1; then
    remote="$(g remote | head -n 1)"
  fi

  if [[ -n "$remote" ]]; then
    # Ask the remote first so the result follows the actual default branch.
    remote_head="$(g ls-remote --symref "$remote" HEAD 2>/dev/null | awk '/^ref:/ && $3 == "HEAD" {sub("refs/heads/", "", $2); print $2; exit}')"
    if [[ -n "$remote_head" ]]; then
      branch="$remote_head"
    else
      branch="$(g symbolic-ref --quiet --short "refs/remotes/${remote}/HEAD" 2>/dev/null)"
      branch="${branch#${remote}/}"
    fi
  fi

  if [[ -z "$branch" ]]; then
    echo "gdefault: unable to determine default branch from remote HEAD" >&2
    return 1
  fi

  g checkout "$branch"
}
alias gmaster='gdefault'
alias gshow='g show'
greset() { g reset "HEAD~${1:-1}"; }

alias brewup='brew update && brew upgrade && brew cleanup -v --prune=all'

alias cdcode='cd "$HOME/code"'
alias cdwork='cd "$HOME/workspace"'

# Keep original commands intact; use explicit "dot" helpers for cwd-open behaviors.
alias c.='code .'
alias k.='kiro .'
alias a.='agy .'
alias o.='open .'

alias reload='exec "$SHELL" -l'
alias connections='lsof -PiTCP -n'
if command -v nali >/dev/null 2>&1; then
  alias conns-nali='lsof -PiTCP -n | nali'
  alias conns-estab-nali='lsof -PiTCP -n -sTCP:ESTABLISHED | nali'
fi

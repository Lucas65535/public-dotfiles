#!/usr/bin/env bash

set -uo pipefail

SELF_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/$(basename -- "${BASH_SOURCE[0]}")"
FZF_COLOR_OPTS='--color=bg:#F5F3EB,fg:#1A1917,hl:#CC785C,fg+:#1A1917,bg+:#E8E6DB,hl+:#B85F3D,border:#D9D5CC,header:#207FDE,prompt:#CC785C,pointer:#CC785C,marker:#2E7C4C,spinner:#6A5BCC,info:#6B665F,label:#CC785C'
ROW_SEP=$'\x1f'

sanitize_text() {
  local text="${1//$'\t'/ }"

  text="${text//$'\r'/ }"
  text="${text//$'\n'/ }"

  printf '%s' "$text"
}

short_path() {
  local path="${1/#$HOME/\~}"
  local -a parts
  local start=0
  local tail

  IFS='/' read -r -a parts <<<"$path"

  if (( ${#parts[@]} <= 4 )); then
    printf '%s' "$path"
    return
  fi

  if [[ "${parts[0]}" == "~" ]]; then
    start=1
  fi

  tail="${parts[${#parts[@]}-3]}/${parts[${#parts[@]}-2]}/${parts[${#parts[@]}-1]}"

  if (( start == 1 )); then
    printf '~/.../%s' "$tail"
  else
    printf '.../%s' "$tail"
  fi
}

format_title() {
  local title="$1"
  local cmd="$2"

  [[ -z "$title" || "$title" == "$cmd" ]] && return 0
  printf '  {%s}' "$title"
}

icon_for() {
  local kind="$1"
  local cmd="${2,,}"
  local path="${3,,}"
  local name="${4,,}"

  case "$cmd" in
    nvim|vim|vi) printf '' ; return 0 ;;
    zsh|bash|fish|sh|tmux) printf '' ; return 0 ;;
    git|lazygit) printf '' ; return 0 ;;
    node|nodejs|npm|pnpm|yarn|bun|deno) printf '󰎙' ; return 0 ;;
    python|python3|ipython) printf '' ; return 0 ;;
    ruby|irb) printf '' ; return 0 ;;
    go) printf '' ; return 0 ;;
    cargo|rustc) printf '' ; return 0 ;;
    docker|docker-compose) printf '' ; return 0 ;;
    ssh) printf '󰣀' ; return 0 ;;
    yazi|lf|nnn) printf '' ; return 0 ;;
    htop|btop) printf '' ; return 0 ;;
  esac

  case "$path:$name" in
    *wiki*|*docs*|*knowledge*|*obsidian*) printf '󰈙' ; return 0 ;;
    *config*|*dotfiles*) printf '' ; return 0 ;;
    *code*|*dev*|*repo*|*project*) printf '󰲋' ; return 0 ;;
  esac

  case "$kind" in
    session) printf '󱂬' ;;
    window) printf '󰖲' ;;
    pane) printf '󰆍' ;;
    *) printf '•' ;;
  esac
}

source_sessions() {
  local -a rows=()
  local max_icon=0
  local max_name=0
  local max_cmd=0
  local max_path=0
  local max_status=0

  while IFS=$'\t' read -r name windows attached path cmd; do
    local attached_flag=""
    local display_path
    local icon
    local status

    name="$(sanitize_text "$name")"
    cmd="$(sanitize_text "$cmd")"
    path="$(sanitize_text "$path")"
    [[ "$attached" != "0" ]] && attached_flag='[attached]'
    display_path="$(short_path "$path")"
    icon="$(icon_for session "$cmd" "$path" "$name")"
    status="[$windows w]${attached_flag:+ $attached_flag}"

    (( ${#icon} > max_icon )) && max_icon=${#icon}
    (( ${#name} > max_name )) && max_name=${#name}
    (( ${#cmd} > max_cmd )) && max_cmd=${#cmd}
    (( ${#display_path} > max_path )) && max_path=${#display_path}
    (( ${#status} > max_status )) && max_status=${#status}

    rows+=("$icon${ROW_SEP}$name${ROW_SEP}$cmd${ROW_SEP}$display_path${ROW_SEP}$windows${ROW_SEP}$attached_flag")
  done < <(tmux list-sessions -F '#{session_name}	#{session_windows}	#{session_attached}	#{session_path}	#{pane_current_command}')

  for row in "${rows[@]}"; do
    local icon name cmd display_path windows attached_flag status

    IFS="$ROW_SEP" read -r icon name cmd display_path windows attached_flag <<<"$row"
    status="[$windows w]${attached_flag:+ $attached_flag}"

    printf 'session\t%-*s  %-*s  %-*s  %-*s  %-*s\t%s\n' \
      "$max_icon" "$icon" \
      "$max_name" "$name" \
      "$max_cmd" "$cmd" \
      "$max_path" "$display_path" \
      "$max_status" "$status" \
      "$name"
  done
}

source_windows() {
  local -a rows=()
  local max_icon=0
  local max_label=0
  local max_name=0
  local max_path=0
  local max_status=0

  while IFS=$'\t' read -r session index name panes active last cmd path title; do
    local flags=""
    local display_path
    local icon
    local label
    local status

    session="$(sanitize_text "$session")"
    name="$(sanitize_text "$name")"
    cmd="$(sanitize_text "$cmd")"
    path="$(sanitize_text "$path")"
    title="$(sanitize_text "$title")"
    [[ "$active" == "1" ]] && flags+='active'
    [[ "$last" == "1" ]] && flags+="${flags:+,}last"
    display_path="$(short_path "$path")"
    label="$session:$index"
    icon="$(icon_for window "$cmd" "$path" "$name")"

    (( ${#icon} > max_icon )) && max_icon=${#icon}
    (( ${#label} > max_label )) && max_label=${#label}
    (( ${#name} > max_name )) && max_name=${#name}
    (( ${#display_path} > max_path )) && max_path=${#display_path}
    status="[$panes p]${flags:+ [$flags]}"
    (( ${#status} > max_status )) && max_status=${#status}

    rows+=("$icon${ROW_SEP}$label${ROW_SEP}$name${ROW_SEP}$display_path${ROW_SEP}$panes${ROW_SEP}$flags${ROW_SEP}$title${ROW_SEP}$session${ROW_SEP}$index")
  done < <(tmux list-windows -a -F '#{session_name}	#{window_index}	#{window_name}	#{window_panes}	#{window_active}	#{window_last_flag}	#{pane_current_command}	#{pane_current_path}	#{pane_title}')

  for row in "${rows[@]}"; do
    local icon label name display_path panes flags title session index status

    IFS="$ROW_SEP" read -r icon label name display_path panes flags title session index <<<"$row"
    status="[$panes p]${flags:+ [$flags]}"

    printf 'window\t%-*s  %-*s  %-*s  %-*s  %-*s%s\t%s\t%s\n' \
      "$max_icon" "$icon" \
      "$max_label" "$label" \
      "$max_name" "$name" \
      "$max_path" "$display_path" \
      "$max_status" "$status" \
      "$(format_title "$title" "")" \
      "$session" "$index"
  done
}

source_panes() {
  local -a rows=()
  local max_icon=0
  local max_label=0
  local max_cmd=0
  local max_path=0
  local max_status=0

  while IFS=$'\t' read -r session window pane name cmd path active dead pane_id title; do
    local flags=""
    local display_path
    local icon
    local label

    session="$(sanitize_text "$session")"
    name="$(sanitize_text "$name")"
    cmd="$(sanitize_text "$cmd")"
    path="$(sanitize_text "$path")"
    title="$(sanitize_text "$title")"
    [[ "$active" == "1" ]] && flags+='[active]'
    [[ "$dead" == "1" ]] && flags+="${flags:+ }[dead]"
    display_path="$(short_path "$path")"
    label="$session:$window.$pane"
    icon="$(icon_for pane "$cmd" "$path" "$name")"

    (( ${#icon} > max_icon )) && max_icon=${#icon}
    (( ${#label} > max_label )) && max_label=${#label}
    (( ${#cmd} > max_cmd )) && max_cmd=${#cmd}
    (( ${#display_path} > max_path )) && max_path=${#display_path}
    (( ${#flags} > max_status )) && max_status=${#flags}

    rows+=("$icon${ROW_SEP}$label${ROW_SEP}$cmd${ROW_SEP}$display_path${ROW_SEP}$flags${ROW_SEP}$title${ROW_SEP}$session${ROW_SEP}$pane_id")
  done < <(tmux list-panes -a -F '#{session_name}	#{window_index}	#{pane_index}	#{window_name}	#{pane_current_command}	#{pane_current_path}	#{pane_active}	#{pane_dead}	#{pane_id}	#{pane_title}')

  for row in "${rows[@]}"; do
    local icon label cmd display_path flags title session pane_id

    IFS="$ROW_SEP" read -r icon label cmd display_path flags title session pane_id <<<"$row"

    printf 'pane\t%-*s  %-*s  %-*s  %-*s  %-*s%s\t%s\t%s\n' \
      "$max_icon" "$icon" \
      "$max_label" "$label" \
      "$max_cmd" "$cmd" \
      "$max_path" "$display_path" \
      "$max_status" "$flags" \
      "$(format_title "$title" "$cmd")" \
      "$session" "$pane_id"
  done
}

preview_session() {
  sesh preview "$1"
}

clean_preview() {
  perl -CS -ne '
    my $plain = $_;
    $plain =~ s/\r//g;
    $plain =~ s/\e\[[0-9;?]*[ -\/]*[@-~]//g;
    $plain =~ s/\e\][^\a]*(?:\a|\e\\)//g;
    next if $plain =~ /^\s*❯\s*$/;
    print $_;
  '
}

capture_target() {
  local target="$1"
  local alternate_on

  alternate_on="$(tmux display-message -p -t "$target" '#{alternate_on}' 2>/dev/null || printf '0')"

  if [[ "$alternate_on" == "1" ]]; then
    tmux capture-pane -aepJ -S -200 -E - -t "$target" | clean_preview
  else
    tmux capture-pane -epJ -S -200 -E - -t "$target" | clean_preview
  fi
}

preview_window() {
  capture_target "$1:$2"
}

preview_pane() {
  capture_target "$1"
}

open_session() {
  sesh connect "$1"
}

open_window() {
  tmux switch-client -t "$1:$2"
}

open_pane() {
  tmux switch-client -t "$1"
  tmux select-pane -t "$2"
}

mode_prompt() {
  case "$1" in
    sessions) printf 'sesh> ' ;;
    windows) printf 'win> ' ;;
    panes) printf 'pane> ' ;;
  esac
}

mode_header() {
  case "$1" in
    sessions) printf ' enter connect  ctrl-p panes  ctrl-w windows  ctrl-s sessions ' ;;
    windows) printf ' enter switch window  ctrl-p panes  ctrl-w windows  ctrl-s sessions ' ;;
    panes) printf ' enter switch pane  ctrl-p panes  ctrl-w windows  ctrl-s sessions ' ;;
  esac
}

mode_preview() {
  case "$1" in
    sessions) printf "%s preview session {3}" "$SELF_PATH" ;;
    windows) printf "%s preview window {3} {4}" "$SELF_PATH" ;;
    panes) printf "%s preview pane {4}" "$SELF_PATH" ;;
  esac
}

browse() {
  local initial_mode="${1:-panes}"
  local selection

  selection="$(
    FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:-} ${FZF_COLOR_OPTS}" \
      "$SELF_PATH" source "$initial_mode" |
      fzf \
        --ansi \
        --border=rounded \
        --delimiter=$'\t' \
        --layout=reverse \
        --height=100% \
        --prompt "$(mode_prompt "$initial_mode")" \
        --header "$(mode_header "$initial_mode")" \
        --with-nth=2 \
        --preview "$(mode_preview "$initial_mode")" \
        --preview-wrap-sign '' \
        --preview-window 'right:55%,border-left,wrap' \
        --bind "esc:abort" \
        --bind "ctrl-s:change-prompt($(mode_prompt sessions))+change-header($(mode_header sessions))+change-preview($(mode_preview sessions))+reload($SELF_PATH source sessions)" \
        --bind "ctrl-w:change-prompt($(mode_prompt windows))+change-header($(mode_header windows))+change-preview($(mode_preview windows))+reload($SELF_PATH source windows)" \
        --bind "ctrl-p:change-prompt($(mode_prompt panes))+change-header($(mode_header panes))+change-preview($(mode_preview panes))+reload($SELF_PATH source panes)"
  )"

  [[ -z "${selection}" ]] && return 0

  IFS=$'\t' read -r kind display arg1 arg2 arg3 _rest <<<"$selection"

  case "$kind" in
    session) open_session "$arg1" ;;
    window) open_window "$arg1" "$arg2" ;;
    pane) open_pane "$arg1" "$arg2" ;;
    *) return 1 ;;
  esac
}

case "${1:-browse}" in
  browse)
    shift || true
    browse "${1:-panes}"
    ;;
  source)
    case "${2:-}" in
      sessions) source_sessions ;;
      windows) source_windows ;;
      panes) source_panes ;;
      *) exit 1 ;;
    esac
    ;;
  preview)
    case "${2:-}" in
      session) shift 2; preview_session "$*" ;;
      window) preview_window "${3:-}" "${4:-}" ;;
      pane) preview_pane "${3:-}" ;;
      *) exit 1 ;;
    esac
    ;;
  *)
    exit 1
    ;;
esac

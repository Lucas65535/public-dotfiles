#!/usr/bin/env bash

set -uo pipefail

SELF_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/$(basename -- "${BASH_SOURCE[0]}")"
FZF_COLOR_OPTS='--color=bg:#F5F3EB,fg:#1A1917,hl:#CC785C,fg+:#1A1917,bg+:#E8E6DB,hl+:#B85F3D,border:#D9D5CC,header:#207FDE,prompt:#CC785C,pointer:#CC785C,marker:#2E7C4C,spinner:#6A5BCC,info:#6B665F,label:#CC785C'

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

source_sessions() {
  tmux list-sessions -F '#{session_name}	#{session_windows}	#{session_attached}	#{session_path}	#{pane_current_command}' |
    while IFS=$'\t' read -r name windows attached path cmd; do
      local attached_flag=""
      local display_path

      [[ "$attached" != "0" ]] && attached_flag='  [attached]'
      display_path="$(short_path "$path")"

      printf 'session\t%s  [%sw]%s  %s  %s\t%s\n' \
        "$name" "$windows" "$attached_flag" "$cmd" "$display_path" "$name"
    done
}

source_windows() {
  tmux list-windows -a -F '#{session_name}	#{window_index}	#{window_name}	#{window_panes}	#{window_active}	#{window_last_flag}	#{pane_current_command}	#{pane_current_path}	#{pane_title}' |
    while IFS=$'\t' read -r session index name panes active last cmd path title; do
      local flags=""
      local display_path

      [[ "$active" == "1" ]] && flags+=' [active]'
      [[ "$last" == "1" ]] && flags+=' [last]'
      display_path="$(short_path "$path")"

      printf 'window\t%s:%s  %s  [%s panes]%s  %s  %s%s\t%s\t%s\n' \
        "$session" "$index" "$name" "$panes" "$flags" "$cmd" "$display_path" "$(format_title "$title" "$cmd")" "$session" "$index"
    done
}

source_panes() {
  tmux list-panes -a -F '#{session_name}	#{window_index}	#{pane_index}	#{window_name}	#{pane_current_command}	#{pane_current_path}	#{pane_title}	#{pane_width}x#{pane_height}	#{pane_active}	#{pane_dead}	#{pane_id}' |
    while IFS=$'\t' read -r session window pane name cmd path title size active dead pane_id; do
      local flags=""
      local display_path

      [[ "$active" == "1" ]] && flags+=' [active]'
      [[ "$dead" == "1" ]] && flags+=' [dead]'
      display_path="$(short_path "$path")"

      printf 'pane\t%s:%s.%s  %s  %s%s  %s%s\t%s\t%s\t%s\n' \
        "$session" "$window" "$pane" "$name" "$cmd" "$flags" "$display_path" "$(format_title "$title" "$cmd")" "$session" "$window" "$pane_id"
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
  tmux switch-client -t "$1:$2"
  tmux select-pane -t "$3"
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
    panes) printf "%s preview pane {5}" "$SELF_PATH" ;;
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
    pane) open_pane "$arg1" "$arg2" "$arg3" ;;
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

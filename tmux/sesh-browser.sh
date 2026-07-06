#!/usr/bin/env bash

set -uo pipefail

SELF_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/$(basename -- "${BASH_SOURCE[0]}")"
FZF_COLOR_OPTS='--color=bg:#141413,fg:#EAE7DF,hl:#D4967E,fg+:#F5F2E9,bg+:#2B2A27,hl+:#E0AB96,border:#4A473F,header:#61AAF2,prompt:#D4967E,pointer:#D4967E,marker:#9ACA86,spinner:#9B87F5,info:#A9A39A,label:#D4967E,gutter:#141413,preview-bg:#141413,preview-fg:#EAE7DF'
ROW_SEP=$'\x1f'
LABEL_WIDTH=28
COMMAND_WIDTH=10
PATH_WIDTH=14
STATUS_WIDTH=18

sanitize_text() {
  local text="${1//$'\t'/ }"

  text="${text//$'\r'/ }"
  text="${text//$'\n'/ }"

  printf '%s' "$text"
}

strip_ansi() {
  perl -CS -pe 's/\e\[[0-9;?]*[ -\/]*[@-~]//g; s/\e\][^\a]*(?:\a|\e\\)//g'
}

fit_field() {
  local text="$1"
  local width="$2"

  if ((${#text} > width)); then
    printf '%s~' "${text:0:width-1}"
  else
    printf '%s' "$text"
  fi
}

sesh_tmux_target() {
  local line="$1"
  local plain

  plain="$(printf '%s' "$line" | strip_ansi)"
  set -- $plain
  shift || true
  printf '%s' "$*"
}

current_dir_name() {
  local path="$1"

  path="${path%/}"

  if [[ -z "$path" || "$path" == "$HOME" ]]; then
    printf '~'
    return
  fi

  printf '%s' "${path##*/}"
}

short_path() {
  local path="${1/#$HOME/\~}"
  local -a parts
  local start=0
  local tail

  IFS='/' read -r -a parts <<<"$path"

  if ((${#parts[@]} <= 4)); then
    printf '%s' "$path"
    return
  fi

  if [[ "${parts[0]}" == "~" ]]; then
    start=1
  fi

  tail="${parts[${#parts[@]}-3]}/${parts[${#parts[@]}-2]}/${parts[${#parts[@]}-1]}"

  if ((start == 1)); then
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
  nvim | vim | vi)
    printf ''
    return 0
    ;;
  zsh | bash | fish | sh | tmux)
    printf ''
    return 0
    ;;
  git | lazygit)
    printf ''
    return 0
    ;;
  node | nodejs | npm | pnpm | yarn | bun | deno)
    printf '󰎙'
    return 0
    ;;
  python | python3 | ipython)
    printf ''
    return 0
    ;;
  ruby | irb)
    printf ''
    return 0
    ;;
  go)
    printf ''
    return 0
    ;;
  cargo | rustc)
    printf ''
    return 0
    ;;
  docker | docker-compose)
    printf ''
    return 0
    ;;
  ssh)
    printf '󰣀'
    return 0
    ;;
  yazi | lf | nnn)
    printf ''
    return 0
    ;;
  htop | btop)
    printf ''
    return 0
    ;;
  esac

  case "$path:$name" in
  *wiki* | *docs* | *knowledge* | *obsidian*)
    printf '󰈙'
    return 0
    ;;
  *config* | *dotfiles*)
    printf ''
    return 0
    ;;
  *code* | *dev* | *repo* | *project*)
    printf '󰲋'
    return 0
    ;;
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
    display_path="$(current_dir_name "$path")"
    icon="$(icon_for session "$cmd" "$path" "$name")"
    status="[$windows w]${attached_flag:+ $attached_flag}"

    ((${#icon} > max_icon)) && max_icon=${#icon}
    ((${#name} > max_name)) && max_name=${#name}
    ((${#cmd} > max_cmd)) && max_cmd=${#cmd}
    ((${#display_path} > max_path)) && max_path=${#display_path}
    ((${#status} > max_status)) && max_status=${#status}

    rows+=("$icon${ROW_SEP}$name${ROW_SEP}$cmd${ROW_SEP}$display_path${ROW_SEP}$windows${ROW_SEP}$attached_flag")
  done < <(tmux list-sessions -F '#{session_name}	#{session_windows}	#{session_attached}	#{session_path}	#{pane_current_command}')

  for row in "${rows[@]}"; do
    local icon name cmd display_path windows attached_flag status

    IFS="$ROW_SEP" read -r icon name cmd display_path windows attached_flag <<<"$row"
    status="[$windows w]${attached_flag:+ $attached_flag}"

    printf 'session\t%-2s %-*s  %-*s  %-*s  %-*s\t%s\n' \
      "$icon" \
      "$LABEL_WIDTH" "$(fit_field "$name" "$LABEL_WIDTH")" \
      "$COMMAND_WIDTH" "$(fit_field "$cmd" "$COMMAND_WIDTH")" \
      "$PATH_WIDTH" "$(fit_field "$display_path" "$PATH_WIDTH")" \
      "$STATUS_WIDTH" "$(fit_field "$status" "$STATUS_WIDTH")" \
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
    display_path="$(current_dir_name "$path")"
    label="$session:$index"
    icon="$(icon_for window "$cmd" "$path" "$name")"

    ((${#icon} > max_icon)) && max_icon=${#icon}
    ((${#label} > max_label)) && max_label=${#label}
    ((${#name} > max_name)) && max_name=${#name}
    ((${#display_path} > max_path)) && max_path=${#display_path}
    status="[$panes p]${flags:+ [$flags]}"
    ((${#status} > max_status)) && max_status=${#status}

    rows+=("$icon${ROW_SEP}$label${ROW_SEP}$name${ROW_SEP}$display_path${ROW_SEP}$panes${ROW_SEP}$flags${ROW_SEP}$title${ROW_SEP}$session${ROW_SEP}$index")
  done < <(tmux list-windows -a -F '#{session_name}	#{window_index}	#{window_name}	#{window_panes}	#{window_active}	#{window_last_flag}	#{pane_current_command}	#{pane_current_path}	#{pane_title}')

  for row in "${rows[@]}"; do
    local icon label name display_path panes flags title session index status

    IFS="$ROW_SEP" read -r icon label name display_path panes flags title session index <<<"$row"
    status="[$panes p]${flags:+ [$flags]}"

    printf 'window\t%-2s %-*s  %-*s  %-*s  %-*s%s\t%s\t%s\n' \
      "$icon" \
      "$LABEL_WIDTH" "$(fit_field "$label" "$LABEL_WIDTH")" \
      "$COMMAND_WIDTH" "$(fit_field "$name" "$COMMAND_WIDTH")" \
      "$PATH_WIDTH" "$(fit_field "$display_path" "$PATH_WIDTH")" \
      "$STATUS_WIDTH" "$(fit_field "$status" "$STATUS_WIDTH")" \
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
    display_path="$(current_dir_name "$path")"
    label="$session:$window.$pane"
    icon="$(icon_for pane "$cmd" "$path" "$name")"

    ((${#icon} > max_icon)) && max_icon=${#icon}
    ((${#label} > max_label)) && max_label=${#label}
    ((${#cmd} > max_cmd)) && max_cmd=${#cmd}
    ((${#display_path} > max_path)) && max_path=${#display_path}
    ((${#flags} > max_status)) && max_status=${#flags}

    rows+=("$icon${ROW_SEP}$label${ROW_SEP}$cmd${ROW_SEP}$display_path${ROW_SEP}$flags${ROW_SEP}$title${ROW_SEP}$session${ROW_SEP}$pane_id")
  done < <(tmux list-panes -a -F '#{session_name}	#{window_index}	#{pane_index}	#{window_name}	#{pane_current_command}	#{pane_current_path}	#{pane_active}	#{pane_dead}	#{pane_id}	#{pane_title}')

  for row in "${rows[@]}"; do
    local icon label cmd display_path flags title session pane_id

    IFS="$ROW_SEP" read -r icon label cmd display_path flags title session pane_id <<<"$row"

    printf 'pane\t%-2s %-*s  %-*s  %-*s  %-*s%s\t%s\t%s\n' \
      "$icon" \
      "$LABEL_WIDTH" "$(fit_field "$label" "$LABEL_WIDTH")" \
      "$COMMAND_WIDTH" "$(fit_field "$cmd" "$COMMAND_WIDTH")" \
      "$PATH_WIDTH" "$(fit_field "$display_path" "$PATH_WIDTH")" \
      "$STATUS_WIDTH" "$(fit_field "$flags" "$STATUS_WIDTH")" \
      "$(format_title "$title" "$cmd")" \
      "$session" "$pane_id"
  done
}

source_dirs() {
  local -a rows=()
  local max_icon=0
  local max_path=0

  command -v fd >/dev/null 2>&1 || return 0

  while IFS= read -r path; do
    local display_path
    local icon=''

    path="$(sanitize_text "$path")"
    display_path="$(short_path "$path")"

    ((${#icon} > max_icon)) && max_icon=${#icon}
    ((${#display_path} > max_path)) && max_path=${#display_path}

    rows+=("$icon${ROW_SEP}$display_path${ROW_SEP}$path")
  done < <(fd -H -d 2 -t d -E .Trash . "$HOME")

  for row in "${rows[@]}"; do
    local icon display_path path

    IFS="$ROW_SEP" read -r icon display_path path <<<"$row"

    printf 'dir\t%-*s  %-*s\t%s\n' \
      "$max_icon" "$icon" \
      "$max_path" "$display_path" \
      "$path"
  done
}

source_sesh() {
  local mode="${1:-all}"
  local line
  local target=""
  local output

  case "$mode" in
  all)
    output="$(sesh list --icons 2>/dev/null || true)"
    if [[ -n "$output" ]]; then
      while IFS= read -r line; do
        line="$(sanitize_text "$line")"
        [[ -n "$line" ]] && printf 'sesh\t%s\t%s\n' "$line" "$line"
      done <<<"$output"
    else
      source_sesh tmux
      source_sesh configs
      source_sesh zoxide
    fi
    ;;
  tmux)
    while IFS= read -r line; do
      line="$(sanitize_text "$line")"
      [[ -z "$line" ]] && continue
      target="$(sesh_tmux_target "$line")"
      printf 'sesh_tmux\t%s\t%s\t%s\n' "$line" "$line" "$target"
    done < <(sesh list -t --icons 2>/dev/null)
    ;;
  configs)
    while IFS= read -r line; do
      line="$(sanitize_text "$line")"
      [[ -n "$line" ]] && printf 'sesh\t%s\t%s\n' "$line" "$line"
    done < <(sesh list -c --icons 2>/dev/null)
    ;;
  zoxide)
    while IFS= read -r line; do
      line="$(sanitize_text "$line")"
      [[ -n "$line" ]] && printf 'sesh\t%s\t%s\n' "$line" "$line"
    done < <(sesh list -z --icons 2>/dev/null)
    ;;
  *)
    return 1
    ;;
  esac
}

source_all() {
  source_sessions
  source_windows
  source_panes
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

preview_dir() {
  sesh preview "$1"
}

preview_sesh() {
  sesh preview "$1"
}

preview_any() {
  local kind="$1"
  local arg1="$2"
  local arg2="${3:-}"

  case "$kind" in
  session) preview_session "$arg1" ;;
  window) preview_window "$arg1" "$arg2" ;;
  pane) preview_pane "$arg2" ;;
  dir) preview_dir "$arg1" ;;
  sesh | sesh_tmux) preview_sesh "$arg1" ;;
  *) return 1 ;;
  esac
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

open_dir() {
  sesh connect "$1"
}

open_sesh() {
  sesh connect "$1"
}

kill_selection() {
  local kind="$1"
  local arg1="$2"
  local arg2="${3:-}"

  case "$kind" in
  session) tmux kill-session -t "$arg1" ;;
  sesh_tmux) [[ -n "$arg2" ]] && tmux kill-session -t "$arg2" ;;
  *) return 0 ;;
  esac
}

mode_prompt() {
  case "$1" in
  all) printf 'tmux> ' ;;
  sesh) printf 'sesh> ' ;;
  tmux) printf 'tmux> ' ;;
  configs) printf 'cfg> ' ;;
  zoxide) printf 'zoxide> ' ;;
  sessions) printf 'sesh> ' ;;
  windows) printf 'win> ' ;;
  panes) printf 'pane> ' ;;
  dirs) printf 'find> ' ;;
  esac
}

mode_header() {
  case "$1" in
  all) printf ' 󱟀 enter open      󰐊 ctrl-a unified  󱂬 ctrl-s sessions  󰖲 ctrl-w windows\n 󰆍 ctrl-p panes    󰲋 ctrl-o sesh      ctrl-t tmux       ctrl-g configs\n 󰁔 ctrl-x zoxide   󰈞 ctrl-f find     󰆴 ctrl-d kill ' ;;
  sesh) printf ' 󱟀 enter connect   󰐊 ctrl-a unified  󰲋 ctrl-o sesh       ctrl-t tmux\n  ctrl-g configs  󰁔 ctrl-x zoxide   󰈞 ctrl-f find      󰆴 ctrl-d kill ' ;;
  tmux) printf ' 󱟀 enter connect   󰐊 ctrl-a unified  󰲋 ctrl-o sesh       ctrl-t tmux\n  ctrl-g configs  󰁔 ctrl-x zoxide   󰈞 ctrl-f find      󰆴 ctrl-d kill ' ;;
  configs) printf ' 󱟀 connect config  󰐊 ctrl-a unified  󰲋 ctrl-o sesh       ctrl-t tmux\n  ctrl-g configs  󰁔 ctrl-x zoxide   󰈞 ctrl-f find ' ;;
  zoxide) printf ' 󱟀 connect zoxide  󰐊 ctrl-a unified  󰲋 ctrl-o sesh       ctrl-t tmux\n  ctrl-g configs  󰁔 ctrl-x zoxide   󰈞 ctrl-f find ' ;;
  sessions) printf ' 󱟀 enter connect   󰐊 ctrl-a unified  󱂬 ctrl-s sessions  󰖲 ctrl-w windows\n 󰆍 ctrl-p panes    󰲋 ctrl-o sesh      ctrl-t tmux      󰆴 ctrl-d kill ' ;;
  windows) printf ' 󱟀 switch window   󰐊 ctrl-a unified  󱂬 ctrl-s sessions  󰖲 ctrl-w windows\n 󰆍 ctrl-p panes    󰲋 ctrl-o sesh      ctrl-t tmux      󰈞 ctrl-f find ' ;;
  panes) printf ' 󱟀 switch pane     󰐊 ctrl-a unified  󱂬 ctrl-s sessions  󰖲 ctrl-w windows\n 󰆍 ctrl-p panes    󰲋 ctrl-o sesh      ctrl-t tmux      󰈞 ctrl-f find ' ;;
  dirs) printf ' 󱟀 connect dir     󰐊 ctrl-a unified  󰲋 ctrl-o sesh       ctrl-t tmux\n  ctrl-g configs  󰁔 ctrl-x zoxide   󰈞 ctrl-f find ' ;;
  esac
}

mode_preview() {
  case "$1" in
  all) printf "%s preview any {1} {3} {4}" "$SELF_PATH" ;;
  sesh) printf "%s preview sesh {3}" "$SELF_PATH" ;;
  tmux) printf "%s preview sesh {3}" "$SELF_PATH" ;;
  configs) printf "%s preview sesh {3}" "$SELF_PATH" ;;
  zoxide) printf "%s preview sesh {3}" "$SELF_PATH" ;;
  sessions) printf "%s preview session {3}" "$SELF_PATH" ;;
  windows) printf "%s preview window {3} {4}" "$SELF_PATH" ;;
  panes) printf "%s preview pane {4}" "$SELF_PATH" ;;
  dirs) printf "%s preview dir {3}" "$SELF_PATH" ;;
  esac
}

fzf_preview_window() {
  printf 'right,55%%,border-left,wrap,<140(down,55%%,border-top,wrap)'
}

browse() {
  local initial_mode="${1:-panes}"
  local preview_window
  local selection

  preview_window="$(fzf_preview_window)"

  selection="$(
    FZF_DEFAULT_OPTS="${FZF_COLOR_OPTS}" \
      "$SELF_PATH" source "$initial_mode" |
      fzf \
        --ansi \
        --no-sort \
        --border=rounded \
        --delimiter=$'\t' \
        --layout=reverse \
        --height=100% \
        --prompt "$(mode_prompt "$initial_mode")" \
        --header "$(mode_header "$initial_mode")" \
        --with-nth=2 \
        --preview "$(mode_preview "$initial_mode")" \
        --preview-wrap-sign '' \
        --preview-window "$preview_window" \
        --bind "esc:abort" \
        --bind "ctrl-a:change-prompt($(mode_prompt all))+change-header($(mode_header all))+change-preview($(mode_preview all))+reload($SELF_PATH source all)" \
        --bind "ctrl-o:change-prompt($(mode_prompt sesh))+change-header($(mode_header sesh))+change-preview($(mode_preview sesh))+reload($SELF_PATH source sesh)" \
        --bind "ctrl-t:change-prompt($(mode_prompt tmux))+change-header($(mode_header tmux))+change-preview($(mode_preview tmux))+reload($SELF_PATH source tmux)" \
        --bind "ctrl-g:change-prompt($(mode_prompt configs))+change-header($(mode_header configs))+change-preview($(mode_preview configs))+reload($SELF_PATH source configs)" \
        --bind "ctrl-x:change-prompt($(mode_prompt zoxide))+change-header($(mode_header zoxide))+change-preview($(mode_preview zoxide))+reload($SELF_PATH source zoxide)" \
        --bind "ctrl-s:change-prompt($(mode_prompt sessions))+change-header($(mode_header sessions))+change-preview($(mode_preview sessions))+reload($SELF_PATH source sessions)" \
        --bind "ctrl-w:change-prompt($(mode_prompt windows))+change-header($(mode_header windows))+change-preview($(mode_preview windows))+reload($SELF_PATH source windows)" \
        --bind "ctrl-p:change-prompt($(mode_prompt panes))+change-header($(mode_header panes))+change-preview($(mode_preview panes))+reload($SELF_PATH source panes)" \
        --bind "ctrl-f:change-prompt($(mode_prompt dirs))+change-header($(mode_header dirs))+change-preview($(mode_preview dirs))+reload($SELF_PATH source dirs)" \
        --bind "ctrl-d:execute-silent($SELF_PATH kill {1} {3} {4})+change-prompt($(mode_prompt tmux))+change-header($(mode_header tmux))+change-preview($(mode_preview tmux))+reload($SELF_PATH source tmux)"
  )"

  [[ -z "${selection}" ]] && return 0

  IFS=$'\t' read -r kind display arg1 arg2 arg3 _rest <<<"$selection"

  case "$kind" in
  session) open_session "$arg1" ;;
  window) open_window "$arg1" "$arg2" ;;
  pane) open_pane "$arg1" "$arg2" ;;
  dir) open_dir "$arg1" ;;
  sesh | sesh_tmux) open_sesh "$arg1" ;;
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
  all) source_all ;;
  sesh) source_sesh all ;;
  tmux) source_sesh tmux ;;
  configs) source_sesh configs ;;
  zoxide) source_sesh zoxide ;;
  sessions) source_sessions ;;
  windows) source_windows ;;
  panes) source_panes ;;
  dirs) source_dirs ;;
  *) exit 1 ;;
  esac
  ;;
preview)
  case "${2:-}" in
  any) preview_any "${3:-}" "${4:-}" "${5:-}" ;;
  session)
    shift 2
    preview_session "$*"
    ;;
  window) preview_window "${3:-}" "${4:-}" ;;
  pane) preview_pane "${3:-}" ;;
  dir)
    shift 2
    preview_dir "$*"
    ;;
  sesh)
    shift 2
    preview_sesh "$*"
    ;;
  sesh_tmux)
    shift 2
    preview_sesh "$*"
    ;;
  *) exit 1 ;;
  esac
  ;;
kill)
  shift || true
  kill_selection "${1:-}" "${2:-}" "${3:-}"
  ;;
preview-window)
  fzf_preview_window
  ;;
*)
  exit 1
  ;;
esac

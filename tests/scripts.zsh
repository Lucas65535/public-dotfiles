#!/usr/bin/env zsh
set -euo pipefail

repo_root="${0:A:h:h}"

fail() {
  print -u2 -- "FAIL: $*"
  exit 1
}

assert_executable() {
  local path="$1"
  [[ -x "$repo_root/$path" ]] || fail "$path must exist and be executable"
}

assert_no_repo_path_hardcodes() {
  local matches
  matches="$(
    grep -RInE '(/Users/lucas|~/infra/dotfiles|\$HOME/infra/dotfiles|~/code/public-dotfiles|\$HOME/code/public-dotfiles)' \
      "$repo_root/scripts" \
      "$repo_root/tmux" \
      "$repo_root/zsh" \
      "$repo_root/nvim" \
      "$repo_root/claude-theme" \
      2>/dev/null || true
  )"

  [[ -z "$matches" ]] || fail "repo path hardcodes found:\n$matches"
}

assert_file_contains() {
  local file_path="$1"
  local needle="$2"

  grep -Fq -- "$needle" "$repo_root/$file_path" || fail "$file_path must contain: $needle"
}

assert_executable scripts/relink.zsh
assert_executable scripts/update.zsh
assert_executable scripts/bootstrap-macos.zsh

[[ -f "$repo_root/scripts/lib/dotfiles.zsh" ]] || fail "scripts/lib/dotfiles.zsh must exist"

assert_no_repo_path_hardcodes
assert_file_contains scripts/relink.zsh 'link_path "$repo_root/tmux/sesh-browser.sh" "$config_home/tmux/sesh-browser.sh"'
assert_file_contains tmux/tmux.conf.local '$HOME/.config/tmux/sesh-browser.sh browse panes'

print -r -- "scripts tests passed"

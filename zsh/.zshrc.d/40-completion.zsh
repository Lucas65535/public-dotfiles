# Completion system

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit
compinit -C

# Kubectl completion: cache to file to avoid process substitution on every startup.
if command -v kubectl >/dev/null 2>&1; then
  typeset _kcomp_base _kcomp_dir _kcomp_file
  _kcomp_base="${XDG_CACHE_HOME:-$HOME/.cache}"
  _kcomp_dir="${_kcomp_base}/zsh/completions"
  _kcomp_file="${_kcomp_dir}/_kubectl"

  # If cache dir is not writable (restricted environments), fall back to TMPDIR.
  if ! mkdir -p "$_kcomp_dir" 2>/dev/null; then
    _kcomp_dir="${TMPDIR:-/tmp}/zsh/completions"
    _kcomp_file="${_kcomp_dir}/_kubectl"
    mkdir -p "$_kcomp_dir" 2>/dev/null
  fi

  if [[ -d "$_kcomp_dir" && ! -s "$_kcomp_file" ]]; then
    kubectl completion zsh >| "$_kcomp_file" 2>/dev/null || true
  fi

  if [[ -s "$_kcomp_file" ]]; then
    fpath=("$_kcomp_dir" $fpath)
    source "$_kcomp_file"
  fi

  unset _kcomp_base _kcomp_dir _kcomp_file
fi

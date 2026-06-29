# Dotfiles

macOS development environment managed via symlinks. One clone, one bootstrap script — done.

## What's Inside

| Config | Repo Path | Symlink Target |
|---|---|---|
| Zsh | `zsh/.zshrc` | `~/.zshrc` |
| Starship prompt | `starship/starship.toml` | `~/.config/starship.toml` |
| Neovim (LazyVim) | `nvim/` | `~/.config/nvim` |
| Ghostty terminal | `ghostty/` | `~/.config/ghostty` |
| lazygit | `lazygit/` | `~/.config/lazygit` |
| tmux (oh-my-tmux) | `tmux/tmux.conf.local` | `~/.config/tmux/tmux.conf.local` |
| Atuin (shell history) | `atuin/` | `~/.config/atuin` |
| bat | `bat/` | `~/.config/bat` |
| btop | `btop/` | `~/.config/btop` |
| lsd | `lsd/` | `~/.config/lsd` |
| Yazi (file manager) | `yazi/` | `~/.config/yazi` |
| k9s | `k9s/` | `~/.config/k9s` |
| Codex themes | `codex/themes/` | `~/.codex/themes` |
| Claude Code themes | `claude-theme/claude-code-cli/` | `~/.claude/themes` |
| Homebrew packages | `Brewfile` | — |

Theme variants live in-repo. The unified Claude palette source of truth is [`claude-theme/palette.md`](claude-theme/palette.md), and Codex-specific TextMate themes live under `codex/themes/`.

The Claude palette is applied across: nvim, ghostty, codex, **Claude Code CLI** (`claude-theme/claude-code-cli/`), yazi, k9s, starship, tmux, zsh/fzf, lazygit, lsd, **bat** (`bat/themes/`), **btop** (`btop/themes/`), and **atuin** (`atuin/themes/`).

## Fresh Machine Setup

```bash
# 1. Clone
git clone https://github.com/<USER>/dotfiles.git ~/infra/dotfiles

# 2. Install packages, tmux framework, and symlinks
~/infra/dotfiles/scripts/bootstrap-macos.zsh

# 3. Reload
exec $SHELL -l
```

Optional `~/.codex/config.toml` snippet for dark-by-default:

```toml
[tui]
theme = "claude-code"
```

`claude-code` is a repo-level alias that points to `claude-code-dark.tmTheme`. Use `claude-code-light` in `~/.codex/config.toml` or from Codex `/theme` only when you want the light variant.

## Day-to-Day Usage

### Editing Configs

All configs live in this repository. Edit them here — changes take effect immediately via symlinks. No copy/sync steps needed.

```bash
# Example: tweak Ghostty config
nvim ghostty/config
```

### tmux (oh-my-tmux)

This repo manages only `tmux/tmux.conf.local` — the user customization layer. The framework itself is installed separately and not tracked in git.

| Component | Path | Managed? |
|---|---|---|
| oh-my-tmux framework | `~/.local/share/tmux/oh-my-tmux/` | ❌ git clone from upstream |
| Main config (symlink → framework) | `~/.config/tmux/tmux.conf` | ❌ auto-created on setup |
| **User config** | `~/.config/tmux/tmux.conf.local` | ✅ **this repo** |
| TPM plugins | `~/.config/tmux/plugins/` | ❌ auto-installed by TPM |

To update oh-my-tmux to the latest version:

```bash
scripts/update.zsh
```

After editing `tmux.conf.local`, reload inside tmux with `<prefix>` + `r`.

### Codex Themes

Codex CLI picks up custom `.tmTheme` files from `~/.codex/themes`. This repo ships three entries:

| Theme | File | Notes |
|---|---|---|
| `claude-code` | `codex/themes/claude-code.tmTheme` | default alias -> dark |
| `claude-code-light` | `codex/themes/claude-code-light.tmTheme` | warm Kaku paper background |
| `claude-code-dark` | `codex/themes/claude-code-dark.tmTheme` | warm Claude dark background |

Use Codex `/theme` to preview and switch interactively, or set `tui.theme = "claude-code"` / `tui.theme = "claude-code-dark"` in `~/.codex/config.toml`.

### Claude Code Themes

Claude Code (the CLI) auto-loads custom themes from `~/.claude/themes/` (symlinked to `claude-theme/claude-code-cli/`). Each `*.json` file is a theme; its slug is the filename without extension. The format is a small override layer over a built-in base theme:

```json
{ "name": "Claude Code Dark", "base": "dark", "overrides": { "claude": "#D4967E", ... } }
```

This repo ships two:

| Theme slug | File | Base |
|---|---|---|
| `claude-code-dark` | `claude-code-dark.json` | `dark` |
| `claude-code-light` | `claude-code-light.json` | `light` |

Select with Claude Code `/theme` (entries appear as "Claude Code Dark/Light"), or set in `~/.claude/settings.json`:

```json
"theme": "custom:claude-code-dark"
```

Only override keys that exist in the base theme are applied, and values must be `#hex` or `rgb(...)`. The directory is watched, so edits hot-reload.

### Saving Changes

```bash
git add -A && git commit -m "tweak: ghostty font size"
git push
```

### Updating This Repo From the Current Mac

After installing or uninstalling software, update `Brewfile`, refresh oh-my-tmux, and rebuild symlinks:

```bash
scripts/update.zsh
```

To only check/install Brewfile contents manually:

```bash
brew bundle check --file=Brewfile          # quick check
brew bundle --file=Brewfile --no-upgrade   # install missing only
```

### Adding a New Config

```bash
# 1. Copy config into repo
cp -r ~/.config/newapp newapp

# 2. Replace original with symlink
rm -rf ~/.config/newapp
ln -sf "$PWD/newapp" ~/.config/newapp

# 3. Update .gitignore if needed (logs, caches, etc.)
# 4. Commit
```

For configs where the parent directory contains other non-config files (databases, plugins managed externally), use **file-level** symlinks instead of linking the whole directory. For config-only directories, keep using directory symlinks under `~/.config/`.

## Migrating to Another Mac

On the **old** machine — make sure everything is committed and pushed:

```bash
scripts/update.zsh
git add -A && git commit -m "chore: sync before migration"
git push
```

On the **new** machine — clone the repo and run:

```bash
scripts/bootstrap-macos.zsh
exec $SHELL -l
```

### What This Repo Does NOT Manage

Credentials and secrets stay local — never commit these:

- `~/.ssh/` — SSH keys
- `~/.aws/`, `~/.azure/`, `~/.kube/` — cloud credentials
- `~/.gnupg/` — GPG keys
- `~/.gitconfig` — may contain tokens
- `~/.npmrc` — may contain auth tokens
- `~/.gemini/settings.json` — contains MCP server configs with API keys
- `~/.gemini/antigravity/mcp_config.json` — contains API keys

## Symlink Strategy

Two patterns, chosen based on directory content:

| Pattern | When to Use | Example |
|---|---|---|
| **Directory symlink** | Entire dir is config-only | `~/.config/ghostty → dotfiles/ghostty` |
| **File symlink** | Parent dir has mixed content | `~/.config/starship.toml → dotfiles/starship/starship.toml` |

## Scripts

| Script | Purpose |
|---|---|
| `scripts/relink.zsh` | Rebuild symlinks from the current repo location. |
| `scripts/update.zsh` | Dump the current Homebrew state into `Brewfile`, update oh-my-tmux, and relink. |
| `scripts/bootstrap-macos.zsh` | Install Homebrew if needed, install `Brewfile`, install/update oh-my-tmux, and relink. |

## Key Shell Aliases

| Alias | Expands To | Note |
|---|---|---|
| `y` | yazi wrapper | Opens file manager; `cd`s on exit |
| `z` | zoxide | Smart directory jump |
| `zi` | zoxide interactive | Jump with fzf picker |
| `v` / `vv` | nvim / nvim . | Editor |
| `t` | tmux | Session manager |
| `ls` / `ll` / `la` | lsd variants | File listing with icons |

# Dotfiles

macOS development environment managed via symlinks. One clone, one `brew bundle`, a few `ln -s` — done.

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
| Codex themes | `codex/themes/` | `~/.codex/themes` |
| Homebrew packages | `Brewfile` | — |

AI agent skills and instructions are managed in a separate **private** repository. See that repo's README for setup.

Theme variants live in-repo. The unified Claude palette source of truth is [`claude-theme/palette.md`](claude-theme/palette.md), and Codex-specific TextMate themes live under `codex/themes/`.

## Fresh Machine Setup

```bash
# 1. Clone
git clone https://github.com/<USER>/public-dotfiles.git ~/code/public-dotfiles

# 2. Install everything
brew bundle --file=~/code/public-dotfiles/Brewfile

# 3. Symlinks — shell
ln -sf ~/code/public-dotfiles/zsh/.zshrc ~/.zshrc

# 4. Symlinks — ~/.config (directory-level)
for dir in nvim ghostty lazygit atuin bat btop lsd yazi; do
  rm -rf ~/.config/$dir
  ln -sf ~/code/public-dotfiles/$dir ~/.config/$dir
done

# 5. Symlinks — file-level (target dir has other content)
ln -sf ~/code/public-dotfiles/starship/starship.toml ~/.config/starship.toml

# 6. tmux — install oh-my-tmux framework + link config
git clone https://github.com/gpakosz/.tmux.git ~/.local/share/tmux/oh-my-tmux
mkdir -p ~/.config/tmux
ln -sf ~/.local/share/tmux/oh-my-tmux/.tmux.conf ~/.config/tmux/tmux.conf
ln -sf ~/code/public-dotfiles/tmux/tmux.conf.local ~/.config/tmux/tmux.conf.local

# 7. Symlinks — AI agent configs (from private-agents repo)
# See: ~/code/private-agents/README.md for setup instructions

# 8. Symlinks — Codex custom themes
mkdir -p ~/.codex
ln -sfn ~/code/public-dotfiles/codex/themes ~/.codex/themes

# 9. Reload
exec $SHELL -l
```

Optional `~/.codex/config.toml` snippet for light-by-default:

```toml
[tui]
theme = "claude-code"
```

`claude-code` is a repo-level alias that points to `claude-code-light.tmTheme`. Switch to `claude-code-dark` in `~/.codex/config.toml` or from Codex `/theme` when you want the dark variant.

## Day-to-Day Usage

### Editing Configs

All configs live in `~/code/public-dotfiles/`. Edit them there — changes take effect immediately via symlinks. No copy/sync steps needed.

```bash
# Example: tweak Ghostty config
nvim ~/code/public-dotfiles/ghostty/config  # edit in repo, live immediately
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
cd ~/.local/share/tmux/oh-my-tmux && git pull
```

After editing `tmux.conf.local`, reload inside tmux with `<prefix>` + `r`.

### Codex Themes

Codex CLI picks up custom `.tmTheme` files from `~/.codex/themes`. This repo ships three entries:

| Theme | File | Notes |
|---|---|---|
| `claude-code` | `codex/themes/claude-code.tmTheme` | default alias → light |
| `claude-code-light` | `codex/themes/claude-code-light.tmTheme` | warm Kaku paper background |
| `claude-code-dark` | `codex/themes/claude-code-dark.tmTheme` | warm Claude dark background |

Use Codex `/theme` to preview and switch interactively, or set `tui.theme = "claude-code"` / `tui.theme = "claude-code-dark"` in `~/.codex/config.toml`.

### Saving Changes

```bash
cd ~/code/public-dotfiles
git add -A && git commit -m "tweak: ghostty font size"
git push
```

### Updating Brewfile

When you install or uninstall software, re-dump to keep the Brewfile in sync:

```bash
brew bundle dump --force --file=~/code/public-dotfiles/Brewfile
```

To check what's missing vs. what's installed:

```bash
brew bundle check --file=~/code/public-dotfiles/Brewfile          # quick check
brew bundle --file=~/code/public-dotfiles/Brewfile --no-upgrade   # install missing only
```

### Adding a New Config

```bash
# 1. Copy config into repo
cp -r ~/.config/newapp ~/code/public-dotfiles/newapp

# 2. Replace original with symlink
rm -rf ~/.config/newapp
ln -sf ~/code/public-dotfiles/newapp ~/.config/newapp

# 3. Update .gitignore if needed (logs, caches, etc.)
# 4. Commit
```

For configs where the parent directory contains other non-config files (databases, plugins managed externally), use **file-level** symlinks instead of linking the whole directory. For config-only directories, keep using directory symlinks under `~/.config/`.

## Migrating to Another Mac

On the **old** machine — make sure everything is committed and pushed:

```bash
cd ~/code/public-dotfiles
brew bundle dump --force --file=Brewfile
git add -A && git commit -m "chore: sync before migration"
git push
```

On the **new** machine — run the [Fresh Machine Setup](#fresh-machine-setup) steps above.

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

## Key Shell Aliases

| Alias | Expands To | Note |
|---|---|---|
| `y` | yazi wrapper | Opens file manager; `cd`s on exit |
| `z` | zoxide | Smart directory jump |
| `zi` | zoxide interactive | Jump with fzf picker |
| `v` / `vv` | nvim / nvim . | Editor |
| `t` | tmux | Session manager |
| `ls` / `ll` / `la` | lsd variants | File listing with icons |

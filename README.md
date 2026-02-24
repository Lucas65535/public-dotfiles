# Dotfiles

macOS development environment managed via symlinks. One clone, one `brew bundle`, a few `ln -s` — done.

## What's Inside

| Config | Repo Path | Symlink Target |
|---|---|---|
| Zsh | `zsh/.zshrc` | `~/.zshrc` |
| Starship prompt | `starship/starship.toml` | `~/.config/starship.toml` |
| Neovim (LazyVim) | `nvim/` | `~/.config/nvim` |
| Ghostty terminal | `ghostty/` | `~/.config/ghostty` |
| tmux (oh-my-tmux) | `tmux/tmux.conf.local` | `~/.config/tmux/tmux.conf.local` |
| Atuin (shell history) | `atuin/` | `~/.config/atuin` |
| bat | `bat/` | `~/.config/bat` |
| btop | `btop/` | `~/.config/btop` |
| lsd | `lsd/` | `~/.config/lsd` |
| Yazi (file manager) | `yazi/` | `~/.config/yazi` |
| AI agent skills | `agents/skills/` | `~/.agents/skills`, `~/.gemini/antigravity/skills`, `~/.claude/skills`, `~/.codex/skills` |
| AI agent instructions | `agents/GEMINI.md` | `~/.gemini/GEMINI.md`, `~/.claude/CLAUDE.md`, `~/.codex/instructions.md` |
| Homebrew packages | `Brewfile` | — |

Theme: **Catppuccin Mocha** across all tools (fzf, bat, yazi, zsh highlighting).

## Fresh Machine Setup

```bash
# 1. Clone
git clone https://github.com/<USER>/public-dotfiles.git ~/code/public-dotfiles

# 2. Install everything
brew bundle --file=~/code/public-dotfiles/Brewfile

# 3. Symlinks — shell
ln -sf ~/code/public-dotfiles/zsh/.zshrc ~/.zshrc

# 4. Symlinks — ~/.config (directory-level)
for dir in nvim ghostty atuin bat btop lsd yazi; do
  rm -rf ~/.config/$dir
  ln -sf ~/code/public-dotfiles/$dir ~/.config/$dir
done

# 5. Symlinks — ~/.config (file-level, target dir has other content)
ln -sf ~/code/public-dotfiles/starship/starship.toml ~/.config/starship.toml

# 6. tmux — install oh-my-tmux framework + link config
git clone https://github.com/gpakosz/.tmux.git ~/.local/share/tmux/oh-my-tmux
mkdir -p ~/.config/tmux
ln -sf ~/.local/share/tmux/oh-my-tmux/.tmux.conf ~/.config/tmux/tmux.conf
ln -sf ~/code/public-dotfiles/tmux/tmux.conf.local ~/.config/tmux/tmux.conf.local

# 7. Symlinks — AI agent configs (skills shared across all agents)
mkdir -p ~/.agents ~/.claude ~/.codex
rm -rf ~/.agents/skills ~/.gemini/antigravity/skills ~/.claude/skills ~/.codex/skills
ln -sf ~/code/public-dotfiles/agents/skills ~/.agents/skills
ln -sf ~/code/public-dotfiles/agents/skills ~/.gemini/antigravity/skills
ln -sf ~/code/public-dotfiles/agents/skills ~/.claude/skills
ln -sf ~/code/public-dotfiles/agents/skills ~/.codex/skills
ln -sf ~/code/public-dotfiles/agents/.skill-lock.json ~/.agents/.skill-lock.json
ln -sf ~/code/public-dotfiles/agents/GEMINI.md ~/.gemini/GEMINI.md
ln -sf ~/code/public-dotfiles/agents/GEMINI.md ~/.claude/CLAUDE.md
ln -sf ~/code/public-dotfiles/agents/GEMINI.md ~/.codex/instructions.md

# 8. Reload
exec $SHELL -l
```

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

For configs where the parent directory contains other non-config files (databases, plugins managed externally), use **file-level** symlinks instead of linking the whole directory.

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
| **File symlink** | Dir has mixed content (DBs, external plugins) | `~/.config/tmux/tmux.conf.local → dotfiles/tmux/tmux.conf.local` |

## Key Shell Aliases

| Alias | Expands To | Note |
|---|---|---|
| `y` | yazi wrapper | Opens file manager; `cd`s on exit |
| `z` | zoxide | Smart directory jump |
| `zi` | zoxide interactive | Jump with fzf picker |
| `v` / `vv` | nvim / nvim . | Editor |
| `t` | tmux | Session manager |
| `ls` / `ll` / `la` | lsd variants | File listing with icons |

# Local or tool-managed post hooks.

[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"

# Pin Firecrawl to the local self-hosted endpoint after tool hooks so outer
# session state or post-init scripts cannot silently redirect it elsewhere.
export FIRECRAWL_API_URL="http://localhost:3002"

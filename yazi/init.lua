-- ── Yazi Init ────────────────────────────────────────────────────────────────

-- Git status linemode
require("git"):setup {
  order = 1500,
}

-- Starship prompt in header
require("starship"):setup()

-- Claude Code colorscheme — palette definitions
-- Dark + Light, derived from the unified palette.md specification.

local M = {}

M.dark = {
  -- Background layers
  bg = "#141413",
  bg_alt = "#1A1917",
  bg_surface = "#1F1D1A",
  bg_inset = "#2B2A27",
  bg_highlight = "#332F29",

  -- Foreground layers
  fg = "#EAE7DF",
  fg_muted = "#A9A39A",
  fg_subtle = "#6B665F",

  -- Border
  border = "#4A473F",
  border_strong = "#6B665F",

  -- Accent (terracotta)
  accent = "#D4967E",
  accent_hover = "#E0AB96",
  accent_dim = "#CC785C",

  -- ANSI
  black = "#1A1917",
  red = "#D47563",
  green = "#9ACA86",
  yellow = "#E8C96B",
  blue = "#61AAF2",
  magenta = "#9B87F5",
  cyan = "#8CC4FF",
  white = "#D9D5CC",
  bright_black = "#6B665F",
  bright_red = "#F09884",
  bright_green = "#B6E0A5",
  bright_yellow = "#F2D98F",
  bright_blue = "#A2D2FF",
  bright_magenta = "#C9BCFF",
  bright_cyan = "#BDE0FF",
  bright_white = "#F5F2E9",

  -- Syntax
  syn_keyword = "#E2A48B",
  syn_string = "#B5E6A0",
  syn_function = "#FFC1A6",
  syn_type = "#AFCCF8",
  syn_number = "#F4DC90",
  syn_comment = "#B8AFA3",
  syn_constant = "#FFB19D",
  syn_decorator = "#9B87F5",
  syn_property = "#F6DDCD",
  syn_parameter = "#F0CDBA",
  syn_operator = "#E2D8CC",
  syn_punctuation = "#C6BDB2",
  syn_tag = "#D9645B",
  syn_attribute = "#F6DFC7",
  syn_regexp = "#FBE7AA",
  syn_namespace = "#61AAF2",

  -- Status
  error = "#D47563",
  warning = "#E8C96B",
  success = "#9ACA86",
  info = "#61AAF2",

  -- Git
  git_added = "#9ACA86",
  git_modified = "#E8C96B",
  git_deleted = "#D47563",

  -- Diff (pre-blended over bg)
  diff_add = "#2B3325",
  diff_change = "#2B2A1E",
  diff_delete = "#332220",
  diff_text = "#3A3520",

  -- Special
  none = "NONE",
}

M.light = {
  -- Background layers (Kaku warm yellow)
  bg = "#FFFCF0",
  bg_alt = "#F2F0E6",
  bg_surface = "#F5F3EB",
  bg_inset = "#E8E6DB",
  bg_highlight = "#ECE9DF",

  -- Foreground layers
  fg = "#1A1917",
  fg_muted = "#6B665F",
  fg_subtle = "#8D877D",

  -- Border
  border = "#D9D5CC",
  border_strong = "#A9A39A",

  -- Accent (terracotta)
  accent = "#CC785C",
  accent_hover = "#B85F3D",
  accent_dim = "#CC785C",

  -- ANSI
  black = "#1A1917",
  red = "#A84B3A",
  green = "#2E7C4C",
  yellow = "#8A6220",
  blue = "#207FDE",
  magenta = "#6A5BCC",
  cyan = "#2E5F99",
  white = "#746E64",
  bright_black = "#8D877D",
  bright_red = "#C45F4A",
  bright_green = "#5E8F6D",
  bright_yellow = "#9C7A39",
  bright_blue = "#4F79A8",
  bright_magenta = "#6D5DBD",
  bright_cyan = "#45809E",
  bright_white = "#4A473F",

  -- Syntax
  syn_keyword = "#B84A2A",
  syn_string = "#2D7F4D",
  syn_function = "#AE4E30",
  syn_type = "#386290",
  syn_number = "#946A1E",
  syn_comment = "#6C655D",
  syn_constant = "#BD5341",
  syn_decorator = "#6A5BCC",
  syn_property = "#3A6594",
  syn_parameter = "#AE6D53",
  syn_operator = "#6A645C",
  syn_punctuation = "#877C70",
  syn_tag = "#CC5E54",
  syn_attribute = "#B46344",
  syn_regexp = "#B07C26",
  syn_namespace = "#207FDE",

  -- Status
  error = "#A84B3A",
  warning = "#8A6220",
  success = "#2E7C4C",
  info = "#207FDE",

  -- Git
  git_added = "#2E7C4C",
  git_modified = "#8A6220",
  git_deleted = "#A84B3A",

  -- Diff (pre-blended over bg)
  diff_add = "#EEF2E3",
  diff_change = "#F5F0DE",
  diff_delete = "#F8EDE0",
  diff_text = "#EDE5D0",

  -- Special
  none = "NONE",
}

return M

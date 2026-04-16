-- Claude Code colorscheme — highlight definitions
-- Covers: editor, syntax, treesitter, LSP, diagnostics, git, and popular plugins.

local M = {}

--- Apply a table of highlight groups.
---@param groups table<string, table>
local function set_highlights(groups)
  for group, opts in pairs(groups) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

--- Build and apply all highlight groups for the given palette.
---@param p table  palette (dark or light)
function M.apply(p)
  -- ══════════════════════════════════════════
  -- Editor
  -- ══════════════════════════════════════════
  set_highlights({
    Normal = { fg = p.fg, bg = p.bg },
    NormalFloat = { fg = p.fg, bg = p.bg_surface },
    NormalNC = { fg = p.fg, bg = p.bg },
    FloatBorder = { fg = p.border_strong, bg = p.bg_surface },
    FloatTitle = { fg = p.accent, bg = p.bg_surface, bold = true },
    Cursor = { fg = p.bg, bg = p.accent },
    lCursor = { link = "Cursor" },
    CursorIM = { link = "Cursor" },
    TermCursor = { fg = p.bg, bg = p.accent },
    TermCursorNC = { fg = p.bg, bg = p.fg_subtle },
    CursorLine = { bg = p.bg_highlight },
    CursorColumn = { bg = p.bg_highlight },
    CursorLineNr = { fg = p.fg_muted, bold = true },
    LineNr = { fg = p.fg_subtle },
    LineNrAbove = { fg = p.fg_subtle },
    LineNrBelow = { fg = p.fg_subtle },
    SignColumn = { fg = p.fg_subtle, bg = p.bg },
    FoldColumn = { fg = p.fg_subtle, bg = p.bg },
    Folded = { fg = p.fg_muted, bg = p.bg_inset },
    ColorColumn = { bg = p.bg_inset },

    Visual = { bg = p.bg_inset },
    VisualNOS = { bg = p.bg_inset },

    Pmenu = { fg = p.fg, bg = p.bg_surface },
    PmenuSel = { fg = p.fg, bg = p.bg_inset },
    PmenuSbar = { bg = p.bg_inset },
    PmenuThumb = { bg = p.fg_subtle },
    PmenuKind = { fg = p.accent },
    PmenuKindSel = { fg = p.accent, bg = p.bg_inset },
    PmenuExtra = { fg = p.fg_muted },
    PmenuExtraSel = { fg = p.fg_muted, bg = p.bg_inset },

    WildMenu = { fg = p.bg, bg = p.accent },
    StatusLine = { fg = p.fg_muted, bg = p.bg_alt },
    StatusLineNC = { fg = p.fg_subtle, bg = p.bg_alt },
    WinBar = { fg = p.fg_muted, bg = p.bg },
    WinBarNC = { fg = p.fg_subtle, bg = p.bg },
    WinSeparator = { fg = p.border, bg = p.bg },
    VertSplit = { link = "WinSeparator" },
    TabLine = { fg = p.fg_subtle, bg = p.bg_alt },
    TabLineSel = { fg = p.fg, bg = p.bg, bold = true },
    TabLineFill = { bg = p.bg_alt },

    Search = { fg = p.bg, bg = p.syn_number },
    IncSearch = { fg = p.bg, bg = p.accent },
    CurSearch = { fg = p.bg, bg = p.accent, bold = true },
    Substitute = { fg = p.bg, bg = p.red },

    MatchParen = { fg = p.accent, bg = p.bg_inset, bold = true },

    MsgArea = { fg = p.fg },
    ModeMsg = { fg = p.fg, bold = true },
    MoreMsg = { fg = p.accent },
    ErrorMsg = { fg = p.error },
    WarningMsg = { fg = p.warning },
    Question = { fg = p.accent },

    NonText = { fg = p.fg_subtle },
    SpecialKey = { fg = p.fg_subtle },
    Whitespace = { fg = p.border },
    EndOfBuffer = { fg = p.bg_inset },
    Conceal = { fg = p.fg_subtle },

    Directory = { fg = p.accent },
    Title = { fg = p.accent, bold = true },
    QuickFixLine = { bg = p.bg_highlight },
    qfFileName = { fg = p.accent },
    qfLineNr = { fg = p.fg_subtle },

    SpellBad = { undercurl = true, sp = p.error },
    SpellCap = { undercurl = true, sp = p.warning },
    SpellLocal = { undercurl = true, sp = p.info },
    SpellRare = { undercurl = true, sp = p.magenta },

    DiffAdd = { bg = p.diff_add },
    DiffChange = { bg = p.diff_change },
    DiffDelete = { bg = p.diff_delete },
    DiffText = { bg = p.diff_text },
  })

  -- ══════════════════════════════════════════
  -- Syntax (Vim built-in groups)
  -- ══════════════════════════════════════════
  set_highlights({
    Comment = { fg = p.syn_comment, italic = true },
    Constant = { fg = p.syn_constant },
    String = { fg = p.syn_string },
    Character = { fg = p.syn_string },
    Number = { fg = p.syn_number },
    Float = { fg = p.syn_number },
    Boolean = { fg = p.syn_number },
    Identifier = { fg = p.fg },
    Function = { fg = p.syn_function },
    Statement = { fg = p.syn_keyword },
    Conditional = { fg = p.syn_keyword },
    Repeat = { fg = p.syn_keyword },
    Label = { fg = p.syn_namespace },
    Operator = { fg = p.syn_operator },
    Keyword = { fg = p.syn_keyword, italic = true },
    Exception = { fg = p.syn_keyword },
    PreProc = { fg = p.syn_keyword },
    Include = { fg = p.syn_keyword },
    Define = { fg = p.syn_keyword },
    Macro = { fg = p.syn_decorator },
    PreCondit = { fg = p.syn_keyword },
    Type = { fg = p.syn_type },
    StorageClass = { fg = p.syn_keyword },
    Structure = { fg = p.syn_type },
    Typedef = { fg = p.syn_type },
    Special = { fg = p.syn_decorator },
    SpecialChar = { fg = p.syn_decorator },
    Tag = { fg = p.syn_tag },
    Delimiter = { fg = p.syn_punctuation },
    SpecialComment = { fg = p.syn_comment, bold = true },
    Debug = { fg = p.warning },
    Underlined = { fg = p.syn_namespace, underline = true },
    Ignore = { fg = p.fg_subtle },
    Error = { fg = p.error },
    Todo = { fg = p.bg, bg = p.accent, bold = true },
    Added = { fg = p.git_added },
    Changed = { fg = p.git_modified },
    Removed = { fg = p.git_deleted },
  })

  -- ══════════════════════════════════════════
  -- Treesitter
  -- ══════════════════════════════════════════
  set_highlights({
    ["@variable"] = { fg = p.fg },
    ["@variable.builtin"] = { fg = p.syn_namespace },
    ["@variable.parameter"] = { fg = p.syn_parameter },
    ["@variable.parameter.builtin"] = { fg = p.syn_parameter, italic = true },
    ["@variable.member"] = { fg = p.syn_property },
    ["@constant"] = { fg = p.syn_constant },
    ["@constant.builtin"] = { fg = p.syn_constant },
    ["@constant.macro"] = { fg = p.syn_decorator },
    ["@module"] = { fg = p.syn_namespace },
    ["@module.builtin"] = { fg = p.syn_namespace },
    ["@label"] = { fg = p.syn_namespace },

    ["@string"] = { fg = p.syn_string },
    ["@string.documentation"] = { fg = p.syn_comment },
    ["@string.escape"] = { fg = p.syn_decorator },
    ["@string.regexp"] = { fg = p.syn_regexp },
    ["@string.special"] = { fg = p.syn_decorator },
    ["@string.special.symbol"] = { fg = p.syn_constant },
    ["@string.special.url"] = { fg = p.syn_namespace, underline = true },

    ["@character"] = { fg = p.syn_string },
    ["@character.special"] = { fg = p.syn_decorator },
    ["@boolean"] = { fg = p.syn_number },
    ["@number"] = { fg = p.syn_number },
    ["@number.float"] = { fg = p.syn_number },

    ["@type"] = { fg = p.syn_type },
    ["@type.builtin"] = { fg = p.syn_type, italic = true },
    ["@type.definition"] = { fg = p.syn_type },
    ["@type.qualifier"] = { fg = p.syn_keyword },

    ["@attribute"] = { fg = p.syn_attribute },
    ["@attribute.builtin"] = { fg = p.syn_decorator },
    ["@property"] = { fg = p.syn_property },

    ["@function"] = { fg = p.syn_function },
    ["@function.builtin"] = { fg = p.syn_namespace },
    ["@function.call"] = { fg = p.syn_function },
    ["@function.macro"] = { fg = p.syn_decorator },
    ["@function.method"] = { fg = p.syn_function },
    ["@function.method.call"] = { fg = p.syn_function },

    ["@constructor"] = { fg = p.syn_type },
    ["@operator"] = { fg = p.syn_operator },

    ["@keyword"] = { fg = p.syn_keyword, italic = true },
    ["@keyword.coroutine"] = { fg = p.syn_keyword, italic = true },
    ["@keyword.function"] = { fg = p.syn_keyword, italic = true },
    ["@keyword.operator"] = { fg = p.syn_keyword },
    ["@keyword.import"] = { fg = p.syn_keyword },
    ["@keyword.type"] = { fg = p.syn_keyword },
    ["@keyword.modifier"] = { fg = p.syn_keyword },
    ["@keyword.repeat"] = { fg = p.syn_keyword },
    ["@keyword.return"] = { fg = p.syn_keyword, italic = true },
    ["@keyword.debug"] = { fg = p.warning },
    ["@keyword.exception"] = { fg = p.syn_keyword },
    ["@keyword.conditional"] = { fg = p.syn_keyword },
    ["@keyword.conditional.ternary"] = { fg = p.syn_operator },
    ["@keyword.directive"] = { fg = p.syn_keyword },

    ["@punctuation.bracket"] = { fg = p.syn_punctuation },
    ["@punctuation.delimiter"] = { fg = p.syn_punctuation },
    ["@punctuation.special"] = { fg = p.syn_operator },

    ["@comment"] = { fg = p.syn_comment, italic = true },
    ["@comment.documentation"] = { fg = p.syn_comment, italic = true },
    ["@comment.error"] = { fg = p.error, bold = true },
    ["@comment.warning"] = { fg = p.warning, bold = true },
    ["@comment.todo"] = { fg = p.bg, bg = p.accent, bold = true },
    ["@comment.note"] = { fg = p.info, bold = true },

    ["@markup.heading"] = { fg = p.syn_keyword, bold = true },
    ["@markup.heading.1"] = { fg = p.syn_keyword, bold = true },
    ["@markup.heading.2"] = { fg = p.syn_function, bold = true },
    ["@markup.heading.3"] = { fg = p.syn_type, bold = true },
    ["@markup.heading.4"] = { fg = p.syn_namespace },
    ["@markup.heading.5"] = { fg = p.syn_property },
    ["@markup.heading.6"] = { fg = p.syn_comment },
    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.quote"] = { fg = p.syn_comment, italic = true },
    ["@markup.math"] = { fg = p.syn_number },
    ["@markup.link"] = { fg = p.syn_namespace },
    ["@markup.link.url"] = { fg = p.syn_namespace, underline = true },
    ["@markup.link.label"] = { fg = p.accent },
    ["@markup.raw"] = { fg = p.syn_string },
    ["@markup.raw.block"] = { fg = p.fg },
    ["@markup.list"] = { fg = p.syn_punctuation },
    ["@markup.list.checked"] = { fg = p.success },
    ["@markup.list.unchecked"] = { fg = p.fg_subtle },

    ["@tag"] = { fg = p.syn_tag },
    ["@tag.attribute"] = { fg = p.syn_attribute },
    ["@tag.builtin"] = { fg = p.syn_tag },
    ["@tag.delimiter"] = { fg = p.syn_punctuation },

    ["@diff.plus"] = { fg = p.git_added },
    ["@diff.minus"] = { fg = p.git_deleted },
    ["@diff.delta"] = { fg = p.git_modified },
  })

  -- ══════════════════════════════════════════
  -- LSP Semantic Tokens
  -- ══════════════════════════════════════════
  set_highlights({
    ["@lsp.type.class"] = { fg = p.syn_type },
    ["@lsp.type.decorator"] = { fg = p.syn_decorator },
    ["@lsp.type.enum"] = { fg = p.syn_type },
    ["@lsp.type.enumMember"] = { fg = p.syn_constant },
    ["@lsp.type.function"] = { fg = p.syn_function },
    ["@lsp.type.interface"] = { fg = p.syn_type },
    ["@lsp.type.keyword"] = { fg = p.syn_keyword },
    ["@lsp.type.macro"] = { fg = p.syn_decorator },
    ["@lsp.type.method"] = { fg = p.syn_function },
    ["@lsp.type.namespace"] = { fg = p.syn_namespace },
    ["@lsp.type.parameter"] = { fg = p.syn_parameter },
    ["@lsp.type.property"] = { fg = p.syn_property },
    ["@lsp.type.struct"] = { fg = p.syn_type },
    ["@lsp.type.type"] = { fg = p.syn_type },
    ["@lsp.type.typeParameter"] = { fg = p.syn_parameter },
    ["@lsp.type.variable"] = { fg = p.fg },
    ["@lsp.typemod.function.declaration"] = { fg = p.syn_function, bold = true },
    ["@lsp.typemod.function.defaultLibrary"] = { fg = p.syn_namespace },
    ["@lsp.typemod.variable.readonly"] = { fg = p.syn_constant },
    ["@lsp.typemod.variable.constant"] = { fg = p.syn_constant },
    ["@lsp.typemod.variable.defaultLibrary"] = { fg = p.syn_namespace },
    ["@lsp.typemod.keyword.async"] = { fg = p.syn_keyword, italic = true },
    ["@lsp.mod.deprecated"] = { strikethrough = true },
  })

  -- ══════════════════════════════════════════
  -- Diagnostics
  -- ══════════════════════════════════════════
  set_highlights({
    DiagnosticError = { fg = p.error },
    DiagnosticWarn = { fg = p.warning },
    DiagnosticInfo = { fg = p.info },
    DiagnosticHint = { fg = p.success },
    DiagnosticOk = { fg = p.success },
    DiagnosticUnderlineError = { undercurl = true, sp = p.error },
    DiagnosticUnderlineWarn = { undercurl = true, sp = p.warning },
    DiagnosticUnderlineInfo = { undercurl = true, sp = p.info },
    DiagnosticUnderlineHint = { undercurl = true, sp = p.success },
    DiagnosticVirtualTextError = { fg = p.error, bg = p.bg_inset },
    DiagnosticVirtualTextWarn = { fg = p.warning, bg = p.bg_inset },
    DiagnosticVirtualTextInfo = { fg = p.info, bg = p.bg_inset },
    DiagnosticVirtualTextHint = { fg = p.success, bg = p.bg_inset },
    DiagnosticSignError = { fg = p.error },
    DiagnosticSignWarn = { fg = p.warning },
    DiagnosticSignInfo = { fg = p.info },
    DiagnosticSignHint = { fg = p.success },
    DiagnosticFloatingError = { fg = p.error },
    DiagnosticFloatingWarn = { fg = p.warning },
    DiagnosticFloatingInfo = { fg = p.info },
    DiagnosticFloatingHint = { fg = p.success },
  })

  -- ══════════════════════════════════════════
  -- Git Signs
  -- ══════════════════════════════════════════
  set_highlights({
    GitSignsAdd = { fg = p.git_added },
    GitSignsChange = { fg = p.git_modified },
    GitSignsDelete = { fg = p.git_deleted },
    GitSignsCurrentLineBlame = { fg = p.fg_subtle, italic = true },
  })

  -- ══════════════════════════════════════════
  -- Telescope
  -- ══════════════════════════════════════════
  set_highlights({
    TelescopeNormal = { fg = p.fg, bg = p.bg_surface },
    TelescopeBorder = { fg = p.border_strong, bg = p.bg_surface },
    TelescopeTitle = { fg = p.accent, bold = true },
    TelescopePromptNormal = { fg = p.fg, bg = p.bg_inset },
    TelescopePromptBorder = { fg = p.border_strong, bg = p.bg_inset },
    TelescopePromptTitle = { fg = p.bg, bg = p.accent, bold = true },
    TelescopePromptPrefix = { fg = p.accent },
    TelescopePromptCounter = { fg = p.fg_muted },
    TelescopePreviewNormal = { fg = p.fg, bg = p.bg },
    TelescopePreviewBorder = { fg = p.border, bg = p.bg },
    TelescopePreviewTitle = { fg = p.accent },
    TelescopeResultsNormal = { fg = p.fg_muted, bg = p.bg_surface },
    TelescopeResultsBorder = { fg = p.border_strong, bg = p.bg_surface },
    TelescopeSelection = { fg = p.fg, bg = p.bg_inset },
    TelescopeSelectionCaret = { fg = p.accent },
    TelescopeMatching = { fg = p.accent, bold = true },
    TelescopeMultiIcon = { fg = p.magenta },
    TelescopeMultiSelection = { fg = p.magenta },
  })

  -- ══════════════════════════════════════════
  -- Neo-tree
  -- ══════════════════════════════════════════
  set_highlights({
    NeoTreeNormal = { fg = p.fg_muted, bg = p.bg_alt },
    NeoTreeNormalNC = { fg = p.fg_muted, bg = p.bg_alt },
    NeoTreeDirectoryName = { fg = p.accent },
    NeoTreeDirectoryIcon = { fg = p.accent },
    NeoTreeRootName = { fg = p.accent, bold = true },
    NeoTreeFileName = { fg = p.fg_muted },
    NeoTreeFileNameOpened = { fg = p.accent },
    NeoTreeGitAdded = { fg = p.git_added },
    NeoTreeGitModified = { fg = p.git_modified },
    NeoTreeGitDeleted = { fg = p.git_deleted },
    NeoTreeGitUntracked = { fg = p.git_added },
    NeoTreeGitIgnored = { fg = p.fg_subtle },
    NeoTreeGitConflict = { fg = p.warning },
    NeoTreeIndentMarker = { fg = p.border },
    NeoTreeExpander = { fg = p.fg_subtle },
    NeoTreeWinSeparator = { fg = p.border, bg = p.bg_alt },
    NeoTreeCursorLine = { bg = p.bg_surface },
    NeoTreeDimText = { fg = p.fg_subtle },
    NeoTreeDotfile = { fg = p.fg_subtle },
    NeoTreeFloatBorder = { fg = p.border_strong },
    NeoTreeFloatTitle = { fg = p.accent, bold = true },
    NeoTreeTitleBar = { fg = p.bg, bg = p.accent },
  })

  -- ══════════════════════════════════════════
  -- Which Key
  -- ══════════════════════════════════════════
  set_highlights({
    WhichKey = { fg = p.accent },
    WhichKeyGroup = { fg = p.syn_namespace },
    WhichKeyDesc = { fg = p.fg_muted },
    WhichKeySeparator = { fg = p.fg_subtle },
    WhichKeyFloat = { bg = p.bg_surface },
    WhichKeyBorder = { fg = p.border_strong },
    WhichKeyValue = { fg = p.fg_subtle },
  })

  -- ══════════════════════════════════════════
  -- CMP (completion)
  -- ══════════════════════════════════════════
  set_highlights({
    CmpItemAbbr = { fg = p.fg },
    CmpItemAbbrDeprecated = { fg = p.fg_subtle, strikethrough = true },
    CmpItemAbbrMatch = { fg = p.accent, bold = true },
    CmpItemAbbrMatchFuzzy = { fg = p.accent },
    CmpItemKind = { fg = p.fg_muted },
    CmpItemMenu = { fg = p.fg_subtle },
    CmpItemKindClass = { fg = p.syn_type },
    CmpItemKindColor = { fg = p.syn_number },
    CmpItemKindConstant = { fg = p.syn_constant },
    CmpItemKindConstructor = { fg = p.syn_type },
    CmpItemKindEnum = { fg = p.syn_type },
    CmpItemKindEnumMember = { fg = p.syn_constant },
    CmpItemKindEvent = { fg = p.syn_function },
    CmpItemKindField = { fg = p.syn_property },
    CmpItemKindFile = { fg = p.fg },
    CmpItemKindFolder = { fg = p.accent },
    CmpItemKindFunction = { fg = p.syn_function },
    CmpItemKindInterface = { fg = p.syn_type },
    CmpItemKindKeyword = { fg = p.syn_keyword },
    CmpItemKindMethod = { fg = p.syn_function },
    CmpItemKindModule = { fg = p.syn_namespace },
    CmpItemKindOperator = { fg = p.syn_operator },
    CmpItemKindProperty = { fg = p.syn_property },
    CmpItemKindReference = { fg = p.syn_namespace },
    CmpItemKindSnippet = { fg = p.magenta },
    CmpItemKindStruct = { fg = p.syn_type },
    CmpItemKindText = { fg = p.fg },
    CmpItemKindTypeParameter = { fg = p.syn_parameter },
    CmpItemKindUnit = { fg = p.syn_number },
    CmpItemKindValue = { fg = p.syn_constant },
    CmpItemKindVariable = { fg = p.fg },
  })

  -- ══════════════════════════════════════════
  -- Indent Blankline
  -- ══════════════════════════════════════════
  set_highlights({
    IblIndent = { fg = p.border },
    IblScope = { fg = p.accent_dim },
    IndentBlanklineChar = { fg = p.border },
    IndentBlanklineContextChar = { fg = p.accent_dim },
  })

  -- ══════════════════════════════════════════
  -- Noice & Notify
  -- ══════════════════════════════════════════
  set_highlights({
    NoiceCmdline = { fg = p.fg },
    NoiceCmdlineIcon = { fg = p.accent },
    NoiceCmdlinePopup = { fg = p.fg, bg = p.bg_surface },
    NoiceCmdlinePopupBorder = { fg = p.border_strong },
    NoiceMini = { fg = p.fg_muted, bg = p.bg_alt },
    NoiceConfirm = { bg = p.bg_surface },
    NoiceConfirmBorder = { fg = p.accent },

    NotifyERRORBorder = { fg = p.error },
    NotifyERRORIcon = { fg = p.error },
    NotifyERRORTitle = { fg = p.error },
    NotifyWARNBorder = { fg = p.warning },
    NotifyWARNIcon = { fg = p.warning },
    NotifyWARNTitle = { fg = p.warning },
    NotifyINFOBorder = { fg = p.info },
    NotifyINFOIcon = { fg = p.info },
    NotifyINFOTitle = { fg = p.info },
    NotifyDEBUGBorder = { fg = p.fg_subtle },
    NotifyDEBUGIcon = { fg = p.fg_subtle },
    NotifyDEBUGTitle = { fg = p.fg_subtle },
    NotifyTRACEBorder = { fg = p.magenta },
    NotifyTRACEIcon = { fg = p.magenta },
    NotifyTRACETitle = { fg = p.magenta },
  })

  -- ══════════════════════════════════════════
  -- Dashboard / Alpha
  -- ══════════════════════════════════════════
  set_highlights({
    DashboardHeader = { fg = p.accent },
    DashboardFooter = { fg = p.fg_subtle, italic = true },
    DashboardDesc = { fg = p.fg_muted },
    DashboardKey = { fg = p.accent },
    DashboardIcon = { fg = p.accent },
    DashboardShortCut = { fg = p.accent },
    AlphaHeader = { fg = p.accent },
    AlphaFooter = { fg = p.fg_subtle },
    AlphaButtons = { fg = p.fg_muted },
    AlphaShortcut = { fg = p.accent },
  })

  -- ══════════════════════════════════════════
  -- Bufferline
  -- ══════════════════════════════════════════
  set_highlights({
    BufferLineFill = { bg = p.bg_alt },
    BufferLineBackground = { fg = p.fg_subtle, bg = p.bg_alt },
    BufferLineBuffer = { fg = p.fg_subtle, bg = p.bg_alt },
    BufferLineBufferSelected = { fg = p.fg, bg = p.bg, bold = true },
    BufferLineBufferVisible = { fg = p.fg_muted, bg = p.bg },
    BufferLineTab = { fg = p.fg_subtle, bg = p.bg_alt },
    BufferLineTabSelected = { fg = p.fg, bg = p.bg },
    BufferLineIndicatorSelected = { fg = p.accent },
    BufferLineSeparator = { fg = p.bg_alt, bg = p.bg_alt },
    BufferLineModified = { fg = p.git_modified },
    BufferLineModifiedSelected = { fg = p.git_modified },
    BufferLineError = { fg = p.error },
    BufferLineWarning = { fg = p.warning },
    BufferLineInfo = { fg = p.info },
    BufferLineHint = { fg = p.success },
  })

  -- ══════════════════════════════════════════
  -- Mini (various)
  -- ══════════════════════════════════════════
  set_highlights({
    MiniCursorword = { bg = p.bg_inset },
    MiniCursorwordCurrent = { bg = p.bg_inset },
    MiniIndentscopeSymbol = { fg = p.accent_dim },
    MiniJump = { fg = p.bg, bg = p.accent },
    MiniJump2dSpot = { fg = p.accent, bold = true },
    MiniStarterCurrent = { fg = p.accent },
    MiniStarterHeader = { fg = p.accent },
    MiniStarterFooter = { fg = p.fg_subtle },
    MiniStarterItem = { fg = p.fg_muted },
    MiniStarterItemBullet = { fg = p.accent },
    MiniStarterItemPrefix = { fg = p.accent },
    MiniStarterSection = { fg = p.accent, bold = true },
    MiniStarterQuery = { fg = p.accent, bold = true },
    MiniStatuslineFilename = { fg = p.fg_muted },
    MiniStatuslineDevinfo = { fg = p.fg_muted, bg = p.bg_inset },
    MiniStatuslineFileinfo = { fg = p.fg_muted, bg = p.bg_inset },
    MiniStatuslineModeNormal = { fg = p.bg, bg = p.accent, bold = true },
    MiniStatuslineModeInsert = { fg = p.bg, bg = p.green, bold = true },
    MiniStatuslineModeVisual = { fg = p.bg, bg = p.magenta, bold = true },
    MiniStatuslineModeReplace = { fg = p.bg, bg = p.red, bold = true },
    MiniStatuslineModeCommand = { fg = p.bg, bg = p.yellow, bold = true },
    MiniSurround = { fg = p.bg, bg = p.accent },
    MiniTablineCurrent = { fg = p.fg, bg = p.bg, bold = true },
    MiniTablineFill = { bg = p.bg_alt },
    MiniTablineVisible = { fg = p.fg_muted, bg = p.bg },
    MiniTablineHidden = { fg = p.fg_subtle, bg = p.bg_alt },
    MiniTablineModifiedCurrent = { fg = p.git_modified, bg = p.bg },
    MiniTablineModifiedHidden = { fg = p.git_modified, bg = p.bg_alt },
    MiniTablineModifiedVisible = { fg = p.git_modified, bg = p.bg },
  })

  -- ══════════════════════════════════════════
  -- Flash.nvim
  -- ══════════════════════════════════════════
  set_highlights({
    FlashLabel = { fg = p.bg, bg = p.accent, bold = true },
    FlashMatch = { fg = p.fg_muted },
    FlashCurrent = { fg = p.fg },
    FlashBackdrop = { fg = p.fg_subtle },
  })

  -- ══════════════════════════════════════════
  -- Trouble
  -- ══════════════════════════════════════════
  set_highlights({
    TroubleNormal = { fg = p.fg, bg = p.bg_alt },
    TroubleNormalNC = { fg = p.fg_muted, bg = p.bg_alt },
    TroubleText = { fg = p.fg_muted },
    TroubleCount = { fg = p.accent, bg = p.bg_inset },
    TroubleFile = { fg = p.accent },
    TroubleFoldIcon = { fg = p.fg_subtle },
    TroubleLocation = { fg = p.fg_subtle },
    TroubleIndent = { fg = p.border },
    TroubleCode = { fg = p.fg_subtle },
    TroubleSignError = { fg = p.error },
    TroubleSignWarning = { fg = p.warning },
    TroubleSignInformation = { fg = p.info },
    TroubleSignHint = { fg = p.success },
  })

  -- ══════════════════════════════════════════
  -- Todo Comments
  -- ══════════════════════════════════════════
  set_highlights({
    TodoBgFIX = { fg = p.bg, bg = p.error, bold = true },
    TodoBgHACK = { fg = p.bg, bg = p.warning, bold = true },
    TodoBgNOTE = { fg = p.bg, bg = p.info, bold = true },
    TodoBgPERF = { fg = p.bg, bg = p.magenta, bold = true },
    TodoBgTODO = { fg = p.bg, bg = p.accent, bold = true },
    TodoBgWARN = { fg = p.bg, bg = p.warning, bold = true },
    TodoFgFIX = { fg = p.error },
    TodoFgHACK = { fg = p.warning },
    TodoFgNOTE = { fg = p.info },
    TodoFgPERF = { fg = p.magenta },
    TodoFgTODO = { fg = p.accent },
    TodoFgWARN = { fg = p.warning },
    TodoSignFIX = { fg = p.error },
    TodoSignHACK = { fg = p.warning },
    TodoSignNOTE = { fg = p.info },
    TodoSignPERF = { fg = p.magenta },
    TodoSignTODO = { fg = p.accent },
    TodoSignWARN = { fg = p.warning },
  })

  -- ══════════════════════════════════════════
  -- Lazy.nvim (plugin manager)
  -- ══════════════════════════════════════════
  set_highlights({
    LazyH1 = { fg = p.bg, bg = p.accent, bold = true },
    LazyH2 = { fg = p.accent, bold = true },
    LazyButton = { fg = p.fg_muted, bg = p.bg_inset },
    LazyButtonActive = { fg = p.bg, bg = p.accent },
    LazyComment = { fg = p.fg_subtle },
    LazyCommit = { fg = p.fg_subtle },
    LazyCommitType = { fg = p.accent },
    LazyDimmed = { fg = p.fg_subtle },
    LazyDir = { fg = p.accent },
    LazyNormal = { fg = p.fg, bg = p.bg_alt },
    LazyProgressDone = { fg = p.accent },
    LazyProgressTodo = { fg = p.border },
    LazyProp = { fg = p.syn_property },
    LazyReasonCmd = { fg = p.syn_function },
    LazyReasonEvent = { fg = p.syn_namespace },
    LazyReasonFt = { fg = p.syn_string },
    LazyReasonKeys = { fg = p.syn_keyword },
    LazyReasonPlugin = { fg = p.syn_type },
    LazyReasonSource = { fg = p.fg_subtle },
    LazyReasonStart = { fg = p.success },
    LazySpecial = { fg = p.magenta },
    LazyTaskOutput = { fg = p.fg },
    LazyUrl = { fg = p.syn_namespace, underline = true },
    LazyValue = { fg = p.syn_string },
  })

  -- ══════════════════════════════════════════
  -- Mason
  -- ══════════════════════════════════════════
  set_highlights({
    MasonNormal = { fg = p.fg, bg = p.bg_alt },
    MasonHeader = { fg = p.bg, bg = p.accent, bold = true },
    MasonHeaderSecondary = { fg = p.bg, bg = p.info, bold = true },
    MasonHighlight = { fg = p.accent },
    MasonHighlightBlock = { fg = p.bg, bg = p.accent },
    MasonHighlightBlockBold = { fg = p.bg, bg = p.accent, bold = true },
    MasonMuted = { fg = p.fg_subtle },
    MasonMutedBlock = { fg = p.fg_muted, bg = p.bg_inset },
  })

  -- ══════════════════════════════════════════
  -- Snacks.nvim
  -- ══════════════════════════════════════════
  set_highlights({
    SnacksIndent = { fg = p.border },
    SnacksIndentScope = { fg = p.accent_dim },
    SnacksDashboardNormal = { fg = p.fg, bg = p.bg },
    SnacksDashboardHeader = { fg = p.accent },
    SnacksDashboardFooter = { fg = p.fg_subtle, italic = true },
    SnacksDashboardDesc = { fg = p.fg_muted },
    SnacksDashboardKey = { fg = p.accent, bold = true },
    SnacksDashboardIcon = { fg = p.accent },
    SnacksDashboardFile = { fg = p.fg_muted },
    SnacksDashboardDir = { fg = p.fg_subtle },
    SnacksDashboardSpecial = { fg = p.magenta },
    SnacksDashboardTitle = { fg = p.accent, bold = true },
    SnacksNotifierInfo = { fg = p.info },
    SnacksNotifierWarn = { fg = p.warning },
    SnacksNotifierError = { fg = p.error },
    SnacksNotifierDebug = { fg = p.fg_subtle },
    SnacksNotifierTrace = { fg = p.magenta },
  })
end

return M

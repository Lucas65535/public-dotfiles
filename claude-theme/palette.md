# Claude Code — Unified Color Palette Specification

> 本文档是所有终端工具配色的**唯一真实来源 (Single Source of Truth)**。
> 新增工具时请直接引用此文档中的色值。

## 设计理念

- **主色系**: Anthropic Claude 品牌陶土橙 — 温暖、专业、有质感
- **Dark 背景**: Claude Code 官方暖黑 `#141413`
- **Light 背景**: Kaku 奶黄 `#FFFCF0` — 比 Claude Code 原版更温暖，护眼
- **紫色点缀**: 来自 Kaku Aura 系 `#9B87F5`，用作 Magenta / Decorator
- **色温统一**: 所有颜色维持暖色调 (hue ≈ 25°–45°)

---

## Dark Palette

### Background Layers

| Token | Hex | Usage |
|-------|-----|-------|
| `bg` | `#141413` | 主背景 |
| `bg_alt` | `#1A1917` | 侧栏、面板 |
| `bg_surface` | `#1F1D1A` | 浮层、弹窗 |
| `bg_inset` | `#2B2A27` | 嵌入区域 |
| `bg_highlight` | `#332F29` | 当前行高亮 |

### Foreground Layers

| Token | Hex | Usage |
|-------|-----|-------|
| `fg` | `#EAE7DF` | 主文字 |
| `fg_muted` | `#A9A39A` | 次级文字 |
| `fg_subtle` | `#6B665F` | 提示、注释 |

### Border

| Token | Hex | Usage |
|-------|-----|-------|
| `border` | `#4A473F` | 分割线 |
| `border_strong` | `#6B665F` | 强调分割 |

### Accent (Terracotta)

| Token | Hex | Usage |
|-------|-----|-------|
| `accent` | `#D4967E` | 主强调色 (光标、链接) |
| `accent_hover` | `#E0AB96` | 悬停态 |
| `accent_dim` | `#CC785C` | 次强调 |

### ANSI Colors (0–15)

| # | Name | Normal | Bright |
|---|------|--------|--------|
| 0/8 | Black | `#1A1917` | `#6B665F` |
| 1/9 | Red | `#D47563` | `#F09884` |
| 2/10 | Green | `#9ACA86` | `#B6E0A5` |
| 3/11 | Yellow | `#E8C96B` | `#F2D98F` |
| 4/12 | Blue | `#61AAF2` | `#A2D2FF` |
| 5/13 | Magenta | `#9B87F5` | `#C9BCFF` |
| 6/14 | Cyan | `#8CC4FF` | `#BDE0FF` |
| 7/15 | White | `#D9D5CC` | `#F5F2E9` |

### Syntax Highlighting

| Token | Hex | Usage |
|-------|-----|-------|
| `syn_keyword` | `#E2A48B` | 关键字 — 温暖陶土 |
| `syn_string` | `#B5E6A0` | 字符串 — 柔绿 |
| `syn_function` | `#FFC1A6` | 函数 — 珊瑚橙 |
| `syn_type` | `#AFCCF8` | 类型 — 淡蓝 |
| `syn_number` | `#F4DC90` | 数字 — 暖黄 |
| `syn_comment` | `#B8AFA3` | 注释 — 暖灰 |
| `syn_constant` | `#FFB19D` | 常量 — 浅珊瑚 |
| `syn_decorator` | `#9B87F5` | 装饰器 — 紫 |
| `syn_property` | `#F6DDCD` | 属性 — 暖白偏粉 |
| `syn_parameter` | `#F0CDBA` | 参数 — 淡陶土 |
| `syn_operator` | `#E2D8CC` | 操作符 |
| `syn_punctuation` | `#C6BDB2` | 标点 |
| `syn_tag` | `#D9645B` | HTML 标签 — 红 |
| `syn_attribute` | `#F6DFC7` | HTML 属性 |
| `syn_regexp` | `#FBE7AA` | 正则 — 暖黄 |
| `syn_namespace` | `#61AAF2` | 命名空间 — 蓝 |

### Status Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `error` | `#D47563` | 错误 |
| `warning` | `#E8C96B` | 警告 |
| `success` | `#9ACA86` | 成功 |
| `info` | `#61AAF2` | 信息 |

### Git Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `git_added` | `#9ACA86` | 新增 |
| `git_modified` | `#E8C96B` | 修改 |
| `git_deleted` | `#D47563` | 删除 |

### Cursor & Selection

| Token | Hex | Usage |
|-------|-----|-------|
| `cursor` | `#D4967E` | 光标 |
| `selection` | `#4E3B33` | 选区 (accent@30% pre-blended over bg) |

---

## Light Palette

### Background Layers (Kaku 暖黄体系)

| Token | Hex | Usage |
|-------|-----|-------|
| `bg` | `#FFFCF0` | 主背景 ← Kaku 奶黄 |
| `bg_alt` | `#F2F0E6` | 侧栏、面板 |
| `bg_surface` | `#F5F3EB` | 浮层、弹窗 |
| `bg_inset` | `#E8E6DB` | 嵌入区域 |
| `bg_highlight` | `#ECE9DF` | 当前行高亮 |

### Foreground Layers

| Token | Hex | Usage |
|-------|-----|-------|
| `fg` | `#1A1917` | 主文字 |
| `fg_muted` | `#6B665F` | 次级文字 |
| `fg_subtle` | `#8D877D` | 提示、注释 |

### Border

| Token | Hex | Usage |
|-------|-----|-------|
| `border` | `#D9D5CC` | 分割线 |
| `border_strong` | `#A9A39A` | 强调分割 |

### Accent (Terracotta)

| Token | Hex | Usage |
|-------|-----|-------|
| `accent` | `#CC785C` | 主强调色 |
| `accent_hover` | `#B85F3D` | 悬停态 |

### ANSI Colors (0–15)

| # | Name | Normal | Bright |
|---|------|--------|--------|
| 0/8 | Black | `#1A1917` | `#8D877D` |
| 1/9 | Red | `#A84B3A` | `#C45F4A` |
| 2/10 | Green | `#2E7C4C` | `#5E8F6D` |
| 3/11 | Yellow | `#8A6220` | `#9C7A39` |
| 4/12 | Blue | `#207FDE` | `#4F79A8` |
| 5/13 | Magenta | `#6A5BCC` | `#6D5DBD` |
| 6/14 | Cyan | `#2E5F99` | `#45809E` |
| 7/15 | White | `#746E64` | `#4A473F` |

### Syntax Highlighting

| Token | Hex | Usage |
|-------|-----|-------|
| `syn_keyword` | `#B84A2A` | 关键字 |
| `syn_string` | `#2D7F4D` | 字符串 |
| `syn_function` | `#AE4E30` | 函数 |
| `syn_type` | `#386290` | 类型 |
| `syn_number` | `#946A1E` | 数字 |
| `syn_comment` | `#6C655D` | 注释 |
| `syn_constant` | `#BD5341` | 常量 |
| `syn_decorator` | `#6A5BCC` | 装饰器 |
| `syn_property` | `#3A6594` | 属性 |
| `syn_parameter` | `#AE6D53` | 参数 |
| `syn_operator` | `#6A645C` | 操作符 |
| `syn_punctuation` | `#877C70` | 标点 |
| `syn_tag` | `#CC5E54` | HTML 标签 |
| `syn_attribute` | `#B46344` | HTML 属性 |
| `syn_regexp` | `#B07C26` | 正则 |
| `syn_namespace` | `#207FDE` | 命名空间 |

### Status / Git / Cursor

| Token | Hex |
|-------|-----|
| `error` | `#A84B3A` |
| `warning` | `#8A6220` |
| `success` | `#2E7C4C` |
| `info` | `#207FDE` |
| `git_added` | `#2E7C4C` |
| `git_modified` | `#8A6220` |
| `git_deleted` | `#A84B3A` |
| `cursor` | `#CC785C` |
| `selection` | `#F5E1D0` | (accent@15% pre-blended over bg)

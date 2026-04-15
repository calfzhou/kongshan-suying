# 空山素影 (Kongshan Suying) - Project Architecture Guide

This document describes how this skin project is structured and how to work with it.
For the Hamster v3 skin format itself, see [SKIN-GUIDE.md](SKIN-GUIDE.md).

---

## 1. Overview

**空山素影** is a Jsonnet-based keyboard skin for [Hamster v3 (元书输入法)](https://ihsiao.com/apps/hamster/v3/), the Rime input method engine's iOS implementation. It generates `.cskin` files containing keyboard layouts for multiple keyboard types, themes (light/dark), and orientations (portrait/landscape).

**Key characteristics:**
- No image resources — native-styled, geometry-based rendering
- Supports 8 keyboard layouts: 26-key, 9-key, 14-key, 17-key, 18-key, Bopomofo, Sigma, and more
- Multiple numeric keyboard variants: 9-grid, row, hex
- Custom extended button syntax (see `jsonnet/Buttons/README.md`)
- Full swipe-up/swipe-down support on all keys
- Configurable accent colors, toolbar buttons, and more via `Settings.libsonnet`

---

## 2. Directory Structure

```
kongshan-suying/
├── README.md               # Skin features, swipe map, build instructions
├── SKIN-GUIDE.md           # AI-friendly Hamster v3 skin format reference
├── PROJECT-GUIDE.md        # This file — project architecture
│
├── jsonnet/                # Source files (Jsonnet)
│   ├── main.jsonnet        # Entry point — generates all output files
│   ├── Settings.libsonnet  # User-facing configuration hub
│   │
│   ├── Buttons/            # Button definitions (data-driven)
│   │   ├── README.md       # Button syntax documentation (Chinese)
│   │   ├── Common.libsonnet        # Shared buttons: space, shift, backspace, enter, etc.
│   │   ├── Layout26.libsonnet      # 26-key QWERTY layout buttons
│   │   ├── Layout9.libsonnet       # 9-key T9 layout buttons
│   │   ├── Layout14.libsonnet      # 14-key layout buttons
│   │   ├── Layout17.libsonnet      # 17-key layout buttons
│   │   ├── Layout18.libsonnet      # 18-key layout buttons
│   │   ├── LayoutBopomofo.libsonnet # Zhuyin (注音) layout buttons
│   │   ├── LayoutSigma.libsonnet   # Sigma pinyin layout buttons
│   │   ├── LayoutNumeric.libsonnet # Numeric keyboard buttons
│   │   └── Toolbar.libsonnet       # Toolbar and floating panel buttons
│   │
│   ├── Components/         # UI assembly and styling logic
│   │   ├── BasicStyle.libsonnet    # Master styling system (button creation, animations)
│   │   ├── Utils.libsonnet         # Utility functions (color handling, layout math)
│   │   ├── iPhonePinyin.libsonnet  # Pinyin keyboard selector (dispatches by layout)
│   │   ├── iPhonePinyin26.libsonnet # 26-key pinyin keyboard assembly
│   │   ├── iPhonePinyin9.libsonnet  # 9-key pinyin keyboard assembly
│   │   ├── iPhonePinyin14.libsonnet
│   │   ├── iPhonePinyin17.libsonnet
│   │   ├── iPhonePinyin18.libsonnet
│   │   ├── iPhonePinyinSigma.libsonnet
│   │   ├── iPhoneBopomofo.libsonnet
│   │   ├── iPhoneAlphabetic.libsonnet  # English keyboard layout
│   │   ├── iPhoneNumeric.libsonnet     # Numeric keyboard selector
│   │   ├── iPhoneNumericRow.libsonnet  # Row-style numeric keyboard
│   │   ├── iPhoneNumericRowEn.libsonnet
│   │   ├── iPhoneNumericHex.libsonnet  # Hex numeric keyboard
│   │   ├── iPhoneNumeric9.libsonnet    # 9-grid numeric keyboard
│   │   ├── Preedit.libsonnet           # Pre-edit text display
│   │   ├── Toolbar.libsonnet           # Toolbar UI component
│   │   └── Panel.libsonnet             # Floating panel component
│   │
│   └── Constants/          # Theme and typography constants
│       ├── Colors.libsonnet    # Color definitions with light/dark variants
│       └── Fonts.libsonnet     # Font size constants
│
├── light/                  # Generated light theme YAML files
│   ├── portraitPinyin.yaml
│   ├── landscapePinyin.yaml
│   ├── portraitAlphabetic.yaml
│   └── ...
│
├── dark/                   # Generated dark theme YAML files
│   ├── portraitPinyin.yaml
│   └── ...
│
└── config.yaml             # Generated root config (maps keyboard types to files)
```

---

## 3. Build Pipeline

```
Settings.libsonnet (user config)
        │
        ▼
   main.jsonnet (entry point)
        │
        ├── Selects layout components based on settings.keyboardLayout
        │
        ▼
   For each combination of:
     • Theme: light / dark
     • Orientation: portrait / landscape
     • Keyboard type: pinyin / alphabetic / numeric / ...
        │
        ▼
   Component files (e.g., iPhonePinyin26.libsonnet)
     └── Import Buttons, BasicStyle, Colors, Fonts
     └── Assemble HStack/VStack layout with styled Cells
        │
        ▼
   Output YAML files → light/ and dark/ directories
   Output config.yaml → root directory
```

**Build on device:** Long-press skin → "运行 main.jsonnet"

**Build on PC:**
```bash
# Windows
jsonnet -S -m . --tla-code debug=true .\jsonnet\main.jsonnet

# macOS/Linux
jsonnet -S -m . --tla-code debug=true ./jsonnet/main.jsonnet
```

---

## 4. Key Configuration File: Settings.libsonnet

This is the primary user-facing configuration file. Key settings include:

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `keyboardLayout` | string | `'26'` | Layout type: `'26'`, `'26b'`, `'9'`, `'14'`, `'17'`, `'18'`, `'bopomofo'`, `'sigma'` |
| `numericLayout` | string | `'9'` | Numeric keyboard: `'9'` (grid), `'row'`, `'hex'` |
| `spaceButtonComposingText` | string | `'选定'` | Space button text during composition. Supports `$rimePreedit`, `$rimeCandidate`, `$rimeCandidateComment` |
| `iPad` | bool | `false` | `true` for iPad, `false` for iPhone |
| `spaceButtonSchemaNameCenter` | object/null | `{x:0.2, y:0.7}` | Position to show RIME schema name on space bar; `null` to hide |
| `swipeUpTextCenter` | string | `'top'` | Swipe hint position: `'hide'`, `'topLeft'`, `'top'`, `'topRight'`, `'bottomLeft'`, `'bottom'`, `'bottomRight'` |
| `swipeDownTextCenter` | string | `'hide'` | Same options as above |
| `toolbarSlideButtons` | array | `[8,17,1,2,3,10,12]` | Toolbar slide button IDs |
| `toolbarSlideButtonsMaxCount` | object | `{portrait:5, landscape:8}` | Max visible toolbar buttons |
| `preferIcon` | bool | `true` | `true` = icons, `false` = text labels |
| `accentColor` | int | `4` | 0=none, 1=red, 2=green, 3=orange, 4=blue, 5=purple |
| `uppercaseForChinese` | bool | `true` | Show uppercase letters in Chinese mode |
| `quickAction` | object | `{character:';'}` | Quick action character |

---

## 5. Extended Button Syntax

This skin defines a custom **extended button syntax** that simplifies button definitions. The syntax is documented in `jsonnet/Buttons/README.md`. Key features:

### Button Structure
```jsonnet
buttonName: {
  name: 'buttonName',
  params: {
    action: { character: 'a' },           // Default action
    uppercased: { action: { character: 'A' } },  // Shift state
    capsLocked: { systemImageName: '...' },       // Caps lock state
    swipeUp: { action: {...}, text: '...' },      // Swipe up
    swipeDown: { action: {...}, text: '...' },    // Swipe down
    longPress: [ ... ],                            // Long-press menu items

    // Conditional state overrides:
    whenAlphabetic: { ... },              // English keyboard overrides
    whenPreeditChanged: { ... },          // During composition overrides
    whenKeyboardAction: [ ... ],          // Action listener overrides
    whenRimeOptionChanged: { ... },       // RIME option change overrides
    whenRimeSchemaChanged: { ... },       // Schema change overrides
  }
}
```

### Text/Icon Auto-Inference
- Foreground display is automatically inferred from `action`
- For non-inferrable actions (like shortcuts), manually specify `text` or `systemImageName`

### Processing Pipeline
`BasicStyle.libsonnet` processes these extended params into the official Hamster v3 format:
1. Generates `backgroundStyle` and `foregroundStyle` from params
2. Creates `notification` entries from `whenXxx` params
3. Sets up `swipeUpAction`/`swipeDownAction` from swipe params
4. Handles light/dark theme color switching via `Utils.setColor()`

---

## 6. Styling Architecture

### Color System (Constants/Colors.libsonnet)
Every color has light/dark variants:
```jsonnet
{
  light: '#FFFFFF',
  dark: '#1C1C1E'
}
```

Key color categories:
- `labelColor.primary/secondary/tertiary/quaternary` — text colors
- `standardButtonBackgroundColor` — letter key backgrounds
- `systemButtonBackgroundColor` — system key backgrounds (return, backspace)
- `colorButtonBackgroundColor` — accent-colored button backgrounds
- `accentColors[0-5]` — theme accent color options

### Font System (Constants/Fonts.libsonnet)
Standard font sizes for different elements:
- `standardButtonTextFontSize: 22.5` — main letter keys
- `alternativeTextFontSize: 10` — swipe hint indicators
- `preeditFontSize: 17` — pre-edit text
- `toolbarButtonTextFontSize: 16` — toolbar buttons

### BasicStyle.libsonnet — Core Styling Engine
Key functions:
- `newAlphabeticButton(name, isDark, params, ...)` — creates letter keys
- `newSystemButton(name, isDark, params)` — creates system keys
- `newColorButton(name, isDark, params)` — creates accent-colored keys
- `newStyleByPriority(isDark, params, ...)` — resolves style with priority chain
- Various `newXxxStyle()` functions for background, foreground, hint text

---

## 7. 26-Key Layout Swipe Map

The default 26-key layout has comprehensive swipe actions:

```
Row 1: 1234567890 (swipe up on qwertyuiop)
Row 2: !^/;(-#{" (swipe up on asdfghjkl)
        `\:)_+}' (swipe down)
        a=select all
Row 3: @*%=[&?   (swipe up on zxcvbnm)
              ]~$ (swipe down)
        z=undo, x=cut, c=copy, v=paste
Special: backspace↑=clear, backspace↓=undo
         123↑=symbols, 123↓=emoji
         comma↑=period
         enter↑=home, enter↓=end, enter long-press=newline
```

---

## 8. Customization Workflow

1. **Quick settings:** Edit `jsonnet/Settings.libsonnet` (accessible via floating panel "微调")
2. **Button behavior:** Edit files in `jsonnet/Buttons/` (accessible via floating panel "按键")
3. **Colors/Themes:** Edit `jsonnet/Constants/Colors.libsonnet`
4. **Font sizes:** Edit `jsonnet/Constants/Fonts.libsonnet`
5. **Layout structure:** Edit `jsonnet/Components/iPhoneXxx.libsonnet` files
6. **Rebuild:** Long-press skin → "运行 main.jsonnet" (or use PC command)

---

## 9. Repository Information

- **Original repo:** <https://github.com/luozikuan/kongshan-suying>
- **Fork (this repo):** Uses `calf` branch for customizations
- **Official Hamster v3 docs:** <https://ihsiao.com/apps/hamster/v3/docs/guides/skins/intro/>

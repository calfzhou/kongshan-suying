# Hamster v3 (元书) Keyboard Skin Format Reference

This document is a comprehensive, AI-friendly reference for the Hamster v3 keyboard skin system.
For official documentation, see <https://ihsiao.com/apps/hamster/v3/docs/guides/skins/intro/>.

---

## 1. Skin File Structure (.cskin)

A `.cskin` file is a **renamed ZIP archive** containing:

```
skin-name.cskin (ZIP)
├── config.yaml          # (required) Root config declaring keyboard types and metadata
├── demo.png             # (required) Preview image
├── README.md            # (optional) User-facing documentation
├── fonts/               # (optional) Custom font files
├── light/               # Light theme keyboard YAML files
│   ├── portraitPinyin.yaml
│   ├── landscapePinyin.yaml
│   ├── portraitAlphabetic.yaml
│   ├── landscapeAlphabetic.yaml
│   ├── portraitNumeric.yaml
│   └── ...
└── dark/                # Dark theme keyboard YAML files
    ├── portraitPinyin.yaml
    └── ...
```

**Note:** Despite having `.yaml` extensions, the keyboard layout files are actually **JSON-formatted**. YAML is a superset of JSON, so JSON content is valid YAML.

---

## 2. Root config.yaml Schema

```yaml
author: "Author Name"
name: "Skin Name"

fontFace:
  - key: "fontKey"
    name: "FontName"
    ranges: ["U+0000-007F"]  # Unicode range support

# Keyboard type declarations - mapping keyboard types to files
# Each keyboard type is declared for each theme (light/dark) and orientation (portrait/landscape)
iPhonePortrait:
  pinyin: "light/portraitPinyin.yaml"
  alphabetic: "light/portraitAlphabetic.yaml"
  numeric: "light/portraitNumeric.yaml"
  # symbolic: (optional, for custom symbol keyboard)
iPhoneLandscape:
  pinyin: "light/landscapePinyin.yaml"
  # ...

# Dark theme variants
iPhonePortraitDark:
  pinyin: "dark/portraitPinyin.yaml"
  # ...
```

**Standard keyboard types:** `pinyin` (Chinese, required), `alphabetic` (English), `numeric`, `symbolic` (optional).

---

## 3. Keyboard Layout File Schema

Each keyboard YAML file defines the complete layout and styling for one keyboard type in one theme/orientation combination.

### 3.1 Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `preeditHeight` | int or string | Pre-edit area height. Can be points (`40`) or viewport height (`"10vh"`) |
| `preeditStyle` | object | Styling for the pre-edit (composition) area |
| `toolbarHeight` | int or string | Toolbar area height |
| `toolbarStyle` | object | Styling for the toolbar area |
| `toolbarLayout` | array | Layout definition for toolbar buttons |
| `keyboardHeight` | int or string | Keys area height |
| `keyboardStyle` | object | Styling for the keyboard background |
| `keyboardLayout` | array | Layout definition for key rows (main area) |
| `horizontalCandidatesStyle` | object | Styling for horizontal candidate bar |
| `horizontalCandidatesLayout` | array | Layout for horizontal candidates |
| `verticalCandidatesStyle` | object | Styling for expanded vertical candidates |
| `verticalCandidatesLayout` | array | Layout for vertical candidates |
| `floatKeyboardLockedState` | bool | Controls floating keyboard auto-hide |
| `floatKeyboardAlpha` | float | Floating keyboard opacity (0.1-1.0) |

### 3.2 Layout System (HStack/VStack)

Layouts use a **hierarchical space-division** system with horizontal (`HStack`) and vertical (`VStack`) stacking:

```yaml
keyboardLayout:
  - HStack:                    # First row (horizontal)
      subviews:
        - Cell: { ... }        # Individual key
        - Cell: { ... }
  - HStack:                    # Second row
      subviews:
        - Cell: { ... }
        - VStack:              # Nested vertical stack
            subviews:
              - Cell: { ... }
              - Cell: { ... }
```

**Constraint:** Cannot mix `HStack` and `VStack` at the same hierarchical level.

**Size control:** Both `HStack`/`VStack` and `Cell` accept a `style` or `size` property for dimension proportions:
- Absolute: `100` (points)
- Ratio: `"1/2"` (percentage of container)
- Object: `{ percentage: 0.5 }`
- Auto: omit for auto-scaling

### 3.3 Cell (Button/Key) Properties

| Property | Type | Description |
|----------|------|-------------|
| `size` | various | Dimensions (see sizing above) |
| `action` | object | Default tap action |
| `swipeUpAction` | object | Upward swipe action |
| `swipeDownAction` | object | Downward swipe action |
| `backgroundStyle` | object/array | Visual background styling |
| `foregroundStyle` | object/array | Foreground content (text, icon, image) |
| `animation` | object | Key press animation |
| `notification` | object | Event-triggered style/action changes |
| `type` | string | Special cell type (see Collection Views below) |

---

## 4. Actions

Actions define what happens when a key is tapped, swiped, or long-pressed.

### 4.1 Input Actions

```yaml
# Character input (through RIME engine for composition)
action: { character: "a" }

# Symbol input (direct system input, bypasses RIME)
action: { symbol: "!" }

# Multiple characters with modifiers
action: { sendKeys: "..." }
```

### 4.2 System Actions

```yaml
action: "space"            # Space key
action: "enter"            # Enter/Return key
action: "tab"              # Tab key
action: "shift"            # Shift toggle
action: "backspace"        # Delete backward
action: "dismissKeyboard"  # Hide keyboard
```

### 4.3 Navigation & Keyboard Switching

```yaml
# Switch keyboard type
action: { keyboardType: "numeric" }
action: { keyboardType: "alphabetic" }
action: { keyboardType: "classifySymbolic" }

# Shortcuts (built-in functions)
action: { shortcut: "#selectText" }      # Select all
action: { shortcut: "#cut" }             # Cut
action: { shortcut: "#copy" }            # Copy
action: { shortcut: "#paste" }           # Paste
action: { shortcut: "#undo" }            # Undo
action: { shortcut: "#redo" }            # Redo
action: { shortcut: "#简繁切换" }         # Simplified/Traditional toggle
action: { shortcut: "#中英切换" }         # Chinese/English toggle
action: { shortcut: "#左手模式" }         # Left-hand mode
action: { shortcut: "#右手模式" }         # Right-hand mode

# Open URL
action: { openURL: "https://..." }

# Run script
action: { runScript: "..." }

# Switch RIME schema
action: { rimeSchema: "schema_id" }
```

---

## 5. Styling System

### 5.1 buttonStyleType (Mandatory in v3)

Every foreground style must specify one of:

| Value | Description |
|-------|-------------|
| `"geometry"` | Native iOS geometric rendering |
| `"systemImage"` | SF Symbols icons (e.g., `"shift"`, `"globe"`) |
| `"assetImage"` | Built-in app image assets |
| `"fileImage"` | Custom image files bundled in the skin |
| `"text"` | Text content (supports dynamic variables) |

### 5.2 Style Properties

```yaml
# Background style
backgroundStyle:
  buttonStyleType: "geometry"
  backgroundColor: "#FFFFFF"        # or gradient (see below)
  cornerRadius: 6
  borderSize: 1
  borderColor: "#CCCCCC"
  shadowRadius: 1
  shadowOffset: { x: 0, y: 1 }
  shadowOpacity: 0.3
  shadowColor: "#000000"
  insets: { top: 2, left: 2, bottom: 2, right: 2 }

# Foreground text style
foregroundStyle:
  buttonStyleType: "text"
  text: "A"
  fontSize: 22
  fontWeight: "regular"             # ultraLight|thin|light|regular|medium|semibold|bold|heavy|black
  foregroundColor: "#000000"

# Foreground icon style
foregroundStyle:
  buttonStyleType: "systemImage"
  systemImageName: "globe"
  fontSize: 18
  foregroundColor: "#000000"
```

### 5.3 Colors & Gradients

```yaml
# Solid color
backgroundColor: "#RRGGBB"
backgroundColor: "#RRGGBBAA"       # with alpha

# Gradient
backgroundColor:
  - locations: [0, 1]
    startPoint: { x: 0, y: 0 }
    endPoint: { x: 0, y: 1 }
    type: "axial"                  # axial | conic | radial
    colors: ["#FF0000", "#0000FF"]
```

### 5.4 Highlighted (Pressed) State

Styles can have separate normal and highlighted (pressed) variants using `highlightedXxx` counterparts or state-based styling.

### 5.5 Text Position (Bounds/Center)

```yaml
foregroundStyle:
  buttonStyleType: "text"
  text: "A"
  bounds:
    alignment: "center"            # center | left | rightTop | etc.
    center: { x: 0.5, y: 0.5 }   # normalized coordinates (0-1)
```

### 5.6 Dynamic Text Variables

| Variable | Description |
|----------|-------------|
| `$rimePreedit` | Current pre-edit text from RIME engine |
| `$rimeCandidate` | Current selected candidate |
| `$rimeCandidateComment` | Comment for current candidate |

---

## 6. Collection Views (Special Cell Types)

| Type | Description |
|------|-------------|
| `"symbols"` | Vertical symbol list |
| `"classifiedSymbols"` | Categorized symbol groups |
| `"horizontalSymbols"` | Horizontal scrollable symbols |
| `"horizontalCandidates"` | Horizontal candidate characters |
| `"verticalCandidates"` | Vertical expanded candidates |

```yaml
Cell:
  type: "horizontalCandidates"
  size: { ... }
  cellStyle: { ... }               # Individual cell appearance
  dataSource: [...]                 # Optional data array
```

---

## 7. Animations

### 7.1 Scale Animation
```yaml
animation:
  type: "scale"
  scale: 0.95
  pressDuration: 0.1
  releaseDuration: 0.15
```

### 7.2 Cartoon Animation (Frame Sequence)
```yaml
animation:
  type: "cartoon"
  fps: 24
  scale: 1.0
  # frames defined as image sequence
```

### 7.3 Physics Animation
```yaml
animation:
  type: "physics"
  # Position, rotation, opacity transitions
```

---

## 8. Event Notifications (Dynamic State Changes)

Buttons can listen to events and change their appearance/behavior:

### 8.1 RIME Notifications (Input Method State)
```yaml
notification:
  rime:
    optionName: "ascii_mode"
    optionValue: true              # When English mode is active
  backgroundStyle: { ... }        # New background in this state
  foregroundStyle: { ... }        # New foreground in this state
  action: { ... }                 # New action in this state
```

### 8.2 Keyboard Action Notifications
```yaml
notification:
  keyboardAction:
    shortcut: "#selectText"
  backgroundStyle: { ... }
  foregroundStyle: { ... }
  action: { shortcut: "#cut" }
  lockedNotificationMatchState: false  # true = stay changed; false = revert after action
```

### 8.3 Return Key Type Notifications
```yaml
notification:
  returnKeyType: "search"         # Matches system return key type
  foregroundStyle: { ... }
```

### 8.4 Preedit Change Notifications
```yaml
notification:
  preeditChanged: true
  foregroundStyle: { ... }
  action: { ... }
```

---

## 9. Long-Press Configuration (v3)

```yaml
hintSymbolsStyle: { ... }         # Styling for the long-press hint/bubble
symbolStyles: { ... }             # Configuration for symbols in long-press menu
```

---

## 10. Sprite Sheet System (Image-Based Skins)

For skins using custom images:

```yaml
# Companion YAML defines image regions
imageName:
  rect: { x: 0, y: 0, width: 100, height: 50 }
  insets: { top: 5, bottom: 5, left: 5, right: 5 }  # Non-stretchable zones
```

---

## 11. Key Differences from v2 (Migration Notes)

| Change | v2 | v3 |
|--------|----|----|
| buttonStyleType | optional | **mandatory** |
| Text alignment | manual | defaults to center |
| JavaScript | supported | **abolished** - use notifications |
| Long-press style | `holdSymbolsStyle` | `hintSymbolsStyle` + `symbolStyles` |
| Animations | defined in styles | defined at key level |
| Toolbar/candidates | combined | restructured into separate areas |

---

## 12. Jsonnet Usage for Skin Development

Hamster v3 supports **Jsonnet** as a templating language for generating skin configurations. Jsonnet compiles to JSON/YAML, enabling:

- Variables and constants for consistent theming
- Functions for reusable button/style definitions
- Conditionals for light/dark theme and portrait/landscape variations
- Imports for modular file organization

**Build command (on device):** Long-press skin, select "运行 main.jsonnet"

**Build command (PC):**
```bash
jsonnet -S -m . --tla-code debug=true ./jsonnet/main.jsonnet
```

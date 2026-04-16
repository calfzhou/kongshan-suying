# Build Instructions

## Prerequisites

Three tools are needed to build the `.cskin` package:

| Tool | Purpose | macOS | Ubuntu | Windows |
|------|---------|-------|--------|---------|
| `jsonnet` | Compile skin source to YAML | `brew install jsonnet` | `sudo apt install jsonnet` | `scoop install jsonnet` or [download binary](https://github.com/google/go-jsonnet/releases) |
| `rsvg-convert` | Convert SVG to PNG (demo image) | `brew install librsvg` | `sudo apt install librsvg2-bin` | `pacman -S mingw-w64-x86_64-librsvg` (MSYS2) |
| `zip` | Package `.cskin` archive | pre-installed | `sudo apt install zip` | pre-installed in Git Bash |

## Usage

```bash
# Build .cskin package (runs jsonnet + demo.png + zip)
make

# Only generate keyboard YAML files
make jsonnet

# Only generate demo.png
make demo.png

# Clean all generated files
make clean
```

## Version Detection

The Makefile auto-detects the version from git tags:
- If the current commit has a tag (e.g., `v1.0`), uses that as the version.
- Otherwise, uses `preview`.

The version appears in the demo image and the output filename (`kongshan-suying-calf-<version>.cskin`).
Inside the archive, the skin folder name remains Chinese (`空山素影-calf` or `空山素影-calf-preview`) so Hamster v3 shows the expected skin name.

## On-Device Build

The keyboard YAML files can also be built directly in the Hamster v3 (元书) app:
long-press the skin, select "运行 main.jsonnet".

This only regenerates the keyboard layouts — it does not rebuild `demo.png` or repackage the `.cskin`.

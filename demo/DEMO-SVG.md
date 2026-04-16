# How to Update demo.svg When Source Images Change

This document explains how to recalculate the values in `demo/demo.svg` when `light.png` or `dark.png` change dimensions (e.g., screenshots from a different device).

Both images must have the **same dimensions**.

## SVG Layout (Fixed)

These values are stable and do not change when images change:

| Property | Value | Notes |
|----------|-------|-------|
| SVG canvas | 996 × 770 | Overall size, also the output PNG size |
| Background | white | |
| Visible image area | 790 × 548 | Images scaled to 790w, cropped to 548h |
| Image x position | 103 | Horizontal center: (996 - 790) / 2 |
| Clip top-left | (103, 152) | Derived: 700 - 548 = 152 |
| Clip bottom-right | (893, 700) | Derived: 770 - 70 = 700 (bottom margin 70px) |
| Title text y | 80 | Vertically centered in top white area (152 / 2 ≈ 76, rounded to 80) |
| Mask triangle | (103,152) (893,152) (893,700) | Upper-right triangle, stable with clip region |

## Values That Need Updating

When source images change, **three values** in the SVG need recalculating:

1. **`height`** on both `<image>` elements
2. **`y`** on both `<image>` elements

### Input Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `SRC_W` | Source image width (pixels) | 1206 |
| `SRC_H` | Source image height (pixels) | 2622 |
| `CROP_BOTTOM` | Pixels to remove from bottom of scaled image (user-provided) | 135 |

### Calculation

```
SCALE        = 790 / SRC_W
SCALED_H     = round(SRC_H × SCALE)
SKIP_TOP     = SCALED_H - CROP_BOTTOM - 548
IMAGE_Y      = 152 - SKIP_TOP
```

The two `<image>` elements should be updated to:
```
width="790" height="SCALED_H"
x="103" y="IMAGE_Y"
```

### Quick Reference (Python one-liner)

```bash
python3 -c "
W=1206; H=2622; CROP=135  # ← update these three values
sh=round(H*790/W); y=152-(sh-CROP-548)
print(f'<image> width=790 height={sh} x=103 y={y}')
"
```

### Example

For source 1206×2622, crop bottom 135px:

```
SCALE    = 790 / 1206 = 0.6550...
SCALED_H = round(2622 × 0.6550) = 1718
SKIP_TOP = 1718 - 135 - 548 = 1035
IMAGE_Y  = 152 - 1035 = -883
```

→ Update both `<image>` elements: `width="790" height="1718" x="103" y="-883"`

### What to Edit in demo.svg

Lines to update (both dark and light images use the same values):

```xml
  <image xlink:href="dark.png" x="103" y="IMAGE_Y"
         width="790" height="SCALED_H"
         clip-path="url(#img-clip)"/>

  <image xlink:href="light.png" x="103" y="IMAGE_Y"
         width="790" height="SCALED_H"
         clip-path="url(#img-clip)" mask="url(#light-mask)"/>
```

Also update the comment block in `<defs>` to reflect the new source dimensions and calculations.

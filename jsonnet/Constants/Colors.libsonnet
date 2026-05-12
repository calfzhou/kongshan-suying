local settings = import '../Settings.libsonnet';

// 本文件中的颜色使用 #rrggbb 或 #rrggbbaa 格式的十六进制字符串表示
// 其中 rr、gg、bb 分别表示红、绿、蓝三种颜色的强度，范围是 00 到 FF（十六进制）
// aa 表示 alpha 通道的值，范围也是 00 到 FF，00 表示完全透明，FF 表示完全不透明（此时可以省略 alpha 通道）
// 注意：aa 为 00 时颜色完全透明，会使按键不可点击，建议至少使用 01

// 标签颜色常量定义
local labelColor = {
  primary: {
    light: '#000000',
    dark: '#FFFFFF',
  },
  secondary: {
    light: '#8a8a8a',
    # colorful 模式下，按键背景偏亮，原本的灰色滑动提示文字在彩色背景上对比度偏低，
    # 这里在 colorful 时调亮一档以保证可读性；plain 模式仍沿用原配色。
    dark: if settings.buttonColorTheme == 'colorful' then '#e0e0e0' else '#b6b7b9',
  },
  tertiary: {
    light: '#c4c4c4',
    dark: '#5d5d5d',
  },
  quaternary: {
    light: '#dcdcdc',
    dark: '#404040',
  },
};

// 分割线颜色
local separatorColor = {
  light: '#C6C6C8',
  dark: '#38383A',
};

// 键盘背景色
local keyboardBackgroundColor = {
  light: '#ffffff03',
  dark: '#00000003',
};

// 标准按键背景色（如字母按键、空格键等）
local standardButtonBackgroundColor = {
  light: '#FFFFFF',
  dark: '#D1D1D165',
};

// 字母 / 数字 / 符号键的彩色配色表（仅 buttonColorTheme == 'colorful' 时生效）
// 配色取自 community/colorful-by-jiong 分支：
//   - 字母键按行 / 位置上色，元音类（a/u/i/o/v）用暖橙；
//     特殊键 q/f 红粉、w/j 橙黄；其余按位置铺陈中性色。
//   - 数字 0-9 与 QWERTY 物理键盘对应字母同色（1↔q, 2↔w, …, 9↔p, 0↔y）。
//   - 横向数字键盘上的常用符号同样借用相邻字母色。
//   - 数字 0-9 与 QWERTY 物理键盘对应字母同色（1↔q, 2↔w, …, 9↔p, 0↔y）。
//   - 横向数字键盘上的常用符号同样借用相邻字母色。
local letterColors =
  {
    # 第一行
    q: { light: '#F79781', dark: '#EB3855' },
    w: { light: '#F8B285', dark: '#FF9800' },
    e: { light: '#E1F1F2', dark: '#00BCD4' },
    r: { light: '#F6F9D1', dark: '#A59460' },
    t: { light: '#F6F9D1', dark: '#A59460' },
    y: { light: '#F6F9D1', dark: '#A59460' },
    u: { light: '#F8E2C2', dark: '#AC744D' },
    i: { light: '#F8E2C2', dark: '#AC744D' },
    o: { light: '#F8E2C2', dark: '#AC744D' },
    p: { light: '#F5EBF1', dark: '#9C899A' },
    # 第二行
    a: { light: '#F8E2C2', dark: '#AC744D' },
    s: { light: '#F8E8CA', dark: '#AD937E' },
    d: { light: '#F9F7EB', dark: '#AC9B84' },
    f: { light: '#F79781', dark: '#EB3855' },
    g: { light: '#E6E9EF', dark: '#9298A7' },
    h: { light: '#F1F6E5', dark: '#A1A893' },
    j: { light: '#F8B285', dark: '#FF9800' },
    k: { light: '#DFE8EE', dark: '#6F7990' },
    l: { light: '#F7EDF3', dark: '#806C8A' },
    # 第三行
    z: { light: '#F7F3F0', dark: '#B6A6A5' },
    x: { light: '#F7F0E1', dark: '#86B953' },
    c: { light: '#F6F9E9', dark: '#B5AB9E' },
    v: { light: '#F8E2C2', dark: '#AC744D' },
    b: { light: '#F9F1D9', dark: '#B2A68E' },
    n: { light: '#E9ECF0', dark: '#9298A7' },
    m: { light: '#F4EFED', dark: '#9C899A' },
    # 默认色（无映射时回退）
    default: { light: '#F7EDF3', dark: '#806C8A' },
  } + {
    # 数字 0-9 借用对应字母色（1↔q, 2↔w, …, 9↔p, 0↔y）
    '1': self.q, '2': self.w, '3': self.e, '4': self.r, '5': self.t,
    '6': self.u, '7': self.i, '8': self.o, '9': self.p, '0': self.y,
    # 横向数字键盘第二排符号借用对应位置的字母色
    '-': self.r, '/': self.t, ':': self.y, ';': self.u, '(': self.i,
    ')': self.o, '$': self.p, '@': self.q, '“': self.w, '”': self.e,
    # 横向数字键盘第三排符号借用对应位置的字母色
    '+': self.a, '*': self.s, '、': self.d, '#': self.f, '?': self.g,
    '!': self.h, '.': self.j, '。': self.k, '=': self.l,
  };

// 仅在 colorful 主题下暴露 custom map；plain 主题下为 null，
// BasicStyle 中的取色函数会回退到 standardButtonBackgroundColor。
local standardButtonCustomBackgroundColor =
  if settings.buttonColorTheme == 'colorful' then letterColors else null;

// 标准按键按下时的背景色
local standardButtonHighlightedBackgroundColor = {
  light: '#E6E6E6',
  dark: '#D1D1D624',
};

// 标准按键前景色（如字母按键、空格键等），用于按键的字体，图片等
local standardButtonForegroundColor = labelColor.primary;

local standardButtonHighlightedForegroundColor = standardButtonForegroundColor;

// 标准按键备用色，用于显示上下划提示等
local alternativeForegroundColor = labelColor.secondary;
local alternativeHighlightedForegroundColor = alternativeForegroundColor;

// 标准按键阴影颜色
local standardButtonShadowColor = {
  light: '#898A8D',
  dark: '#000000',
};

// 系统按键（如回车、删除等）背景颜色
local systemButtonBackgroundColor = {
  light: '#E6E6E6',
  dark: '#D1D1D624',
};

local systemButtonHighlightedBackgroundColor = {
  light: '#FFFFFF',
  dark: '#D1D1D659',
};

// 系统按键（如回车、删除等）前景颜色
local systemButtonForegroundColor = labelColor.primary;

local systemButtonHighlightedForegroundColor = systemButtonForegroundColor;

// MARK: 一定要与 Settings.libsonnet 中的 accentColor 编号对应
local accentColors = [
  // 在这里检查一下对比度 https://webaim.org/resources/contrastchecker/
  // 确保前景色和背景色的对比度足够高（至少大于 3）以保证可读性
  { // red
    background: '#da4357',
    foreground: '#ffffff',
  },
  { // green
    background: '#50A545',
    foreground: '#ffffff',
  },
  { // orange
    background: '#E86E30',
    foreground: '#ffffff',
  },
  { // blue
    background: '#2e67f8',
    foreground: '#ffffff',
  },
  { // purple
    background: '#7A72B8',
    foreground: '#ffffff',
  },
];

local colorButtonBackgroundColor = if settings.accentColor == 0 then systemButtonBackgroundColor else
  local color = accentColors[settings.accentColor - 1].background;
  if std.type(color) == 'object' && std.objectHas(color, 'light') && std.objectHas(color, 'dark') then
    color
  else
    {
      light: color,
      dark: color,
    };
local colorButtonForegroundColor = if settings.accentColor == 0 then systemButtonForegroundColor else
  local color = accentColors[settings.accentColor - 1].foreground;
  if std.type(color) == 'object' && std.objectHas(color, 'light') && std.objectHas(color, 'dark') then
    color
  else
    {
      light: color,
      dark: color,
    };

local colorButtonHighlightedBackgroundColor = systemButtonHighlightedBackgroundColor;
local colorButtonHighlightedForegroundColor = labelColor.primary;

// 按键底部边缘颜色
local lowerEdgeOfButtonNormalColor = {
  light: '#898A8D',
  dark: '#1E1E1E',
};

// 按下状态下，按键底部边缘颜色
local lowerEdgeOfButtonHighlightColor = {
  light: '#898A8D',
  dark: '#1D1D1D',
};

// 标准按键 Hint 背景色(包含长按符号列表的背景色)
local standardCalloutBackgroundColor = {
  light: '#f8f8f8',
  dark: '#6B6B6B',
};

// 标准按键 Hint 前景色，用于按键的字体，图片等
local standardCalloutForegroundColor = standardButtonForegroundColor;

local standardCalloutHighlightedForegroundColor = colorButtonForegroundColor;

// 标准按键 Hint 选中背景色，如长按符号列表中选中的符号背景色
local standardCalloutSelectedBackgroundColor = colorButtonBackgroundColor;

// 标准按键 Hint 边框颜色
local standardCalloutBorderColor = {
  light: '#C6C6C8',
  dark: '#606060',
};

// 预编辑区文字颜色
local preeditForegroundColor = standardButtonForegroundColor;

// 工具栏按钮前景色
local toolbarButtonForegroundColor = standardButtonForegroundColor;

// 工具栏按钮高亮前景色
local toolbarButtonHighlightedForegroundColor = standardButtonForegroundColor;

// 候选字亮候选字背景颜色
local candidateHighlightColor = standardButtonBackgroundColor;
local candidateForegroundColor = standardButtonForegroundColor;

// 候选字分隔线颜色
local candidateSeparatorColor = separatorColor;


{
  labelColor: labelColor,
  separatorColor: separatorColor,
  keyboardBackgroundColor: keyboardBackgroundColor,
  standardButtonBackgroundColor: standardButtonBackgroundColor,
  standardButtonCustomBackgroundColor: standardButtonCustomBackgroundColor,
  standardButtonHighlightedBackgroundColor: standardButtonHighlightedBackgroundColor,
  standardButtonForegroundColor: standardButtonForegroundColor,
  standardButtonHighlightedForegroundColor: standardButtonHighlightedForegroundColor,
  alternativeForegroundColor: alternativeForegroundColor,
  alternativeHighlightedForegroundColor: alternativeHighlightedForegroundColor,
  standardButtonShadowColor: standardButtonShadowColor,
  systemButtonBackgroundColor: systemButtonBackgroundColor,
  systemButtonHighlightedBackgroundColor: systemButtonHighlightedBackgroundColor,
  systemButtonForegroundColor: systemButtonForegroundColor,
  systemButtonHighlightedForegroundColor: systemButtonHighlightedForegroundColor,
  colorButtonBackgroundColor: colorButtonBackgroundColor,
  colorButtonHighlightedBackgroundColor: colorButtonHighlightedBackgroundColor,
  colorButtonForegroundColor: colorButtonForegroundColor,
  colorButtonHighlightedForegroundColor: colorButtonHighlightedForegroundColor,
  lowerEdgeOfButtonNormalColor: lowerEdgeOfButtonNormalColor,
  lowerEdgeOfButtonHighlightColor: lowerEdgeOfButtonHighlightColor,
  standardCalloutBackgroundColor: standardCalloutBackgroundColor,
  standardCalloutForegroundColor: standardCalloutForegroundColor,
  standardCalloutHighlightedForegroundColor: standardCalloutHighlightedForegroundColor,
  standardCalloutSelectedBackgroundColor: standardCalloutSelectedBackgroundColor,
  standardCalloutBorderColor: standardCalloutBorderColor,
  preeditForegroundColor: preeditForegroundColor,
  toolbarButtonForegroundColor: toolbarButtonForegroundColor,
  toolbarButtonHighlightedForegroundColor: toolbarButtonHighlightedForegroundColor,
  candidateHighlightColor: candidateHighlightColor,
  candidateForegroundColor: candidateForegroundColor,
  candidateSeparatorColor: candidateSeparatorColor,
}

local settings = import '../Settings.libsonnet';

// 标签颜色常量定义
local labelColor = {
  primary: {
    light: '#000000',
    dark: '#FFFFFF',
  },
  secondary: {
    light: '#8a8a8a',
    dark: '#e0e0e0',
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


// 按键背景颜色定义
local standardButtonBackgroundColor = {
  custom: {

    default: { light: '#F7EDF3', dark: '#806C8A' },

// 第一排
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

    // 第二排
    a: { light: '#F8E2C2', dark: '#AC744D' },
    s: { light: '#F8E8CA', dark: '#AD937E' },
    d: { light: '#F9F7EB', dark: '#AC9B84' },
    f: { light: '#F79781', dark: '#EB3855' },
    g: { light: '#E6E9EF', dark: '#9298A7' },
    h: { light: '#F1F6E5', dark: '#A1A893' },
    j: { light: '#F8B285', dark: '#FF9800' },
    k: { light: '#DFE8EE', dark: '#6F7990' },
    l: { light: '#F7EDF3', dark: '#806C8A' },

    // 第三排
    z: { light: '#F7F3F0', dark: '#B6A6A5' },
    x: { light: '#F7F0E1', dark: '#86B953' },
    c: { light: '#F6F9E9', dark: '#B5AB9E' },
    v: { light: '#F8E2C2', dark: '#AC744D' },
    b: { light: '#F9F1D9', dark: '#B2A68E' },
    n: { light: '#E9ECF0', dark: '#9298A7' },
    m: { light: '#F4EFED', dark: '#9C899A' },

    // 引用字母键颜色
    "1":  self.q,
    "2":  self.w,
    "3":  self.e,
    "4":  self.r,
    "5":  self.t,
    "6":  self.u,
    "7":  self.i,
    "8":  self.o,
    "9":  self.p,
    "0":  self.y,
    // 横向数字键盘第二排符号颜色
    "-":  self.r,
    "/":  self.t,
    ":":  self.y,
    ";":  self.u,
    "(":  self.i,
    ")":  self.o,
    "$":  self.p,
    "@":  self.q,
    "“":  self.w,
    "”":  self.e,
    // 横向数字键盘第三排符号颜色
    "+":  self.a,
    "*":  self.s,
    "、": self.d,
    "#":  self.f,
    "?":  self.g,
    "!":  self.h,
    ".":  self.j,
    "。": self.k,
    "=":  self.l,
  },
};

// 标准按键按下时的背景色
local standardButtonHighlightedBackgroundColor = {
  light: '#E6E6E6',
  dark: '#D1D1D624',
};

// 标准按键前景色
local standardButtonForegroundColor = labelColor.primary;
local standardButtonHighlightedForegroundColor = standardButtonForegroundColor;

// 标准按键备用色
local alternativeForegroundColor = labelColor.secondary;
local alternativeHighlightedForegroundColor = alternativeForegroundColor;

// 标准按键阴影颜色
local standardButtonShadowColor = {
  light: '#898A8D',
  dark: '#000000',
};

// 系统按键背景颜色
local systemButtonBackgroundColor = {
  light: '#E6E6E6',
  dark: '#D1D1D624',
};

local systemButtonHighlightedBackgroundColor = {
  light: '#FFFFFF',
  dark: '#D1D1D659',
};

// 系统按键前景颜色
local systemButtonForegroundColor = labelColor.primary;
local systemButtonHighlightedForegroundColor = systemButtonForegroundColor;

// 强调色配置
local accentColors = [
  { background: '#da4357', foreground: '#ffffff' },
  { background: '#50A545', foreground: '#ffffff' },
  { background: '#E86E30', foreground: '#ffffff' },
  { background: '#2e67f8', foreground: '#ffffff' },
  { background: '#7A72B8', foreground: '#ffffff' },
];

local colorButtonBackgroundColor = if settings.accentColor == 0 then systemButtonBackgroundColor else
  local color = accentColors[settings.accentColor - 1].background;
  { light: color, dark: color };

local colorButtonForegroundColor = if settings.accentColor == 0 then systemButtonForegroundColor else
  local color = accentColors[settings.accentColor - 1].foreground;
  { light: color, dark: color };

local colorButtonHighlightedBackgroundColor = systemButtonHighlightedBackgroundColor;
local colorButtonHighlightedForegroundColor = labelColor.primary;

// 按键边缘颜色
local lowerEdgeOfButtonNormalColor = { light: '#898A8D', dark: '#1E1E1E' };
local lowerEdgeOfButtonHighlightColor = { light: '#898A8D', dark: '#1D1D1D' };

// 气泡系统
local standardCalloutBackgroundColor = { light: '#f8f8f8', dark: '#6B6B6B' };
local standardCalloutForegroundColor = standardButtonForegroundColor;
local standardCalloutHighlightedForegroundColor = colorButtonForegroundColor;
local standardCalloutSelectedBackgroundColor = colorButtonBackgroundColor;
local standardCalloutBorderColor = { light: '#C6C6C8', dark: '#606060' };

// 其他显示字段
local preeditForegroundColor = standardButtonForegroundColor;
local toolbarButtonForegroundColor = standardButtonForegroundColor;
local toolbarButtonHighlightedForegroundColor = standardButtonForegroundColor;

// 候选词系统：取e键颜色
local candidateHighlightColor = standardButtonBackgroundColor.custom.e;
local candidateForegroundColor = standardButtonForegroundColor;
local candidateSeparatorColor = separatorColor;

// 最终导出
{
  labelColor: labelColor,
  separatorColor: separatorColor,
  keyboardBackgroundColor: keyboardBackgroundColor,
  standardButtonBackgroundColor: standardButtonBackgroundColor,
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

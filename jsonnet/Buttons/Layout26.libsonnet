# =====================================
# 此文件用于自定义键盘按键功能。
# 顶部的 Actions 区域用于统一管理上滑、下滑和长按功能。
# =====================================

local colors = import '../Constants/Colors.libsonnet';
local fonts = import '../Constants/Fonts.libsonnet';
local settings = import '../Settings.libsonnet';

{
  local root = self,

  # ---------------------------------------------------------
  # [快速配置区] 在这里统一修改各键位的功能
  # ---------------------------------------------------------
  local Actions = {
    // 1. 上滑符号定义 (Swipe Up)
    swipeUp: {
      q: '1', w: '2', e: '3', r: '4', t: '5', y: '6', u: '7', i: '8', o: '9', p: '0',
      a: '!', s: '^', d: '/', f: ';', g: '(', h: '-', j: '#', k: '{', l: '"',
      z: '@', x: '*', c: '`', v: '=', b: '[', n: '&', m: '?',
    },
    // 2. 下滑功能定义 (Swipe Down)
    swipeDown: {
      q: { action: 'tab', systemImageName: 'arrow.right.to.line' },
      i: { action: { character: '|' } },
      o: { action: { character: '<' } },
      p: { action: { character: '>' } },
      a: { action: { shortcut: '#selectText' }, text: '全', systemImageName: 'selection.pin.in.out' },
      s: { action: { character: '%' } },
      d: { action: { character: '\\' } },
      f: { action: { character: ':' } },
      g: { action: { character: ')' } },
      h: { action: { character: '_' } },
      j: { action: { character: '+' } },
      k: { action: { character: '}' } },
      l: { action: { character: "'" } },
      z: { action: { shortcut: '#undo' }, text: '撤', systemImageName: 'arrow.uturn.left' },
      x: { action: { shortcut: '#cut' }, text: '剪', systemImageName: 'scissors' },
      c: { action: { shortcut: '#copy' }, text: '复', systemImageName: 'doc.on.doc' },
      v: { action: { shortcut: '#paste' }, text: '贴', systemImageName: 'doc.on.clipboard' },
      b: { action: { character: ']' } },
      n: { action: { character: '~' } },
      m: { action: { character: '$' } },
    },
    // 3. 长按功能定义 (Long Press)
    longPress: {
      a: [
        { action: { character: 'A' }, selected: true },
        { action: { shortcut: '#左手模式' }, systemImageName: 'keyboard.onehanded.left' },
      ],
      l: [
        { action: { shortcut: '#右手模式' }, systemImageName: 'keyboard.onehanded.right' },
        { action: { character: 'L' }, selected: true },
      ],
      // 其他键默认为大写字母
      default: function(char) [{ action: { character: std.asciiUpper(char) } }],
    },
  },

  # ---------------------------------------------------------
  # [按键定义区] 自动引用上方配置，通常无需修改
  # ---------------------------------------------------------
  local mkButton(char) = {
    name: char + 'Button',
    params: {
      action: { character: char },
      uppercased: { action: { character: std.asciiUpper(char) } },
      // 引用上滑
      [if std.objectHas(Actions.swipeUp, char) then 'swipeUp']: { action: { character: Actions.swipeUp[char] } },
      // 引用下滑
      [if std.objectHas(Actions.swipeDown, char) then 'swipeDown']: Actions.swipeDown[char],
      // 引用长按 (如果 Actions.longPress 有定义则用定义，否则用默认大写)
      longPress: if std.objectHas(Actions.longPress, char) then Actions.longPress[char] else Actions.longPress.default(char),
    },
  },

  qButton: mkButton('q'),
  wButton: mkButton('w'),
  eButton: mkButton('e'),
  rButton: mkButton('r'),
  tButton: mkButton('t'),
  yButton: mkButton('y'),
  uButton: mkButton('u'),
  iButton: mkButton('i'),
  oButton: mkButton('o'),
  pButton: mkButton('p'),
  aButton: mkButton('a'),
  sButton: mkButton('s'),
  dButton: mkButton('d'),
  fButton: mkButton('f'),
  gButton: mkButton('g'),
  hButton: mkButton('h'),
  jButton: mkButton('j'),
  kButton: mkButton('k'),
  lButton: mkButton('l'),
  zButton: mkButton('z'),
  xButton: mkButton('x'),
  cButton: mkButton('c'),
  vButton: mkButton('v'),
  bButton: mkButton('b'),
  nButton: mkButton('n'),
  mButton: mkButton('m'),

  letterButtons: [
    self.qButton, self.wButton, self.eButton, self.rButton, self.tButton,
    self.yButton, self.uButton, self.iButton, self.oButton, self.pButton,
    self.aButton, self.sButton, self.dButton, self.fButton, self.gButton,
    self.hButton, self.jButton, self.kButton, self.lButton,
    self.zButton, self.xButton, self.cButton, self.vButton, self.bButton,
    self.nButton, self.mButton,
  ],
}

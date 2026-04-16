# =====================================
# 18键紧凑布局：上下滑逻辑完全一致化
# =====================================

local colors = import '../Constants/Colors.libsonnet';
local fonts = import '../Constants/Fonts.libsonnet';
local settings = import '../Settings.libsonnet';

{
  local root = self,

  # 1. 统一配置区：在这里修改符号，极其直观
  local Actions = {
    // 上滑符号：直接写字符即可
    swipeUp: {
      q: '`', w: '1', r: '2', y: '3', u: '/', i: '-', p: '=',
      a: { action: 'tab', systemImageName: 'arrow.right.to.line' }, // 也可以写特殊对象
      s: '4', f: '5', h: '6', j: ';', l: "'",
      z: '<', x: '7', v: '8', b: '9', m: '0',
    },

    // 下滑符号：现在改为和上滑一样的简写格式
    swipeDown: {
      q: '~', w: '!', r: '@', y: '#', u: '{', i: '_', p: '+',
      a: '?', s: '$', f: '%', h: '^', j: ':', l: '"',
      z: '\\', x: '&', v: '*', b: '(', m: '[',
    },

    // 长按：处理多字母合并
    longPress: {
      q: [{ action: { character: 'Q' } }],
      w: [{ action: { character: 'W' } }, { action: { character: 'E' } }, { action: { character: 'e' } }],
      r: [{ action: { character: 'R' } }, { action: { character: 'T' } }, { action: { character: 't' } }],
      y: [{ action: { character: 'Y' } }],
      u: [{ action: { character: 'U' } }],
      i: [{ action: { character: 'I' } }, { action: { character: 'O' } }, { action: { character: 'o' } }],
      p: [{ action: { character: 'P' } }],
      a: [
        { action: { shortcut: '#左手模式' }, systemImageName: 'keyboard.onehanded.left' },
        { action: { character: 'A' }, selected: true },
        { action: { shortcut: '#selectText' }, text: '全选' },
      ],
      s: [{ action: { character: 'S' } }, { action: { character: 'D' } }, { action: { character: 'd' } }],
      f: [{ action: { character: 'F' } }, { action: { character: 'G' } }, { action: { character: 'g' } }],
      h: [{ action: { character: 'H' } }],
      j: [{ action: { character: 'J' } }, { action: { character: 'K' } }, { action: { character: 'k' } }],
      l: [{ action: { character: 'L' }, selected: true }, { action: { shortcut: '#右手模式' }, systemImageName: 'keyboard.onehanded.right' }],
      z: [{ action: { shortcut: '#undo' }, text: '撤' }, { action: { character: 'Z' } }],
      x: [{ action: { shortcut: '#cut' }, text: '剪' }, { action: { character: 'X' } }, { action: { shortcut: '#copy' }, text: '复' }, { action: { character: 'C' } }],
      v: [{ action: { character: 'V' } }, { action: { shortcut: '#paste' }, text: '贴' }],
      b: [{ action: { character: 'B' } }, { action: { character: 'N' } }, { action: { character: 'n' } }],
      m: [{ action: { character: 'M' } }],
    },
  },

  # 2. 增强型万能按键函数
  local mk18Button(char, displayLabel) = {
    // 内部助手函数：自动将字符串转换为键盘 action 对象
    local parseAction(val) =
        if std.isString(val) then { action: { character: val } } else val,

    name: char + 'Button',
    params: {
      text: displayLabel,
      action: { character: char },
      // 引用上滑
      [if std.objectHas(Actions.swipeUp, char) then 'swipeUp']: parseAction(Actions.swipeUp[char]),
      // 引用下滑（逻辑现在与上滑完全一致）
      [if std.objectHas(Actions.swipeDown, char) then 'swipeDown']: parseAction(Actions.swipeDown[char]),
      // 引用长按
      [if std.objectHas(Actions.longPress, char) then 'longPress']: Actions.longPress[char],
    },
  },

  # 3. 实例化 18 键
  qButton: mk18Button('q', 'q'),
  wButton: mk18Button('w', 'w e'),
  rButton: mk18Button('r', 'r t'),
  yButton: mk18Button('y', 'y'),
  uButton: mk18Button('u', 'u'),
  iButton: mk18Button('i', 'i o'),
  pButton: mk18Button('p', 'p'),
  aButton: mk18Button('a', 'a'),
  sButton: mk18Button('s', 's d'),
  fButton: mk18Button('f', 'f g'),
  hButton: mk18Button('h', 'h'),
  jButton: mk18Button('j', 'j k'),
  lButton: mk18Button('l', 'l'),
  zButton: mk18Button('z', 'z'),
  xButton: mk18Button('x', 'x c'),
  vButton: mk18Button('v', 'v'),
  bButton: mk18Button('b', 'b n'),
  mButton: mk18Button('m', 'm'),

  # 4. 导出
  letterButtons: [
    self.qButton, self.wButton, self.rButton, self.yButton, self.uButton, self.iButton, self.pButton,
    self.aButton, self.sButton, self.fButton, self.hButton, self.jButton, self.lButton,
    self.zButton, self.xButton, self.vButton, self.bButton, self.mButton,
  ],
}

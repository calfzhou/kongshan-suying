# =====================================
# 17键乱序布局
# =====================================

local colors = import '../Constants/Colors.libsonnet';
local fonts = import '../Constants/Fonts.libsonnet';
local settings = import '../Settings.libsonnet';

{
  local root = self,

  # 1. 统一配置区
  local Actions = {
    // 上滑
    swipeUp: {
      h: '0', s: '1', z: '2', b: '3', x: '^', m: '\\',
      l: '?', d: '4', y: '5', w: '6', j: ':', n: '"',
      c: '!', q: '7', g: '8', f: '9', t: ';',
    },
    // 下滑
    swipeDown: {
      h: 'a ia ua', s: 'en in', z: 'ang iao', b: 'ao iong', x: 'uan uai', m: 'ie uo',
      l: 'ai ue üe', d: 'u', y: 'eng ing', w: 'e', j: 'i', n: 'an',
      c: 'ui iang', q: 'ian uang', g: 'ei un', f: 'ou iu', t: 'ong er',
    },
    // 长按
    longPress: {
      l: [{ action: { shortcut: '#左手模式' }, systemImageName: 'keyboard.onehanded.left' }],
      n: [{ action: { shortcut: '#右手模式' }, systemImageName: 'keyboard.onehanded.right' }],
      c: [{ action: { shortcut: '#undo' }, text: '撤消' }],
      d: [ { action: { shortcut: '#selectText' }, text: '全选' },{ action: { shortcut: '#cut' }, text: '剪切' }],
      y: [ { action: { shortcut: '#copy' }, text: '复制' }, { action: { shortcut: '#paste' }, text: '粘贴' }],
    },
  },
  # 2. 增强型万能按键函数
  local mk17Button(char, displayLabel) = {
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
      [if std.objectHas(Actions.swipeDown, char) then 'swipeDown']: {
         text: Actions.swipeDown[char],},
         // 不写 action 字段，或者写 action: { none: {} }
         // 这样 UI 渲染时能拿到 text 并在按键下方显示，但滑动手势不会有输出
      #[if std.objectHas(Actions.swipeDown, char) then 'swipeDown']: parseAction(Actions.swipeDown[char]),
      // 引用长按
      [if std.objectHas(Actions.longPress, char) then 'longPress']: Actions.longPress[char],
    },
  },

  # 3. 实例化 17 键
  hButton: mk17Button('h', 'HP'),
  sButton: mk17Button('s', 'Sh'),
  zButton: mk17Button('z', 'Zh'),
  bButton: mk17Button('b', 'B'),
  xButton: mk17Button('x', 'oXü'),
  mButton: mk17Button('m', 'MS'),

  lButton: mk17Button('l', 'L'),
  dButton: mk17Button('d', 'D'),
  yButton: mk17Button('y', 'Y'),
  wButton: mk17Button('w', 'WZ'),
  jButton: mk17Button('j', 'JK'),
  nButton: mk17Button('n', 'NR'),

  cButton: mk17Button('c', 'Ch'),
  qButton: mk17Button('q', 'Q~'),
  gButton: mk17Button('g', 'G'),
  fButton: mk17Button('f', 'CF'),
  tButton: mk17Button('t', 'T'),

  # 4. 导出
  letterButtons: [
    self.hButton, self.sButton, self.zButton, self.bButton, self.xButton, self.mButton,
    self.lButton, self.dButton, self.yButton, self.wButton, self.jButton, self.nButton,
    self.cButton, self.qButton, self.gButton, self.fButton, self.tButton,
  ],
}

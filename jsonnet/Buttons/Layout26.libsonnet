# =====================================
# 此文件用于自定义键盘按键功能。
# 可根据需要修改下方内容，调整各类按键的行为
# 修改完成后，保存本文件，然后回到皮肤界面，
# 长按皮肤，选择「运行 main.jsonnet」生效。
#
# 包含中文26键布局和英文26键布局中的字母键
#
# 行式 spec 写法详见 _mkButton.libsonnet 注释。
# 26 键为完整字母布局，使用 mk.fullKeyButton：
#   - 自动派生 uppercased 动作
#   - text 不下发，由下游根据当前模式（中/英、大/小写）渲染
# =====================================

local mk = import '_mkButton.libsonnet';
local sym = mk.sym;
local fk = mk.fullKeyButton;

# 键位顺序即为键盘上的显示顺序
local specs = [
  # 第一行
  { chars: 'q', swipeUp: '1',
    swipeDown: { action: 'tab', systemImageName: 'arrow.right.to.line' },
    longPress: ['Q'] },
  { chars: 'w', swipeUp: '2', longPress: ['W'] },
  { chars: 'e', swipeUp: '3', longPress: ['E'] },
  { chars: 'r', swipeUp: '4', longPress: ['R'] },
  { chars: 't', swipeUp: '5', longPress: ['T'] },
  { chars: 'y', swipeUp: '6', longPress: ['Y'] },
  { chars: 'u', swipeUp: '7', longPress: ['U'] },
  { chars: 'i', swipeUp: '8', swipeDown: '|', longPress: ['I'] },
  { chars: 'o', swipeUp: '9', swipeDown: '<', longPress: ['O'] },
  { chars: 'p', swipeUp: '0', swipeDown: '>', longPress: ['P'] },

  # 第二行
  { chars: 'a', swipeUp: '!',
    swipeDown: { action: { shortcut: '#selectText' }, text: '全', systemImageName: 'selection.pin.in.out' },
    longPress: [
      { action: { character: 'A' }, selected: true },
      { action: { shortcut: '#左手模式' }, systemImageName: 'keyboard.onehanded.left' },
    ] },
  { chars: 's', swipeUp: '^', swipeDown: '%', longPress: ['S'] },
  { chars: 'd', swipeUp: '/', swipeDown: '\\', longPress: ['D'] },
  { chars: 'f', swipeUp: ';', swipeDown: ':', longPress: ['F'] },
  { chars: 'g', swipeUp: '(', swipeDown: ')', longPress: ['G'] },
  { chars: 'h', swipeUp: '-', swipeDown: '_', longPress: ['H'] },
  { chars: 'j', swipeUp: '#', swipeDown: '+', longPress: ['J'] },
  { chars: 'k', swipeUp: '{', swipeDown: '}', longPress: ['K'] },
  { chars: 'l', swipeUp: '"', swipeDown: "'",
    longPress: [
      { action: { shortcut: '#右手模式' }, systemImageName: 'keyboard.onehanded.right' },
      { action: { character: 'L' }, selected: true },
    ] },

  # 第三行
  { chars: 'z', swipeUp: '@',
    swipeDown: { action: { shortcut: '#undo' }, text: '撤', systemImageName: 'arrow.uturn.left' },
    longPress: ['Z'] },
  { chars: 'x', swipeUp: '*',
    swipeDown: { action: { shortcut: '#cut' }, text: '剪', systemImageName: 'scissors' },
    longPress: ['X'] },
  { chars: 'c', swipeUp: '`',
    swipeDown: { action: { shortcut: '#copy' }, text: '复', systemImageName: 'doc.on.doc' },
    longPress: ['C'] },
  { chars: 'v', swipeUp: '=',
    swipeDown: { action: { shortcut: '#paste' }, text: '贴', systemImageName: 'doc.on.clipboard' },
    longPress: ['V'] },
  { chars: 'b', swipeUp: '[', swipeDown: ']', longPress: ['B'] },
  { chars: 'n', swipeUp: '&', swipeDown: '~', longPress: ['N'] },
  { chars: 'm', swipeUp: '?', swipeDown: '$', longPress: ['M'] },
];

{
  [mk.name(s)]: fk(s) for s in specs
} + {
  letterButtons: [fk(s) for s in specs],
}

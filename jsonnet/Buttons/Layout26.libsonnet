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
local settings = import '../Settings.libsonnet';
local doublePinyinHints = (import '../Constants/DoublePinyinHints.libsonnet').getHints(settings.doublePinyinHints);

# 键位顺序即为键盘上的显示顺序
#
# swipeUp / swipeDown 排布原则（参考 PC 物理键盘）：
#   - 第一行字母按 PC 数字排：上滑数字、下滑对应 shift 符号。
#   - 第二行作为「符号家排」：a `~、s -_、d =+、k ;:、l '" 等沿用 PC normal/shift 对；
#     g 落 / \；h/j/f 安排成对的开闭括号 [] {} <>。
#   - 第三行除剪/复/贴（x/c/v）和 b 的 |、m 的 ? 外保留干净。
#   - 自动补齐右半的成对符号 () [] {} <> "" '' 由输入法处理；
#     此处显式给出 ] } 等右半，是为了利用 26 键多出的滑动位、并方便已知光标位置时直接输入。
local specs = [
  # 第一行
  { chars: 'q', swipeUp: '1', swipeDown: '!', longPress: ['Q'] },
  { chars: 'w', swipeUp: '2', swipeDown: '@', longPress: ['W'] },
  { chars: 'e', swipeUp: '3', swipeDown: '#',
    longPress: ['E', sym('ē'), sym('é'), sym('ě'), sym('è')] },
  { chars: 'r', swipeUp: '4', swipeDown: '$', longPress: ['R'] },
  { chars: 't', swipeUp: '5', swipeDown: '%', longPress: ['T'] },
  { chars: 'y', swipeUp: '6', swipeDown: '^', longPress: ['Y'] },
  { chars: 'u', swipeUp: '7', swipeDown: '&',
    longPress: ['U', sym('ū'), sym('ú'), sym('ǔ'), sym('ù')] },
  { chars: 'i', swipeUp: '8', swipeDown: '*',
    longPress: ['I', sym('ī'), sym('í'), sym('ǐ'), sym('ì')] },
  { chars: 'o', swipeUp: '9', swipeDown: '(',
    longPress: ['O', sym('ō'), sym('ó'), sym('ǒ'), sym('ò')] },
  { chars: 'p', swipeUp: '0', swipeDown: ')', longPress: ['P'] },

  # 第二行
  { chars: 'a', swipeUp: '`', swipeDown: '~',
    longPress: [
      { action: { character: 'A' }, selected: true },
      { action: { shortcut: '#左手模式' }, systemImageName: 'keyboard.onehanded.left' },
      { action: 'tab', systemImageName: 'arrow.right.to.line', text: 'Tab' },
      sym('ā'), sym('á'), sym('ǎ'), sym('à'),
    ] },
  { chars: 's', swipeUp: '-', swipeDown: '_', longPress: ['S'] },
  { chars: 'd', swipeUp: '=', swipeDown: '+', longPress: ['D'] },
  { chars: 'f', swipeUp: '<', swipeDown: '>', longPress: ['F'] },
  { chars: 'g', swipeUp: '/', swipeDown: '\\', longPress: ['G'] },
  { chars: 'h', swipeUp: '[', swipeDown: ']', longPress: ['H'] },
  { chars: 'j', swipeUp: '{', swipeDown: '}', longPress: ['J'] },
  { chars: 'k', swipeUp: ';', swipeDown: ':', longPress: ['K'] },
  { chars: 'l', swipeUp: "'", swipeDown: '"',
    longPress: [
      { action: { shortcut: '#右手模式' }, systemImageName: 'keyboard.onehanded.right' },
      { action: { character: 'L' }, selected: true },
    ] },

  # 第三行
  { chars: 'z', longPress: ['Z'] },
  { chars: 'x',
    swipeDown: { action: { shortcut: '#cut' }, text: '剪', systemImageName: 'scissors' },
    longPress: ['X'] },
  { chars: 'c',
    swipeDown: { action: { shortcut: '#copy' }, text: '复', systemImageName: 'doc.on.doc' },
    longPress: ['C'] },
  { chars: 'v',
    swipeDown: { action: { shortcut: '#paste' }, text: '贴', systemImageName: 'doc.on.clipboard' },
    longPress: ['V', sym('ü'), sym('ǖ'), sym('ǘ'), sym('ǚ'), sym('ǜ')] },
  { chars: 'b', swipeDown: '|', longPress: ['B'] },
  { chars: 'n', longPress: ['N'] },
  { chars: 'm', swipeDown: '?', longPress: ['M'] },
];

{
  [mk.name(s)]: fk(s, doublePinyinHints) for s in specs
} + {
  letterButtons: [fk(s, doublePinyinHints) for s in specs],
}

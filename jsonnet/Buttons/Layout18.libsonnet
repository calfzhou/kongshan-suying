# =====================================
# 此文件用于自定义键盘按键功能。
# 可根据需要修改下方内容，调整各类按键的行为
# 修改完成后，保存本文件，然后回到皮肤界面，
# 长按皮肤，选择「运行 main.jsonnet」生效。
#
# 包含中文18键布局的按键
#
# 行式 spec 写法（详见 _mkButton.libsonnet 注释）：
#   { chars: 'q',  swipeUp: '#' }            # 字符简写
#   { chars: 'we', swipeUp: '1' }            # 双字符按键，text 默认 'w e'
#   { chars: 'a',  swipeUp: sym('！') }      # 符号简写
#   longPress 条目同样支持字符串 / sym(...) / 完整对象
# =====================================

local mk = import '_mkButton.libsonnet';
local sym = mk.sym;
local settings = import '../Settings.libsonnet';
local doublePinyinHints = (import '../Constants/DoublePinyinHints.libsonnet').getHints(settings.doublePinyinHints);

# 键位顺序即为键盘上的显示顺序
#
# swipeUp / swipeDown 排布原则（参考 PC 物理键盘）：
#   - 数字键：上滑出数字、下滑出对应 shift 符号（w 1!、r 2@ ...）。
#   - 整键搬运：常见符号键的 normal/shift 对（q `~、i -_、p =+、j ;:、l '"）。
#   - 自动补全的右半边（) ] } > " '）不占用滑动位，由输入法补齐。
#   - z 安排开括号 { / [（{ 在中文模式下还会被翻译成「）。
#   - u 走斜杠对 / \，m 给 0/| 收尾，a 留 <? 兼顾《》与问号。
local specs = [
  # 第一行
  { chars: 'q',  swipeUp: '`',  swipeDown: '~' },
  { chars: 'we', swipeUp: '1',  swipeDown: '!' },
  { chars: 'rt', swipeUp: '2',  swipeDown: '@' },
  { chars: 'y',  swipeUp: '3',  swipeDown: '#' },
  { chars: 'u',  swipeUp: '/',  swipeDown: '\\' },
  { chars: 'io', swipeUp: '-',  swipeDown: '_' },
  { chars: 'p',  swipeUp: '=',  swipeDown: '+' },

  # 第二行
  { chars: 'a',  swipeUp: '<',  swipeDown: '?',
    longPress: [
      { action: { shortcut: '#左手模式' }, systemImageName: 'keyboard.onehanded.left' },
      { action: 'tab', systemImageName: 'arrow.right.to.line', text: 'Tab' },
    ] },
  { chars: 'sd', swipeUp: '4',  swipeDown: '$' },
  { chars: 'fg', swipeUp: '5',  swipeDown: '%' },
  { chars: 'h',  swipeUp: '6',  swipeDown: '^' },
  { chars: 'jk', swipeUp: ';',  swipeDown: ':' },
  { chars: 'l',  swipeUp: "'",  swipeDown: '"',
    longPress: [
      { action: { shortcut: '#右手模式' }, systemImageName: 'keyboard.onehanded.right' },
    ] },

  # 第三行
  { chars: 'z',  swipeUp: '{',  swipeDown: '[' },
  { chars: 'xc', swipeUp: '7',  swipeDown: '&' },
  { chars: 'v',  swipeUp: '8',  swipeDown: '*' },
  { chars: 'bn', swipeUp: '9',  swipeDown: '(' },
  { chars: 'm',  swipeUp: '0',  swipeDown: '|' },
];

{
  [mk.name(s)]: mk.button(s, doublePinyinHints) for s in specs
} + {
  letterButtons: [mk.button(s, doublePinyinHints) for s in specs],
}

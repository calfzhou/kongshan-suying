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
local specs = [
  # 第一行
  { chars: 'q',  swipeUp: '#' },
  { chars: 'we', swipeUp: '1' },
  { chars: 'rt', swipeUp: '2' },
  { chars: 'y',  swipeUp: '3' },
  { chars: 'u',  swipeUp: '\\' },
  { chars: 'io', swipeUp: ':' },
  { chars: 'p',  swipeUp: '"' },

  # 第二行
  { chars: 'a',  swipeUp: '!',
    longPress: [
      { action: { shortcut: '#左手模式' }, systemImageName: 'keyboard.onehanded.left' },
    ] },
  { chars: 'sd', swipeUp: '4' },
  { chars: 'fg', swipeUp: '5' },
  { chars: 'h',  swipeUp: '6' },
  { chars: 'jk', swipeUp: '^' },
  { chars: 'l',  swipeUp: '?',
    longPress: [
      { action: { shortcut: '#右手模式' }, systemImageName: 'keyboard.onehanded.right' },
    ] },

  # 第三行
  { chars: 'z',  swipeUp: '@' },
  { chars: 'xc', swipeUp: '7' },
  { chars: 'v',  swipeUp: '8' },
  { chars: 'bn', swipeUp: '9' },
  { chars: 'm',  swipeUp: '0' },
];

{
  [mk.name(s)]: mk.button(s, doublePinyinHints) for s in specs
} + {
  letterButtons: [mk.button(s, doublePinyinHints) for s in specs],
}

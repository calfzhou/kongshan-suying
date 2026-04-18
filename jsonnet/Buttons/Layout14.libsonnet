# =====================================
# 此文件用于自定义键盘按键功能。
# 可根据需要修改下方内容，调整各类按键的行为
# 修改完成后，保存本文件，然后回到皮肤界面，
# 长按皮肤，选择「运行 main.jsonnet」生效。
#
# 包含中文14键布局的按键
#
# 行式 spec 写法详见 _mkButton.libsonnet 注释。
# =====================================

local mk = import '_mkButton.libsonnet';
local sym = mk.sym;
local settings = import '../Settings.libsonnet';
local doublePinyinHints = (import '../Constants/DoublePinyinHints.libsonnet').getHints(settings.doublePinyinHints);

# 键位顺序即为键盘上的显示顺序
local specs = [
  # 第一行
  { chars: 'qw', swipeUp: '1' },
  { chars: 'er', swipeUp: '2' },
  { chars: 'ty', swipeUp: '3' },
  { chars: 'ui', swipeUp: '4' },
  { chars: 'op', swipeUp: '5' },

  # 第二行
  { chars: 'as', swipeUp: '6',
    longPress: [
      { action: { shortcut: '#左手模式' }, systemImageName: 'keyboard.onehanded.left' },
    ] },
  { chars: 'df', swipeUp: '7' },
  { chars: 'gh', swipeUp: '8' },
  { chars: 'jk', swipeUp: '9' },
  { chars: 'l',  swipeUp: '0',
    longPress: [
      { action: { shortcut: '#右手模式' }, systemImageName: 'keyboard.onehanded.right' },
    ] },

  # 第三行
  { chars: 'zx', swipeUp: '@' },
  { chars: 'cv', swipeUp: '"' },
  { chars: 'bn', swipeUp: '!' },
  { chars: 'm',  swipeUp: '?' },
];

{
  [mk.name(s)]: mk.button(s, doublePinyinHints) for s in specs
} + {
  letterButtons: [mk.button(s, doublePinyinHints) for s in specs],
}

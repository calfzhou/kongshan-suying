# =====================================
# 此文件用于自定义键盘按键功能。
# 可根据需要修改下方内容，调整各类按键的行为
# 修改完成后，保存本文件，然后回到皮肤界面，
# 长按皮肤，选择「运行 main.jsonnet」生效。
#
# 包含中文17键布局的按键
#
# 行式 spec 写法详见 _mkButton.libsonnet 注释。
# 17 键布局的显示文本不是简单的字符序列，因此每行都显式指定 text。
# =====================================

local mk = import '_mkButton.libsonnet';
local sym = mk.sym;

# 键位顺序即为键盘上的显示顺序
local specs = [
  # 第一行
  { chars: 'h', text: 'HP',  swipeUp: '1' },
  { chars: 's', text: 'Sh',  swipeUp: '2' },
  { chars: 'z', text: 'Zh',  swipeUp: '3' },
  { chars: 'b', text: 'B',   swipeUp: '@' },
  { chars: 'x', text: 'oXv', swipeUp: '^' },
  { chars: 'm', text: 'MS',  swipeUp: '\\' },

  # 第二行
  { chars: 'l', text: 'L',   swipeUp: '4' },
  { chars: 'd', text: 'D',   swipeUp: '5' },
  { chars: 'y', text: 'Y',   swipeUp: '6' },
  { chars: 'w', text: 'WZ',  swipeUp: '0' },
  { chars: 'j', text: 'JK',  swipeUp: ':' },
  { chars: 'n', text: 'NR',  swipeUp: '"' },

  # 第三行
  { chars: 'c', text: 'Ch',  swipeUp: '7' },
  { chars: 'q', text: 'Q~',  swipeUp: '8' },
  { chars: 'g', text: 'G',   swipeUp: '9' },
  { chars: 'f', text: 'CF',  swipeUp: '!' },
  { chars: 't', text: 'T',   swipeUp: '?' },
];

{
  [mk.name(s)]: mk.button(s) for s in specs
} + {
  letterButtons: [mk.button(s) for s in specs],
}

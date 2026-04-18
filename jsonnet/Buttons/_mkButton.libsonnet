# =====================================
# 按键定义辅助工具。
#
# 用法示例（行式数据 + 简写）：
#   local mk = import '_mkButton.libsonnet';
#   local sym = mk.sym;
#
#   local specs = [
#     { chars: 'q',  swipeUp: '#' },                    # 字符简写
#     { chars: 'we', swipeUp: '1' },                    # 双字符按键
#     { chars: 'a',  swipeUp: sym('！'),                 # 符号简写
#                     longPress: ['A', sym('@')] },     # 长按列表亦支持简写
#   ];
#
#   { [mk.name(s)]: mk.button(s) for s in specs }
#
# 简写规则（swipeUp / swipeDown / longPress 中单个条目）：
#   '<str>'          -> { action: { character: '<str>' } }
#   sym('<str>')     -> { action: { symbol: '<str>' } }
#   { ... 对象 ... }  -> 原样透传（可携带 systemImageName / text 等）
# =====================================
{
  # 符号动作简写：sym('，') -> { action: { symbol: '，' } }
  sym(s):: { action: { symbol: s } },

  # 将单个条目展开为标准 action 对象
  expand(entry)::
    if std.isString(entry) then { action: { character: entry } }
    else entry,

  # 根据 chars 推导按键名称，例如 'w'/'we' -> 'wButton'
  name(spec):: spec.chars[0] + 'Button',

  # 根据 chars 推导显示文本，例如 'q' -> 'q'，'we' -> 'w e'
  #   spec.text 优先，否则由 chars 生成（以空格分隔每个字符）
  defaultText(spec)::
    if std.objectHas(spec, 'text') then spec.text
    else std.join(' ', std.stringChars(spec.chars)),

  # 根据行式 spec 生成完整按键定义（兼容现有 Hamster v3 YAML 结构）
  # spec 支持字段：
  #   chars:      字符串，首字符为主字符；多字符表示同一按键承载多个音
  #   text:       可选，覆盖默认显示文本
  #   swipeUp:    可选，简写或完整对象
  #   swipeDown:  可选，简写或完整对象
  #   longPress:  可选，条目数组；每项可用简写
  button(spec):: {
    local self_ = self,
    name: $.name(spec),
    params: {
        text: $.defaultText(spec),
        action: { character: spec.chars[0] },
    } + (
      if std.objectHas(spec, 'swipeUp') then { swipeUp: $.expand(spec.swipeUp) } else {}
    ) + (
      if std.objectHas(spec, 'swipeDown') then { swipeDown: $.expand(spec.swipeDown) } else {}
    ) + (
      if std.objectHas(spec, 'longPress') then {
        longPress: [$.expand(e) for e in spec.longPress],
      } else {}
    ),
  },
}

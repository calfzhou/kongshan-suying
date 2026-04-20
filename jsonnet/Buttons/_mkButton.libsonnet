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

  # 双拼助记词触发的快捷指令名称。shift 的 swipeUp 触发它，字母按键监听它。
  doublePinyinHintsShortcut:: '#助记',

  # 根据 chars 与 hintsMap，构造字母键在“助记”模式下的 whenKeyboardAction 条目。
  # 拼装规则（单字符 -> 仅 swipeDown；多字符 -> 前一半 swipeUp、后一半 swipeDown，
  # 字符数为奇数时前半较少）：
  #   chars='a'  -> swipeDown 'a'
  #   chars='we' -> swipeUp 'ei',  swipeDown 'e'
  #   chars='io' -> swipeUp 'i',   swipeDown 'o uo'
  # 任一字符不在 hintsMap 中时返回 null（不注入监听）。
  doublePinyinHintsAction(spec, hintsMap)::
    if hintsMap == null then null
    else
      local cs = std.stringChars(spec.chars);
      local missing = std.foldl(function(a, c) a || !std.objectHas(hintsMap, c), cs, false);
      if missing then null
      else
        local n = std.length(cs);
        local mid = std.floor(n / 2);
        local upChars = cs[0:mid];
        local downChars = cs[mid:];
        local joinHints(xs) = std.join(' ', [hintsMap[c] for c in xs]);
        {
          notificationKeyboardAction: { shortcut: $.doublePinyinHintsShortcut },
        } + (
          if std.length(upChars) > 0 then { swipeUp: { text: joinHints(upChars) } } else {}
        ) + (
          if std.length(downChars) > 0 then { swipeDown: { text: joinHints(downChars) } } else {}
        ),

  # 在 params 末尾追加双拼助记的 whenKeyboardAction 监听条目。
  # 若 hintsMap 为 null 或当前按键字符未在表中，则原样返回 params。
  # 当原 params 缺少某方向的 swipe 时，补一个 { text: '' } 的占位 swipe，
  # 否则 BasicStyle 中 replaceGivenPairs 找不到对应的旧条目，
  # 助记 notification 触发时该方向的提示文字将不会被注入到 foregroundStyle 列表。
  # blankUnusedOriginal=true 时，若 entry 中某方向缺少 hint，但原 params 中
  # 已有该方向的 swipe，则在 entry 中补一个 { text: '' } 以覆盖原文本，
  # 避免在助记模式下原 swipe 文字与助记词混杂显示，提升可读性。
  # （仅适用于行式布局如 14/17/18 键；26 键全键布局保留原 swipe 提示。）
  withDoublePinyinHints(params, spec, hintsMap, blankUnusedOriginal=false)::
    local rawEntry = $.doublePinyinHintsAction(spec, hintsMap);
    if rawEntry == null then params
    else
      local entry = rawEntry + (
        if blankUnusedOriginal && !std.objectHas(rawEntry, 'swipeUp') && std.objectHas(params, 'swipeUp')
        then { swipeUp: { text: '' } } else {}
      ) + (
        if blankUnusedOriginal && !std.objectHas(rawEntry, 'swipeDown') && std.objectHas(params, 'swipeDown')
        then { swipeDown: { text: '' } } else {}
      );
      local ensureSwipe(p, key) =
        if std.objectHas(p, key) then p
        else if !std.objectHas(entry, key) then p
        else p + { [key]: { text: '' } };
      ensureSwipe(ensureSwipe(params, 'swipeUp'), 'swipeDown') + {
        whenKeyboardAction:
          (if std.objectHas(params, 'whenKeyboardAction') then params.whenKeyboardAction else [])
          + [entry],
      },

  # 将 longPress 数组中的每个条目按 expand 简写规则转换为标准 action 对象，
  # 并在没有任何条目显式标记 selected: true 时，将第一项设为默认选中。
  # （BasicStyle 默认选中数组中间项；这里覆盖为「默认选中第一项」。）
  expandLongPress(items)::
    local expanded = [$.expand(e) for e in items];
    local hasSelected = std.foldl(
      function(a, e) a || (std.objectHas(e, 'selected') && e.selected == true),
      expanded, false);
    if hasSelected || std.length(expanded) == 0 then expanded
    else [expanded[0] { selected: true }] + expanded[1:],

  # 根据行式 spec 生成完整按键定义（兼容现有 Hamster v3 YAML 结构）
  # spec 支持字段：
  #   chars:      字符串，首字符为主字符；多字符表示同一按键承载多个音
  #   text:       可选，覆盖默认显示文本
  #   swipeUp:    可选，简写或完整对象
  #   swipeDown:  可选，简写或完整对象
  #   longPress:  可选，条目数组；每项可用简写
  # 可选第二参数 hintsMap：双拼助记词映射表（来自 Constants/DoublePinyinHints）；
  #   传入非 null 时，会自动为按键追加 whenKeyboardAction 监听条目，
  #   在“助记”模式被触发后切换为对应韵母提示。
  button(spec, hintsMap=null):: {
    local self_ = self,
    name: $.name(spec),
    params: $.withDoublePinyinHints({
        text: $.defaultText(spec),
        action: { character: spec.chars[0] },
    } + (
      if std.objectHas(spec, 'swipeUp') then { swipeUp: $.expand(spec.swipeUp) } else {}
    ) + (
      if std.objectHas(spec, 'swipeDown') then { swipeDown: $.expand(spec.swipeDown) } else {}
    ) + (
      if std.objectHas(spec, 'longPress') then {
        longPress: $.expandLongPress(spec.longPress),
      } else {}
    ), spec, hintsMap, blankUnusedOriginal=true),
  },

  # 全键按键变体：用于 26 键这类完整字母布局。
  # 与 button() 的差异：
  #   1. 不默认下发 text 字段，交由下游根据 action / uppercased 状态自动推导
  #      （Chinese 模式下大写、English 模式下小写等）；如需固定文本仍可在 spec 中指定 text。
  #   2. 自动根据 chars[0] 派生 uppercased 动作（例如 'q' -> { action: { character: 'Q' } }）。
  # 其余字段（swipeUp / swipeDown / longPress）行为与 button() 相同。
  # hintsMap 参数行为同 button()。
  fullKeyButton(spec, hintsMap=null):: {
    name: $.name(spec),
    params: $.withDoublePinyinHints((
      if std.objectHas(spec, 'text') then { text: spec.text } else {}
    ) + {
      action: { character: spec.chars[0] },
      uppercased: { action: { character: std.asciiUpper(spec.chars[0]) } },
    } + (
      if std.objectHas(spec, 'swipeUp') then { swipeUp: $.expand(spec.swipeUp) } else {}
    ) + (
      if std.objectHas(spec, 'swipeDown') then { swipeDown: $.expand(spec.swipeDown) } else {}
    ) + (
      if std.objectHas(spec, 'longPress') then {
        longPress: $.expandLongPress(spec.longPress),
      } else {}
    ), spec, hintsMap),
  },
}

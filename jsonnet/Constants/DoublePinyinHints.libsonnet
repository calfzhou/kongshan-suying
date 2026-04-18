# =====================================
# 双拼助记词（韵母提示）数据。
#
# 每个方案是一个 26 个字母 -> 韵母提示 的映射表。
# 字母按键在“助记”模式下会以 swipeUp/swipeDown 文本展示对应韵母。
#
# 当前预置：
#   - flypy: 小鹤双拼
# 预留扩展：可按相同结构添加其他方案（如自然码、智能ABC 等）。
#
# 使用方式由 Settings.libsonnet 中 doublePinyinHints 字段控制：
#   'none'  -> 关闭
#   'flypy' -> 启用小鹤双拼
# =====================================
{
  # 小鹤双拼
  flypy: {
    a: 'a',       b: 'in',     c: 'ao',
    d: 'ai',      e: 'e',      f: 'en',
    g: 'eng',     h: 'ang',    i: 'i',
    j: 'an',      k: 'uai ing', l: 'u|iang',
    m: 'ian',     n: 'iao',    o: 'o uo',
    p: 'ie',      q: 'iu',     r: 'uan',
    s: 'i?ong',   t: 'ue üe',  u: 'u',
    v: 'ui ü',    w: 'ei',     x: 'ia ua',
    y: 'un',      z: 'ou',
  },

  # 根据 scheme 名称返回字母 -> 助记词的映射表；未知或 'none' 返回 null。
  getHints(scheme)::
    if scheme == 'none' || scheme == null then null
    else if std.objectHas(self, scheme) then self[scheme]
    else null,
}

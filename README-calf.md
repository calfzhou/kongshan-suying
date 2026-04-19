## 「空山素影」皮肤特点（calf 定制版）

> 本仓库是 [luozikuan/kongshan-suying](https://github.com/luozikuan/kongshan-suying) 的个人定制分支，在保留原皮肤简洁风格的基础上做了若干按键功能与显示上的调整。

- 支持多种键盘布局：26 键、9 键、14 键、17 键、18 键、注音、西戈拼音等。
- 数字键盘布局支持九宫格、一行排列、十六进制等。
- 不包含图片资源，整体风格接近系统原生键盘。
- 工具栏滑动按钮可自定义，方便快速个性化，亦可改为纯文本工具栏。
- 空格键显示当前输入方案名称，便于快速辨认输入方案。
- 中文模式下字母键大写显示，英文模式下小写显示，输入状态一目了然。
- shift 键在打字过程中默认充当“分词”功能（输入单引号，可在「微调」中改为其它符号）。
- 支持按键上下划动，可在「微调」中快速控制是否显示划动提示文字。
- a / z / x / c / v 五键下划对应全选 / 撤销 / 剪切 / 复制 / 粘贴，与 PC 键盘习惯一致。
- 主题色可选，满足不同审美。
- 浮动面板「微调」可对皮肤设置做快速调整。

## 本分支相对原版的主要改动

- **默认键盘改为 18 键拼音布局**，下划提示文字默认显示在按键下方。
- **数字键盘默认使用十六进制布局**。
- **双拼助记词模式**：在 14 / 18 / 26 键的中文拼音键盘上，shift 键上划即可触发字母键临时显示双拼韵母提示，按一次按键自动恢复。当前预置「小鹤双拼（flypy）」，可在 `Settings.libsonnet` 的 `doublePinyinHints` 字段切换 `none` 或新增其它方案。
- **系统按键划动支持文字 / 图标显示**，并对划动行为做了以下调整：
  - **退格键（backspace）**：在打字过程中（preedit），上划触发「重输（esc）」。
  - **回车键（enter）**：上划触发「换行（↵）」。
  - **数字键（123）**：上划切换到符号键盘（图标 number），下划切换到 emoji 键盘（图标 face.dashed）。
  - **中/英切换键（alphabetic）**：在非 26 键布局下，下划临时切换到 26 键键盘（图标 keyboard）。
  - **空格键**：下划触发「方案切换」；打字过程中，上划「次选」、下划「三选」上屏。
  - **shift / 中英切换** 等按键移除了原有的「方案切换」上划。
- **行式按键定义语法**：`jsonnet/Buttons/Layout*.libsonnet` 中各布局采用一行一键的紧凑写法，便于快速调整某个键的字符 / 上下划 / 长按行为，详见 `_mkButton.libsonnet` 顶部注释。
- 工具栏数字按键、emoji 按键、性能查看等按钮的默认顺序与原版略有差异。

## 默认 18 键布局示意

```
 # 1  2  3 \ :  "    上划
 q we rt y u io p

 ! 4  5 6  ^  ?      上划
 a sd fg h jk l   长按 a 进入左手模式 / 长按 l 进入右手模式

 @ 7  8 9  0        上划
 z xc v bn m
```

## 默认 26 键布局上下划

```
1234567890 上划数字
qwertyuiop 按键
T      |<> 下划符号；q下划 Tab

!^/;(-#{" 上划符号
asdfghjkl 按键
 `\:)_+}' 下划符号；a下划全选

@*`=[&? 上划符号
zxcvbnm 按键
    ]~$ 下划符号；z撤销、x剪切、c复制、v粘贴
```

## 自定义皮肤调整说明

- 皮肤的基本设置：`jsonnet/Settings.libsonnet`
  - 浮动键盘中的「微调」可直接打开该文件进行编辑。
  - 修改后保存，重新编译皮肤即可生效。

- 键盘按键功能定义：`jsonnet/Buttons/`
  - 浮动键盘中的「按键」会打开 `jsonnet/Buttons/` 文件夹下的 README.md，方便查看各按键在哪个文件。
  - 退出 README.md 后再打开同目录下的具体按键文件进行编辑。
  - 修改后保存，重新编译皮肤即可生效。

## 手机端编译

长按皮肤，选择「运行 main.jsonnet」。

## PC 端编译

PC 端编译需要安装 `jsonnet` 命令行工具。

```shell
# Windows
jsonnet -S -m . --tla-code debug=true .\jsonnet\main.jsonnet

# Linux / macOS
jsonnet -S -m . --tla-code debug=true ./jsonnet/main.jsonnet
```

## GitHub 仓库

- [本分支（calf 定制版）](https://github.com/calfzhou/kongshan-suying)
- [本分支最新发布](https://github.com/calfzhou/kongshan-suying/releases/latest)
- [上游原版](https://github.com/luozikuan/kongshan-suying)

local fonts = import '../Constants/Fonts.libsonnet';
local pinyin9Buttons = import '../Buttons/Layout9.libsonnet';
local commonButtons = import '../Buttons/Common.libsonnet';
local settings = import '../Settings.libsonnet';
local basicStyle = import 'BasicStyle.libsonnet';
local preedit = import 'Preedit.libsonnet';
local toolbar = import 'Toolbar.libsonnet';
local utils = import 'Utils.libsonnet';

// 窄 VStack 宽度样式 (左右侧功能键区)
local narrowVStackStyle = {
  local this = self,
  name: 'narrowVStackStyle',
  style: {
    [this.name]: {
      size: { width: { percentage: 0.18 } },
    },
  },
};

// 半宽 VStack 宽度样式 (横屏分栏)
local halfVStackStyle = {
  local this = self,
  name: 'halfVStackStyle',
  style: {
    [this.name]: {
      size: { width: { percentage: 0.48 } },
    },
  },
};

// 基础 9 键布局结构
local t9KeyboardLayout = {
  keyboardLayout: [
    {
      VStack: {
        style: narrowVStackStyle.name,
        subviews: [
          { Cell: pinyin9Buttons.t9SymbolsCollection.name },
          { Cell: commonButtons.numericButton.name },
        ],
      },
    },
    {
      VStack: {
        subviews: [
          { HStack: { subviews: [ { Cell: pinyin9Buttons.t9OneButton.name }, { Cell: pinyin9Buttons.t9TwoButton.name }, { Cell: pinyin9Buttons.t9ThreeButton.name } ] } },
          { HStack: { subviews: [ { Cell: pinyin9Buttons.t9FourButton.name }, { Cell: pinyin9Buttons.t9FiveButton.name }, { Cell: pinyin9Buttons.t9SixButton.name } ] } },
          { HStack: { subviews: [ { Cell: pinyin9Buttons.t9SevenButton.name }, { Cell: pinyin9Buttons.t9EightButton.name }, { Cell: pinyin9Buttons.t9NineButton.name } ] } },
          { HStack: { subviews: [ { Cell: pinyin9Buttons.cursorRightButton.name }, { Cell: pinyin9Buttons.spaceButton.name }, { Cell: commonButtons.alphabeticButton.name } ] } },
        ],
      },
    },
    {
      VStack: {
        style: narrowVStackStyle.name,
        subviews: [
          { Cell: commonButtons.backspaceButton.name },
          { Cell: commonButtons.clearPreeditButton.name },
          { Cell: commonButtons.enterButton.name },
        ],
      },
    },
  ],
};

local totalKeyboardLayout(isPortrait=false) =
  if isPortrait then t9KeyboardLayout
  else {
    keyboardLayout: [
      {
        VStack: {
          style: halfVStackStyle.name,
          subviews: [
            { VStack: { style: narrowVStackStyle.name, subviews: [ { Cell: pinyin9Buttons.t9SymbolsCollection.name } ] } },
            { VStack: { subviews: [ { Cell: pinyin9Buttons.t9CandidatesCollection.name } ] } },
          ],
        }
      },
      { VStack: {} }, // 中间间距
      { VStack: { style: halfVStackStyle.name, subviews: t9KeyboardLayout.keyboardLayout } },
    ]
  };

local newKeyLayout(isDark=false, isPortrait=true, extraParams={}) =
  local isAlphabetic = false; // T9 拼音通常不视为纯英文模式
  {
    keyboardHeight: if isPortrait then commonButtons.keyboardHeight.portrait else commonButtons.keyboardHeight.landscape,
    keyboardStyle: utils.newBackgroundStyle(style=basicStyle.keyboardBackgroundStyleName),
  }
  + totalKeyboardLayout(isPortrait)

  // 1. 特殊集合区域 (符号/候选字)
  + {
    [pinyin9Buttons.t9SymbolsCollection.name]:
      utils.newBackgroundStyle(style=basicStyle.systemButtonBackgroundStyleName) +
      pinyin9Buttons.t9SymbolsCollection.params + extraParams,
    [if !isPortrait then pinyin9Buttons.t9CandidatesCollection.name]:
      utils.newBackgroundStyle(style=basicStyle.systemButtonBackgroundStyleName) +
      pinyin9Buttons.t9CandidatesCollection.params + extraParams,
  }

  // 2. T9 数字字母按键 (2-9 键)
  + std.foldl(
    function(acc, button)
      local p = button.params + utils.processButtonParams(isAlphabetic, button.params) + extraParams;
      acc + basicStyle.newAlphabeticButton(
        button.name, isDark,
        basicStyle.textCenterWhenShowSwipeText + { fontSize: fonts.t9ButtonTextFontSize } + p +
        (if settings.uppercaseForChinese && std.objectHas(p, 'text') then { text: std.asciiUpper(p.text) } else {})
      ) + basicStyle.newAlphabeticButtonBackgroundStyle(isDark, p + { name: button.name }),
    pinyin9Buttons.t9Buttons,
    {})

  // 3. 左侧功能键 (数字切换等)
  + (
    local p = commonButtons.numericButton.params + utils.processButtonParams(isAlphabetic, commonButtons.numericButton.params) + extraParams;
    basicStyle.newSystemButton(commonButtons.numericButton.name, isDark, p + { size: { height: '1/4' } }) +
    basicStyle.newSystemButtonBackgroundStyle(isDark, p + { name: commonButtons.numericButton.name })
  )

  // 4. 下方功能键 (重码/向右、空格、切换拼音)
  + (
    local p = pinyin9Buttons.cursorRightButton.params + utils.processButtonParams(isAlphabetic, pinyin9Buttons.cursorRightButton.params) + extraParams;
    basicStyle.newSystemButton(pinyin9Buttons.cursorRightButton.name, isDark, p + { size: { width: { percentage: 0.2 } } }) +
    basicStyle.newSystemButtonBackgroundStyle(isDark, p + { name: pinyin9Buttons.cursorRightButton.name })
  )
  + (
    local p = pinyin9Buttons.spaceButton.params + utils.processButtonParams(isAlphabetic, pinyin9Buttons.spaceButton.params) + extraParams;
    basicStyle.newAlphabeticButton(
      pinyin9Buttons.spaceButton.name, isDark,
      p + basicStyle.newSpaceButtonForegroundStyle(p, '$rimeSchemaName', isDark),
      needHint=false
    )
  )
  + (
    local p = commonButtons.alphabeticButton.params + utils.processButtonParams(isAlphabetic, commonButtons.alphabeticButton.params) + extraParams;
    basicStyle.newSystemButton(commonButtons.alphabeticButton.name, isDark, p + { size: { width: { percentage: 0.2 } } }) +
    basicStyle.newSystemButtonBackgroundStyle(isDark, p + { name: commonButtons.alphabeticButton.name })
  )

  // 5. 右侧功能键 (退格、清除、回车)
  + (
    local p = commonButtons.backspaceButton.params + utils.processButtonParams(isAlphabetic, commonButtons.backspaceButton.params) + extraParams;
    basicStyle.newSystemButton(commonButtons.backspaceButton.name, isDark, p) +
    basicStyle.newSystemButtonBackgroundStyle(isDark, p + { name: commonButtons.backspaceButton.name })
  )
  + (
    local p = commonButtons.clearPreeditButton.params + utils.processButtonParams(isAlphabetic, commonButtons.clearPreeditButton.params) + extraParams;
    basicStyle.newSystemButton(commonButtons.clearPreeditButton.name, isDark, p) +
    basicStyle.newSystemButtonBackgroundStyle(isDark, p + { name: commonButtons.clearPreeditButton.name })
  )
  + (
    local p = commonButtons.enterButton.params + utils.processButtonParams(isAlphabetic, commonButtons.enterButton.params) + extraParams;
    basicStyle.newColorButton(commonButtons.enterButton.name, isDark, p + { size: { height: '2/4' } }) +
    basicStyle.newColorButtonBackgroundStyle(isDark, p + { name: commonButtons.enterButton.name })
  );

// 动态计算边距
local backgroundInsets = if !settings.iPad then
  {
    portrait: { top: 3, left: 4, bottom: 3, right: 4 },
    landscape: { top: 3, left: 3, bottom: 3, right: 3 },
  }
else
  {
    portrait: { top: 3, left: 3, bottom: 3, right: 3 },
    landscape: { top: 4, left: 6, bottom: 4, right: 6 },
  };

{
  new(isDark, isPortrait):
    local insets = if isPortrait then backgroundInsets.portrait else backgroundInsets.landscape;
    local extraParams = { insets: insets };

    preedit.new(isDark)
    + toolbar.new(isDark, isPortrait)
    + (if !isPortrait then halfVStackStyle.style else {})
    + narrowVStackStyle.style
    + basicStyle.newKeyboardBackgroundStyle(isDark)
    + basicStyle.newAlphabeticHintBackgroundStyle(isDark, { cornerRadius: 10 })
    + basicStyle.newLongPressSymbolsBackgroundStyle(isDark, extraParams)
    + basicStyle.newLongPressSymbolsSelectedBackgroundStyle(isDark, extraParams)
    + basicStyle.newButtonAnimation()
    + newKeyLayout(isDark, isPortrait, extraParams)
    + basicStyle.rimeSchemaChangedNotification
    + basicStyle.returnKeyTypeChangedNotification,
}

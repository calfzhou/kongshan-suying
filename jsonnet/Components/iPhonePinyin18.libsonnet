local buttons = import '../Buttons/Layout18.libsonnet';
local commonButtons = import '../Buttons/Common.libsonnet';
local toolbarParams = import '../Buttons/Toolbar.libsonnet';
local settings = import '../Settings.libsonnet';
local basicStyle = import 'BasicStyle.libsonnet';
local preedit = import 'Preedit.libsonnet';
local toolbar = import 'Toolbar.libsonnet';
local utils = import 'Utils.libsonnet';

local keyboardLayout = {
  keyboardLayout: [
    {
      HStack: {
        subviews: [
          { Cell: buttons.qButton.name },
          { Cell: buttons.wButton.name },
          { Cell: buttons.rButton.name },
          { Cell: buttons.yButton.name },
          { Cell: buttons.uButton.name },
          { Cell: buttons.iButton.name },
          { Cell: buttons.pButton.name },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          { Cell: buttons.aButton.name },
          { Cell: buttons.sButton.name },
          { Cell: buttons.fButton.name },
          { Cell: buttons.hButton.name },
          { Cell: buttons.jButton.name },
          { Cell: buttons.lButton.name },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          { Cell: commonButtons.shiftButton.name },
          { Cell: buttons.zButton.name },
          { Cell: buttons.xButton.name },
          { Cell: buttons.vButton.name },
          { Cell: buttons.bButton.name },
          { Cell: buttons.mButton.name },
          { Cell: commonButtons.backspaceButton.name },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          { Cell: commonButtons.numericButton.name },
          { Cell: commonButtons.commaButton.name },
          { Cell: commonButtons.spaceButton.name },
          { Cell: commonButtons.alphabeticButton.name },
          { Cell: commonButtons.enterButton.name },
        ],
      },
    },
  ],
};

local getAlphabeticButtonSize(name) =
  local extra = {
    [buttons.aButton.name]: {
      size: { width: '1.5/7' },
      bounds: { width: '1/1.5', alignment: 'right' },
    },
    [buttons.lButton.name]: {
      size: { width: '1.5/7' },
      bounds: { width: '1/1.5', alignment: 'left' },
    },
  };
  (if std.objectHas(extra, name) then extra[name] else {});

local newKeyLayout(isDark=false, isPortrait=true) =
  local insets = if isPortrait then commonButtons.backgroundInsets.portrait else commonButtons.backgroundInsets.landscape;
  {
    keyboardHeight: if isPortrait then commonButtons.keyboardHeight.portrait else commonButtons.keyboardHeight.landscape,
    keyboardStyle: utils.newBackgroundStyle(style=basicStyle.keyboardBackgroundStyleName),
  }
  + keyboardLayout

  // 1. 字母按键区：通过循环为每个按键生成独立的背景样式
  + std.foldl(function(acc, button)
      acc +
      basicStyle.newAlphabeticButton(
        button.name,
        isDark,
        getAlphabeticButtonSize(button.name) + button.params + basicStyle.hintStyleSize + basicStyle.textCenterWhenShowSwipeText +
        {
          insets: insets, // 必须传递边距，BasicStyle 内部会通过 params 生成背景
          [if settings.uppercaseForChinese then 'text']: std.asciiUpper(button.params.text)
        }),
      buttons.letterButtons,
      {})

  // 2. 第三行系统按键
  + basicStyle.newSystemButton(
    commonButtons.shiftButton.name,
    isDark,
    { insets: insets } + commonButtons.shiftButton.params
  )
  + basicStyle.newSystemButton(
    commonButtons.backspaceButton.name,
    isDark,
    { insets: insets } + commonButtons.backspaceButton.params,
  )

  // 3. 第四行功能按键
  + basicStyle.newSystemButton(
    commonButtons.numericButton.name,
    isDark,
    { size: { width: { percentage: 0.2 } }, insets: insets }
    + commonButtons.numericButton.params
  )

  + basicStyle.newAlphabeticButton(
    commonButtons.commaButton.name,
    isDark,
    {
      size: { width: { percentage: 0.12 } },
      insets: insets,
      action: { character: 'q' } // 逗号未定义颜色时，强制指向 custom.q
    }
    + commonButtons.commaButton.params + basicStyle.hintStyleSize,
    swipeTextFollowSetting=false,
  )

  + basicStyle.newAlphabeticButton(
    commonButtons.spaceButton.name,
    isDark,
    { insets: insets } + basicStyle.newSpaceButtonForegroundStyle(commonButtons.spaceButton.params, '$rimeSchemaName', isDark),
    needHint=false,
  )

  + basicStyle.newSystemButton(
    commonButtons.alphabeticButton.name,
    isDark,
    { size: { width: { percentage: 0.12 } }, insets: insets }
    + commonButtons.alphabeticButton.params
  )

  + basicStyle.newColorButton(
    commonButtons.enterButton.name,
    isDark,
    { size: { width: { percentage: 0.22 } }, insets: insets }
    + commonButtons.enterButton.params
  )
;

{
  new(isDark, isPortrait):
    local insets = if isPortrait then commonButtons.backgroundInsets.portrait else commonButtons.backgroundInsets.landscape;

    local extraParams = {
      insets: insets,
    };

    preedit.new(isDark)
    + toolbar.new(isDark, isPortrait)
    + basicStyle.newKeyboardBackgroundStyle(isDark)
    // 【修改核心】：移除了全局的 newAlphabeticButtonBackgroundStyle
    // 因为现在字母键的背景色是动态私有的，在 newKeyLayout 循环中生成
    + basicStyle.newSystemButtonBackgroundStyle(isDark, extraParams)
    + basicStyle.newColorButtonBackgroundStyle(isDark, extraParams)
    + basicStyle.newAlphabeticHintBackgroundStyle(isDark, { cornerRadius: 10 })
    + basicStyle.newLongPressSymbolsBackgroundStyle(isDark, extraParams)
    + basicStyle.newLongPressSymbolsSelectedBackgroundStyle(isDark, extraParams)
    + basicStyle.newButtonAnimation()
    + newKeyLayout(isDark, isPortrait)
    // Notifications
    + basicStyle.rimeSchemaChangedNotification
    + basicStyle.returnKeyTypeChangedNotification,
}

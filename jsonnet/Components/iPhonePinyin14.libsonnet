local buttons = import '../Buttons/Layout14.libsonnet';
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
        spacing: 0, // 依赖 Insets 产生间隙
        subviews: [
          { Cell: buttons.qButton.name },
          { Cell: buttons.eButton.name },
          { Cell: buttons.tButton.name },
          { Cell: buttons.uButton.name },
          { Cell: buttons.oButton.name },
        ],
      },
    },
    {
      HStack: {
        spacing: 0,
        subviews: [
          { Cell: buttons.aButton.name },
          { Cell: buttons.dButton.name },
          { Cell: buttons.gButton.name },
          { Cell: buttons.jButton.name },
          { Cell: buttons.lButton.name },
        ],
      },
    },
    {
      HStack: {
        spacing: 0,
        subviews: [
          { Cell: commonButtons.shiftButton.name },
          { Cell: buttons.zButton.name },
          { Cell: buttons.cButton.name },
          { Cell: buttons.bButton.name },
          { Cell: buttons.mButton.name },
          { Cell: commonButtons.backspaceButton.name },
        ],
      },
    },
    {
      HStack: {
        spacing: 0,
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

local newKeyLayout(isDark=false, isPortrait=true) =
  local currentInsets = if isPortrait then commonButtons.backgroundInsets.portrait else commonButtons.backgroundInsets.landscape;

  {
    keyboardHeight: if isPortrait then commonButtons.keyboardHeight.portrait else commonButtons.keyboardHeight.landscape,
    keyboardStyle: utils.newBackgroundStyle(style=basicStyle.keyboardBackgroundStyleName),
  }
  + keyboardLayout

  // 生成字母键 (合并 Insets)
  + std.foldl(function(acc, button)
      acc +
      basicStyle.newAlphabeticButton(
        button.name,
        isDark,
        basicStyle.hintStyleSize +
        basicStyle.textCenterWhenShowSwipeText +
        { insets: currentInsets } + // 核心：注入间隙
        button.params +
        {
          [if settings.uppercaseForChinese then 'text']: std.asciiUpper(button.params.text)
        }),
      buttons.letterButtons,
      {})

  // 第三行功能键
  + basicStyle.newSystemButton(
    commonButtons.shiftButton.name,
    isDark,
    { size: { width: '168.75/1125' }, insets: currentInsets } // 核心：注入间隙
    + commonButtons.shiftButton.params
  )

  + basicStyle.newSystemButton(
    commonButtons.backspaceButton.name,
    isDark,
    { size: { width: '168.75/1125' }, insets: currentInsets } // 核心：注入间隙
    + commonButtons.backspaceButton.params,
  )

  // 第四行功能键
  + basicStyle.newSystemButton(
    commonButtons.numericButton.name,
    isDark,
    { size: { width: { percentage: 0.2 } }, insets: currentInsets } // 核心：注入间隙
    + commonButtons.numericButton.params
  )

  + basicStyle.newAlphabeticButton(
    commonButtons.commaButton.name,
    isDark,
    { size: { width: { percentage: 0.12 } }, insets: currentInsets } // 核心：注入间隙
    + commonButtons.commaButton.params + basicStyle.hintStyleSize,
    swipeTextFollowSetting=false,
  )
  + basicStyle.newAlphabeticButton(
    commonButtons.spaceButton.name,
    isDark,
    basicStyle.newSpaceButtonForegroundStyle(
      commonButtons.spaceButton.params + { insets: currentInsets }, // 核心：注入间隙
      '$rimeSchemaName',
      isDark
    ),
    needHint=false,
  )
  + basicStyle.newSystemButton(
    commonButtons.alphabeticButton.name,
    isDark,
    { size: { width: { percentage: 0.12 } }, insets: currentInsets } // 核心：注入间隙
    + commonButtons.alphabeticButton.params
  )
  + basicStyle.newColorButton(
    commonButtons.enterButton.name,
    isDark,
    { size: { width: { percentage: 0.22 } }, insets: currentInsets } // 核心：注入间隙
    + commonButtons.enterButton.params
  )
;

{
  new(isDark, isPortrait):
    local insets = if isPortrait then commonButtons.backgroundInsets.portrait else commonButtons.backgroundInsets.landscape;
    local extraParams = { insets: insets };

    preedit.new(isDark)
    + toolbar.new(isDark, isPortrait)
    + basicStyle.newKeyboardBackgroundStyle(isDark)
    + basicStyle.newAlphabeticButtonBackgroundStyle(isDark, extraParams)
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

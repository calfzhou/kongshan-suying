local buttons = import '../Buttons/LayoutBopomofo.libsonnet';
local commonButtons = import '../Buttons/Common.libsonnet';
local toolbarParams = import '../Buttons/Toolbar.libsonnet';
local settings = import '../Settings.libsonnet';
local basicStyle = import 'BasicStyle.libsonnet';
local preedit = import 'Preedit.libsonnet';
local toolbar = import 'Toolbar.libsonnet';
local utils = import 'Utils.libsonnet';

// 基础按键宽度：第一行11键，即 1/11
local portraitNormalButtonSize = {
  size: { width: '1/11' },
};

local keyboardLayout = {
  keyboardLayout: [
    {
      HStack: {
        spacing: 0, // 设为0，间隙由 Insets 控制
        subviews: [
          { Cell: buttons.bpmfOneButton.name }, { Cell: buttons.bpmfTwoButton.name },
          { Cell: buttons.bpmfThreeButton.name }, { Cell: buttons.bpmfFourButton.name },
          { Cell: buttons.bpmfFiveButton.name }, { Cell: buttons.bpmfSixButton.name },
          { Cell: buttons.bpmfSevenButton.name }, { Cell: buttons.bpmfEightButton.name },
          { Cell: buttons.bpmfNineButton.name }, { Cell: buttons.bpmfZeroButton.name },
          { Cell: buttons.bpmfDashButton.name },
        ],
      },
    },
    {
      HStack: {
        spacing: 0,
        subviews: [
          { Cell: buttons.qButton.name }, { Cell: buttons.wButton.name },
          { Cell: buttons.eButton.name }, { Cell: buttons.rButton.name },
          { Cell: buttons.tButton.name }, { Cell: buttons.yButton.name },
          { Cell: buttons.uButton.name }, { Cell: buttons.iButton.name },
          { Cell: buttons.oButton.name }, { Cell: buttons.pButton.name },
        ],
      },
    },
    {
      HStack: {
        spacing: 0,
        subviews: [
          { Cell: buttons.aButton.name }, { Cell: buttons.sButton.name },
          { Cell: buttons.dButton.name }, { Cell: buttons.fButton.name },
          { Cell: buttons.gButton.name }, { Cell: buttons.hButton.name },
          { Cell: buttons.jButton.name }, { Cell: buttons.kButton.name },
          { Cell: buttons.lButton.name }, { Cell: buttons.bpmfSemicolonButton.name },
        ],
      },
    },
    {
      HStack: {
        spacing: 0,
        subviews: [
          { Cell: buttons.zButton.name }, { Cell: buttons.xButton.name },
          { Cell: buttons.cButton.name }, { Cell: buttons.vButton.name },
          { Cell: buttons.bButton.name }, { Cell: buttons.nButton.name },
          { Cell: buttons.mButton.name }, { Cell: buttons.bpmfCommaButton.name },
          { Cell: buttons.bpmfPeriodButton.name }, { Cell: buttons.bpmfSlashButton.name },
          { Cell: commonButtons.backspaceButton.name },
        ],
      },
    },
    {
      HStack: {
        spacing: 0,
        subviews: [
          { Cell: commonButtons.numericButton.name },
          { Cell: buttons.commaButton.name },
          { Cell: buttons.spaceButton.name },
          { Cell: commonButtons.alphabeticButton.name },
          { Cell: buttons.enterButton.name },
        ],
      },
    },
  ],
};

// 处理中间行按键的偏移缩放，模拟 iOS 视觉
local getAlphabeticButtonSize(name) =
  local extra = {
    [buttons.qButton.name]: { size: { width: '4/33' }, bounds: { width: '3/4', alignment: 'right' } },
    [buttons.pButton.name]: { size: { width: '5/33' }, bounds: { width: '3/5', alignment: 'left' } },
    [buttons.aButton.name]: { size: { width: '5/33' }, bounds: { width: '3/5', alignment: 'right' } },
    [buttons.bpmfSemicolonButton.name]: { size: { width: '4/33' }, bounds: { width: '4/5', alignment: 'left' } },
  };
  (if std.objectHas(extra, name) then extra[name] else portraitNormalButtonSize);

local newKeyLayout(isDark=false, isPortrait=true) =
  local currentInsets = if isPortrait then commonButtons.backgroundInsets.portrait else commonButtons.backgroundInsets.landscape;

  {
    keyboardHeight: if isPortrait then commonButtons.keyboardHeight.portrait else commonButtons.keyboardHeight.landscape,
    keyboardStyle: utils.newBackgroundStyle(style=basicStyle.keyboardBackgroundStyleName),
  }
  + keyboardLayout

  // 生成所有注音/字母键
  + std.foldl(function(acc, button)
      acc +
      basicStyle.newAlphabeticButton(
        button.name,
        isDark,
        getAlphabeticButtonSize(button.name) +
        { insets: currentInsets } + // 核心：注入间隙
        button.params +
        basicStyle.hintStyleSize +
        basicStyle.textCenterWhenShowSwipeText),
      buttons.letterButtons,
      {})

  // 退格键
  + basicStyle.newSystemButton(
    commonButtons.backspaceButton.name,
    isDark,
    portraitNormalButtonSize + { insets: currentInsets } + commonButtons.backspaceButton.params,
  )

  // 最后一行
  + basicStyle.newSystemButton(
    commonButtons.numericButton.name,
    isDark,
    { size: { width: { percentage: 0.18 } }, insets: currentInsets } + commonButtons.numericButton.params
  )
  + basicStyle.newAlphabeticButton(
    buttons.commaButton.name,
    isDark,
    { size: { width: { percentage: 0.12 } }, insets: currentInsets } + buttons.commaButton.params + basicStyle.hintStyleSize,
    swipeTextFollowSetting=false,
  )
  + basicStyle.newAlphabeticButton(
    buttons.spaceButton.name,
    isDark,
    basicStyle.newSpaceButtonForegroundStyle(
        buttons.spaceButton.params + { insets: currentInsets },
        '$rimeSchemaName',
        isDark
    ),
    needHint=false,
  )
  + basicStyle.newSystemButton(
    commonButtons.alphabeticButton.name,
    isDark,
    { size: { width: { percentage: 0.15 } }, insets: currentInsets } + commonButtons.alphabeticButton.params
  )
  + basicStyle.newColorButton(
    buttons.enterButton.name,
    isDark,
    { size: { width: { percentage: 0.22 } }, insets: currentInsets } + buttons.enterButton.params
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
    + basicStyle.newAlphabeticHintBackgroundStyle(isDark, { cornerRadius: 10 }) // 提示泡泡圆角
    + basicStyle.newLongPressSymbolsBackgroundStyle(isDark, extraParams)
    + basicStyle.newLongPressSymbolsSelectedBackgroundStyle(isDark, extraParams)
    + basicStyle.newButtonAnimation()
    + newKeyLayout(isDark, isPortrait)
    + basicStyle.rimeSchemaChangedNotification
    + basicStyle.returnKeyTypeChangedNotification,
}

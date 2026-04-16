local buttons = import '../Buttons/LayoutSigma.libsonnet';
local commonButtons = import '../Buttons/Common.libsonnet';
local toolbarParams = import '../Buttons/Toolbar.libsonnet';
local settings = import '../Settings.libsonnet';
local basicStyle = import 'BasicStyle.libsonnet';
local preedit = import 'Preedit.libsonnet';
local toolbar = import 'Toolbar.libsonnet';
local utils = import 'Utils.libsonnet';

// 行高度样式定义
local firstRowStyle = {
  local this = self,
  name: 'firstRowStyle',
  style: { [this.name]: { size: { height: { percentage: 0.25 } } } },
};

local secondRowStyle = {
  local this = self,
  name: 'secondRowStyle',
  style: { [this.name]: { size: { height: { percentage: 0.27 } } } },
};

local thirdRowStyle = {
  local this = self,
  name: 'thirdRowStyle',
  style: { [this.name]: { size: { height: { percentage: 0.25 } } } },
};

local fourthRowStyle = {
  local this = self,
  name: 'fourthRowStyle',
  style: { [this.name]: { size: { height: { percentage: 0.23 } } } },
};

local keyboardLayout = {
  keyboardLayout: [
    { HStack: { style: firstRowStyle.name, subviews: [ { Cell: buttons.qButton.name }, { Cell: buttons.tButton.name }, { Cell: buttons.lButton.name }, { Cell: buttons.nButton.name }, { Cell: buttons.cButton.name } ] } },
    { HStack: { style: secondRowStyle.name, subviews: [ { Cell: buttons.jButton.name }, { Cell: buttons.eButton.name }, { Cell: buttons.oButton.name }, { Cell: buttons.yButton.name }, { Cell: buttons.zButton.name } ] } },
    { HStack: { style: thirdRowStyle.name, subviews: [ { Cell: buttons.xButton.name }, { Cell: buttons.wButton.name }, { Cell: buttons.aButton.name }, { Cell: buttons.sButton.name } ] } },
    { HStack: { style: fourthRowStyle.name, subviews: [ { Cell: commonButtons.enterButton.name }, { Cell: buttons.commaButton.name }, { Cell: commonButtons.spaceButton.name }, { Cell: commonButtons.alphabeticButton.name }, { Cell: commonButtons.backspaceButton.name } ] } },
  ],
};

local getAlphabeticButtonSize(name) =
  local extra = {
    [buttons.qButton.name]: { size: { width: { percentage: 0.18 } } },
    [buttons.tButton.name]: { size: { width: { percentage: 0.23 } } },
    [buttons.lButton.name]: { size: { width: { percentage: 0.18 } } },
    [buttons.nButton.name]: { size: { width: { percentage: 0.23 } } },
    [buttons.cButton.name]: { size: { width: { percentage: 0.18 } } },
    [buttons.jButton.name]: { size: { width: { percentage: 0.16 } } },
    [buttons.eButton.name]: { size: { width: { percentage: 0.20 } } },
    [buttons.oButton.name]: { size: { width: { percentage: 0.28 } } },
    [buttons.yButton.name]: { size: { width: { percentage: 0.20 } } },
    [buttons.zButton.name]: { size: { width: { percentage: 0.16 } } },
    [buttons.xButton.name]: { size: { width: { percentage: 0.22 } } },
    [buttons.wButton.name]: { size: { width: { percentage: 0.28 } } },
    [buttons.aButton.name]: { size: { width: { percentage: 0.28 } } },
    [buttons.sButton.name]: { size: { width: { percentage: 0.22 } } },
  };
  (if std.objectHas(extra, name) then extra[name] else {});

local newKeyLayout(isDark=false, isPortrait=true, extraParams={}) =
  local isAlphabetic = false; // Sigma 布局通常用于中文输入
  {
    keyboardHeight: if isPortrait then commonButtons.keyboardHeight.portrait else commonButtons.keyboardHeight.landscape,
    keyboardStyle: utils.newBackgroundStyle(style=basicStyle.keyboardBackgroundStyleName),
  }
  + keyboardLayout

  // 1. 字母按键循环定义
  + std.foldl(function(acc, button)
      local p = button.params + utils.processButtonParams(isAlphabetic, button.params) + extraParams;
      acc +
      basicStyle.newAlphabeticButton(
        button.name, isDark,
        p + getAlphabeticButtonSize(button.name) + basicStyle.hintStyleSize + basicStyle.textCenterWhenShowSwipeText +
        (if settings.uppercaseForChinese && std.objectHas(p, 'text') then { text: std.asciiUpper(p.text) } else {})
      ) + basicStyle.newAlphabeticButtonBackgroundStyle(isDark, p + { name: button.name }),
      buttons.letterButtons,
      {})

  // 2. Comma 键 (Sigma 布局特有位置)
  + (
    local p = buttons.commaButton.params + utils.processButtonParams(isAlphabetic, buttons.commaButton.params) + extraParams;
    basicStyle.newAlphabeticButton(
      buttons.commaButton.name, isDark,
      p + { size: { width: { percentage: 0.12 } } } + basicStyle.hintStyleSize,
      swipeTextFollowSetting=false
    ) + basicStyle.newAlphabeticButtonBackgroundStyle(isDark, p + { name: buttons.commaButton.name })
  )

  // 3. Space 键
  + (
    local p = commonButtons.spaceButton.params + utils.processButtonParams(isAlphabetic, commonButtons.spaceButton.params) + extraParams;
    basicStyle.newAlphabeticButton(
      commonButtons.spaceButton.name, isDark,
      p + basicStyle.newSpaceButtonForegroundStyle(p, '$rimeSchemaName', isDark),
      needHint=false
    )
  )

  // 4. Enter 键 (ColorButton)
  + (
    local p = commonButtons.enterButton.params + utils.processButtonParams(isAlphabetic, commonButtons.enterButton.params) + extraParams;
    basicStyle.newColorButton(commonButtons.enterButton.name, isDark, p + { size: { width: { percentage: 0.2 } } }) +
    basicStyle.newColorButtonBackgroundStyle(isDark, p + { name: commonButtons.enterButton.name })
  )

  // 5. 其他功能键 (Alphabetic 切换, Backspace)
  + (
    local p = commonButtons.alphabeticButton.params + utils.processButtonParams(isAlphabetic, commonButtons.alphabeticButton.params) + extraParams;
    basicStyle.newSystemButton(commonButtons.alphabeticButton.name, isDark, p + { size: { width: { percentage: 0.12 } } }) +
    basicStyle.newSystemButtonBackgroundStyle(isDark, p + { name: commonButtons.alphabeticButton.name })
  )
  + (
    local p = commonButtons.backspaceButton.params + utils.processButtonParams(isAlphabetic, commonButtons.backspaceButton.params) + extraParams;
    basicStyle.newSystemButton(commonButtons.backspaceButton.name, isDark, p + { size: { width: { percentage: 0.22 } } }) +
    basicStyle.newSystemButtonBackgroundStyle(isDark, p + { name: commonButtons.backspaceButton.name })
  );

// 动态计算 Insets
local backgroundInsets = if !settings.iPad then
{
  portrait: { top: 3, left: 4, bottom: 3, right: 4 },
  landscape: { top: 2, left: 3, bottom: 2, right: 3 },
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
    + firstRowStyle.style
    + secondRowStyle.style
    + thirdRowStyle.style
    + fourthRowStyle.style
    + basicStyle.newKeyboardBackgroundStyle(isDark)
    + basicStyle.newAlphabeticButtonBackgroundStyle(isDark, extraParams)
    + basicStyle.newSystemButtonBackgroundStyle(isDark, extraParams)
    + basicStyle.newColorButtonBackgroundStyle(isDark, extraParams)
    + basicStyle.newAlphabeticHintBackgroundStyle(isDark, { cornerRadius: 10 })
    + basicStyle.newLongPressSymbolsBackgroundStyle(isDark, extraParams)
    + basicStyle.newLongPressSymbolsSelectedBackgroundStyle(isDark, extraParams)
    + basicStyle.newButtonAnimation()
    + newKeyLayout(isDark, isPortrait, extraParams)
    + basicStyle.rimeSchemaChangedNotification
    + basicStyle.returnKeyTypeChangedNotification,
}

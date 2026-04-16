local numericButtons = import '../Buttons/LayoutNumeric.libsonnet';
local commonButtons = import '../Buttons/Common.libsonnet';
local fonts = import '../Constants/Fonts.libsonnet';
local basicStyle = import 'BasicStyle.libsonnet';
local preedit = import 'Preedit.libsonnet';
local toolbar = import 'Toolbar.libsonnet';
local utils = import 'Utils.libsonnet';
local settings = import '../Settings.libsonnet';

local portraitNormalButtonSize = {
  size: { width: '112.5/1125' },
};

local keyboardLayout = {
  keyboardLayout: [
    {
      VStack: {
        subviews: [
          { Cell: numericButtons.numericSymbolsCollection.name, },
          { Cell: commonButtons.gotoPrimaryKeyboardButton.name, },
        ],
      },
    },
    {
      VStack: {
        subviews: [
          { Cell: numericButtons.oneButton.name, },
          { Cell: numericButtons.fourButton.name, },
          { Cell: numericButtons.sevenButton.name, },
          { Cell: numericButtons.numericSpaceButton.name, },
        ],
      },
    },
    {
      VStack: {
        subviews: [
          { Cell: numericButtons.twoButton.name, },
          { Cell: numericButtons.fiveButton.name, },
          { Cell: numericButtons.eightButton.name, },
          { Cell: numericButtons.zeroButton.name, },
        ],
      },
    },
    {
      VStack: {
        subviews: [
          { Cell: numericButtons.threeButton.name, },
          { Cell: numericButtons.sixButton.name, },
          { Cell: numericButtons.nineButton.name, },
          { Cell: numericButtons.dotButton.name, },
        ],
      },
    },
    {
      VStack: {
        subviews: [
          { Cell: numericButtons.aHexButton.name, },
          { Cell: numericButtons.cHexButton.name, },
          { Cell: numericButtons.eHexButton.name, },
          { Cell: numericButtons.backSlashHexButton.name, },
        ],
      },
    },
    {
      VStack: {
        subviews: [
          { Cell: numericButtons.bHexButton.name, },
          { Cell: numericButtons.dHexButton.name, },
          { Cell: numericButtons.fHexButton.name, },
          { Cell: numericButtons.xHexButton.name, },
        ],
      },
    },
    {
      VStack: {
        subviews: [
          { Cell: commonButtons.backspaceButton.name, },
          { Cell: numericButtons.numericEqualButton.name, },
          { Cell: numericButtons.numericColonButton.name, },
          { Cell: commonButtons.enterButton.name, },
        ],
      },
    },
  ],
};

local newKeyLayout(isDark=false, isPortrait=false, extraParams={}) =
  // 【核心修复】极其严格的取色逻辑，彻底避开 objectHas 报错
  local getFakeColor(btn) = (
    if std.isObject(btn) && std.objectHas(btn, "params") then
      local p = btn.params;
      if std.isObject(p) && std.objectHas(p, "action") then
        local act = p.action;
        if std.isObject(act) then
          local char = if std.objectHas(act, "character") then act.character
                       else if std.objectHas(act, "symbol") then act.symbol
                       else null;
          // 映射表
          local map = { 'A':'a', 'B':'b', 'C':'c', 'D':'d', 'E':'e', 'F':'f', 'x':'x', ':':'e', '.':'j', '=':'l', '\\':'d' };
          if char != null && std.objectHas(map, char) then { action: { character: map[char] } } else {}
        else {}
      else {}
    else {}
  );

  {
    keyboardHeight: if isPortrait then commonButtons.keyboardHeight.portrait else commonButtons.keyboardHeight.landscape,
    keyboardStyle: utils.newBackgroundStyle(style=basicStyle.keyboardBackgroundStyleName),
  }
  + keyboardLayout
  // 1. 数字与字母 (A-F)
  + std.foldl(
    function(acc, button) acc +
      basicStyle.newAlphabeticButton(
        button.name,
        isDark,
        extraParams + getFakeColor(button) + { fontSize: fonts.numericButtonTextFontSize }
        + button.params + basicStyle.hintStyleSize
        + (
          if utils.numericActionNeedSymbol(settings.keyboardLayout) then
          {
            action: utils.replaceCharacterToSymbolRecursive(button.params.action),
            whenPreeditChanged: { action: button.params.action },
          }
          else {}
        ),
        needHint=false,
      ),
    numericButtons.numericButtons + [
      numericButtons.aHexButton, numericButtons.bHexButton, numericButtons.cHexButton,
      numericButtons.dHexButton, numericButtons.eHexButton, numericButtons.fHexButton,
    ],
    {})
  + {
    [numericButtons.numericSymbolsCollection.name]:
      utils.newBackgroundStyle(style=basicStyle.systemButtonBackgroundStyleName)
      + numericButtons.numericSymbolsCollection.params + extraParams,
  }
  // 2. 底部符号
  + std.foldl(
    function(acc, button) acc +
      basicStyle.newAlphabeticButton(
        button.name,
        isDark,
        extraParams + getFakeColor(button) + button.params
      ),
    [
      numericButtons.numericSpaceButton, numericButtons.dotButton,
      numericButtons.backSlashHexButton, numericButtons.xHexButton,
      numericButtons.numericEqualButton, numericButtons.numericColonButton,
    ],
    // 3. 功能键
    std.foldl(
      function(acc, button) acc +
        basicStyle.newSystemButton(
          button.name,
          isDark,
          extraParams + button.params
        ),
      [commonButtons.backspaceButton, commonButtons.enterButton],
      basicStyle.newColorButton(
          commonButtons.gotoPrimaryKeyboardButton.name,
          isDark,
          extraParams + commonButtons.gotoPrimaryKeyboardButton.params + { size: { height: '1/4' } }
        )
    ));

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
    + newKeyLayout(isDark, isPortrait, extraParams)
}

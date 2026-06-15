import 'package:flutter/material.dart';

import 'color_palette.dart';

abstract class ColorTokens {
  // Common color
  static const Color transparent = Color(0x00000000);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color yellow = Color(0xFFF5C000);
  static const Color green = Color(0xFF2E7D32);
  static const Color purple = Color(0xFF6F42C1);
  static const Color pink = Color(0xFFD81B60);
  static const Color cyan = Color(0xFF00BCD4);
  static const Color gray = Color(0xFF9E9E9E);
  static const Color grayLight = Color(0xFFF5F5F5);
  static const Color grayDark = Color(0xFF212121);
  static const Color primary = Color(0xFF155EEF);
  static const Color danger = Color(0xFFD93843);
  static const Color warning = Color(0xFFE36301);
  static const Color success = Color(0xFF2E7D32);

  // Neutral text
  static const Color text = Color(0xE0000000);
  static const Color textLight = Color(0xE0FFFFFF);
  static const Color textSecondary = Color(0xA6000000);
  static const Color textTertiary = Color(0x73000000);
  static const Color textQuaternary = Color(0x40000000);
  static const Color textHeading = text;
  static const Color textLabel = Color(0xE0000000);
  static const Color textDescription = Color(0x73000000);
  static const Color textPlaceholder = textQuaternary;
  static const Color textDisabled = textQuaternary;
  static const Color textDisabledLight = Color(0x4DFFFFFF);
  static const Color textDefault = Color(0xE0000000);
  static const Color textLink = primary;

  // Neutral backgrounds
  static const Color bgSolid = Color(0xFF000000);
  static const Color bgContainer = Color(0xD9FFFFFF);
  static const Color bgElevated = Color(0xFFFFFFFF);
  static const Color bgLayout = Color(0xFFF5F5F5);
  static const Color bgWarm = Color(0xFFFAFAFA);
  static const Color bgMask = Color(0x73000000);
  static const Color bgMaskLight = Color(0xF2FFFFFF);
  static const Color bgContainerDisabled = Color(0x0A000000);

  // Neutral borders and fills
  static const Color border = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFF0F0F0);
  static const Color borderSplit = Color(0x0F000000);
  static const Color fill = Color(0x26000000);
  static const Color fillSecondary = Color(0x0F000000);
  static const Color fillTertiary = Color(0x0A000000);
  static const Color fillQuaternary = Color(0x05000000);

  // Neutral button
  static const Color borderPrimary = primary;
  static const Color borderOutline = Color(0xFF99C6EB);
  static const Color borderDefault = Color(0xFFD9D9D9);
  static const Color borderDanger = danger;
  static const Color borderWarning = warning;
  static const Color borderSuccess = success;

  // Semantic brand colors
  static const Color primaryDefault = ColorPaletteTokens.posLightBlue600;
  static const Color primaryHover = ColorPaletteTokens.posLightBlue500;
  static const Color primaryActive = ColorPaletteTokens.posLightBlue700;
  static const Color primaryBg = ColorPaletteTokens.posLightBlue100;
  static const Color primaryBgHover = ColorPaletteTokens.posLightBlue200;
  static const Color primaryBorder = ColorPaletteTokens.posLightBlue300;
  static const Color primaryBorderHover = ColorPaletteTokens.posLightBlue400;

  static const Color successDefault = ColorPaletteTokens.posGreen600;
  static const Color successHover = ColorPaletteTokens.posGreen400;
  static const Color successActive = ColorPaletteTokens.posGreen700;
  static const Color successBg = ColorPaletteTokens.posGreen100;
  static const Color successBgHover = ColorPaletteTokens.posGreen200;
  static const Color successBorder = ColorPaletteTokens.posGreen500;
  static const Color successBorderHover = ColorPaletteTokens.posGreen400;

  static const Color warningDefault = ColorPaletteTokens.posOrange600;
  static const Color warningHover = ColorPaletteTokens.posOrange400;
  static const Color warningActive = ColorPaletteTokens.posOrange700;
  static const Color warningBg = ColorPaletteTokens.posOrange100;
  static const Color warningBgHover = ColorPaletteTokens.posOrange200;
  static const Color warningBorder = ColorPaletteTokens.posOrange500;
  static const Color warningBorderHover = ColorPaletteTokens.posOrange400;

  static const Color infoDefault = ColorPaletteTokens.posLightBlue600;
  static const Color infoHover = ColorPaletteTokens.posLightBlue500;
  static const Color infoActive = ColorPaletteTokens.posLightBlue700;
  static const Color infoBg = ColorPaletteTokens.posLightBlue100;
  static const Color infoBgHover = ColorPaletteTokens.posLightBlue200;
  static const Color infoBorder = ColorPaletteTokens.posLightBlue300;
  static const Color infoBorderHover = ColorPaletteTokens.posLightBlue400;

  static const Color dangerDefault = ColorPaletteTokens.posRed600;
  static const Color dangerHover = ColorPaletteTokens.posRed500;
  static const Color dangerActive = ColorPaletteTokens.posRed700;
  static const Color dangerBg = ColorPaletteTokens.posRed100;
  static const Color dangerBgHover = ColorPaletteTokens.posRed200;
  static const Color dangerBorder = ColorPaletteTokens.posRed500;
  static const Color dangerBorderHover = ColorPaletteTokens.posRed400;

  static const Color linkDefault = ColorPaletteTokens.posLightBlue600;
  static const Color linkHover = ColorPaletteTokens.posLightBlue500;
  static const Color linkActive = ColorPaletteTokens.posLightBlue700;

  // Compatibility aliases
  static const Color onPrimary = textLight;
  static const Color surface = bgElevated;
  static const Color onSurface = text;
  static const Color background = bgLayout;
  static const Color accent = successDefault;
  static const Color disabledText = textDisabled;
  static const Color disabledFill = bgContainerDisabled;

  static const Color error = danger;
  static const Color info = infoDefault;

  static const Color gray50 = ColorPaletteTokens.ecoInk100;
  static const Color gray100 = ColorPaletteTokens.ecoInk200;
  static const Color gray200 = ColorPaletteTokens.ecoInk300;
  static const Color gray300 = ColorPaletteTokens.ecoInk400;
  static const Color gray400 = ColorPaletteTokens.ecoInk500;
  static const Color gray500 = ColorPaletteTokens.ecoInk600;
  static const Color gray600 = ColorPaletteTokens.ecoInk700;
  static const Color gray700 = ColorPaletteTokens.ecoInk800;
  static const Color gray800 = ColorPaletteTokens.ecoInk900;
  static const Color gray900 = ColorPaletteTokens.ecoInk1000;

  static const Color iconDefault = Color(0x73000000);

  static const Color backgroundColorExample = Color(0xFFEDEDED);
}

abstract class DarkModeColorTokens {}

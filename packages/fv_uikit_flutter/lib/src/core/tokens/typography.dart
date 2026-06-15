import 'package:flutter/material.dart';

abstract class TypographyTokens {
  static const String fontFamily = 'Inter';

  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightBold = FontWeight.w700;

  static const double paragraphXsLetterSpacing = 0.16;
  static const double paragraphSLetterSpacing = 0.2;
  static const double paragraphMLetterSpacing = 0;
  static const double paragraphLLetterSpacing = 0;
  static const double paragraphXLLetterSpacing = 0;
  static const double heading4LetterSpacing = 0;
  static const double heading3LetterSpacing = -0.36;
  static const double heading2LetterSpacing = -0.56;
  static const double heading1LetterSpacing = -1.28;

  static const double paragraphXsFontSize = 12.0;
  static const double paragraphSFontSize = 14.0;
  static const double paragraphMFontSize = 16.0;
  static const double paragraphLFontSize = 18.0;
  static const double paragraphXLFontSize = 20.0;
  static const double heading4FontSize = 24.0;
  static const double heading3FontSize = 36.0;
  static const double heading2FontSize = 48.0;
  static const double heading1FontSize = 64.0;

  static const double paragraphXsLineHeight = 16.0;
  static const double paragraphSLineHeight = 20.0;
  static const double paragraphMLineHeight = 22.0;
  static const double paragraphLLineHeight = 24.0;
  static const double paragraphXLLineHeight = 28.0;
  static const double heading4LineHeight = 30.0;
  static const double heading3LineHeight = 44.0;
  static const double heading2LineHeight = 54.0;
  static const double heading1LineHeight = 76.0;
}

abstract class TextStyleTokens {
  static const TextStyle bodyXSRegular = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.paragraphXsFontSize,
    height:
        TypographyTokens.paragraphXsLineHeight /
        TypographyTokens.paragraphXsFontSize,
    fontWeight: TypographyTokens.fontWeightRegular,
    letterSpacing: TypographyTokens.paragraphXsLetterSpacing,
  );
  static const TextStyle bodyXSMedium = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.paragraphXsFontSize,
    height:
        TypographyTokens.paragraphXsLineHeight /
        TypographyTokens.paragraphXsFontSize,
    fontWeight: TypographyTokens.fontWeightMedium,
    letterSpacing: TypographyTokens.paragraphXsLetterSpacing,
  );

  static const TextStyle bodyXSBold = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.paragraphXsFontSize,
    height:
        TypographyTokens.paragraphXsLineHeight /
        TypographyTokens.paragraphXsFontSize,
    fontWeight: TypographyTokens.fontWeightBold,
    letterSpacing: TypographyTokens.paragraphXsLetterSpacing,
  );

  static const TextStyle bodySRegular = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.paragraphSFontSize,
    height:
        TypographyTokens.paragraphSLineHeight /
        TypographyTokens.paragraphSFontSize,
    fontWeight: TypographyTokens.fontWeightRegular,
    letterSpacing: TypographyTokens.paragraphSLetterSpacing,
  );

  static const TextStyle bodySMedium = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.paragraphSFontSize,
    height:
        TypographyTokens.paragraphSLineHeight /
        TypographyTokens.paragraphSFontSize,
    fontWeight: TypographyTokens.fontWeightMedium,
    letterSpacing: TypographyTokens.paragraphSLetterSpacing,
  );

  static const TextStyle bodySBold = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.paragraphSFontSize,
    height:
        TypographyTokens.paragraphSLineHeight /
        TypographyTokens.paragraphSFontSize,
    fontWeight: TypographyTokens.fontWeightBold,
    letterSpacing: TypographyTokens.paragraphSLetterSpacing,
  );

  static const TextStyle bodyMRegular = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.paragraphMFontSize,
    height:
        TypographyTokens.paragraphMLineHeight /
        TypographyTokens.paragraphMFontSize,
    fontWeight: TypographyTokens.fontWeightRegular,
    letterSpacing: TypographyTokens.paragraphMLetterSpacing,
  );

  static const TextStyle bodyMMedium = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.paragraphMFontSize,
    height:
        TypographyTokens.paragraphMLineHeight /
        TypographyTokens.paragraphMFontSize,
    fontWeight: TypographyTokens.fontWeightMedium,
    letterSpacing: TypographyTokens.paragraphMLetterSpacing,
  );

  static const TextStyle bodyMBold = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.paragraphMFontSize,
    height:
        TypographyTokens.paragraphMLineHeight /
        TypographyTokens.paragraphMFontSize,
    fontWeight: TypographyTokens.fontWeightBold,
    letterSpacing: TypographyTokens.paragraphMLetterSpacing,
  );

  static const TextStyle bodyLRegular = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.paragraphLFontSize,
    height:
        TypographyTokens.paragraphLLineHeight /
        TypographyTokens.paragraphLFontSize,
    fontWeight: TypographyTokens.fontWeightRegular,
    letterSpacing: TypographyTokens.paragraphLLetterSpacing,
  );

  static const TextStyle bodyLMedium = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.paragraphLFontSize,
    height:
        TypographyTokens.paragraphLLineHeight /
        TypographyTokens.paragraphLFontSize,
    fontWeight: TypographyTokens.fontWeightMedium,
    letterSpacing: TypographyTokens.paragraphLLetterSpacing,
  );

  static const TextStyle bodyLBold = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.paragraphLFontSize,
    height:
        TypographyTokens.paragraphLLineHeight /
        TypographyTokens.paragraphLFontSize,
    fontWeight: TypographyTokens.fontWeightBold,
    letterSpacing: TypographyTokens.paragraphLLetterSpacing,
  );

  static const TextStyle bodyXLRegular = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.paragraphXLFontSize,
    height:
        TypographyTokens.paragraphXLLineHeight /
        TypographyTokens.paragraphXLFontSize,
    fontWeight: TypographyTokens.fontWeightRegular,
    letterSpacing: TypographyTokens.paragraphXLLetterSpacing,
  );

  static const TextStyle bodyXLMedium = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.paragraphXLFontSize,
    height:
        TypographyTokens.paragraphXLLineHeight /
        TypographyTokens.paragraphXLFontSize,
    fontWeight: TypographyTokens.fontWeightMedium,
    letterSpacing: TypographyTokens.paragraphXLLetterSpacing,
  );

  static const TextStyle bodyXLBold = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.paragraphXLFontSize,
    height:
        TypographyTokens.paragraphXLLineHeight /
        TypographyTokens.paragraphXLFontSize,
    fontWeight: TypographyTokens.fontWeightBold,
    letterSpacing: TypographyTokens.paragraphXLLetterSpacing,
  );

  static const TextStyle heading4Regular = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.heading4FontSize,
    height:
        TypographyTokens.heading4LineHeight / TypographyTokens.heading4FontSize,
    fontWeight: TypographyTokens.fontWeightRegular,
    letterSpacing: TypographyTokens.heading4LetterSpacing,
  );

  static const TextStyle heading4Medium = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.heading4FontSize,
    height:
        TypographyTokens.heading4LineHeight / TypographyTokens.heading4FontSize,
    fontWeight: TypographyTokens.fontWeightMedium,
    letterSpacing: TypographyTokens.heading4LetterSpacing,
  );

  static const TextStyle heading4Bold = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.heading4FontSize,
    height:
        TypographyTokens.heading4LineHeight / TypographyTokens.heading4FontSize,
    fontWeight: TypographyTokens.fontWeightBold,
    letterSpacing: TypographyTokens.heading4LetterSpacing,
  );

  static const TextStyle heading3Regular = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.heading3FontSize,
    height:
        TypographyTokens.heading3LineHeight / TypographyTokens.heading3FontSize,
    fontWeight: TypographyTokens.fontWeightRegular,
    letterSpacing: TypographyTokens.heading3LetterSpacing,
  );

  static const TextStyle heading3Medium = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.heading3FontSize,
    height:
        TypographyTokens.heading3LineHeight / TypographyTokens.heading3FontSize,
    fontWeight: TypographyTokens.fontWeightMedium,
    letterSpacing: TypographyTokens.heading3LetterSpacing,
  );

  static const TextStyle heading3Bold = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.heading3FontSize,
    height:
        TypographyTokens.heading3LineHeight / TypographyTokens.heading3FontSize,
    fontWeight: TypographyTokens.fontWeightBold,
    letterSpacing: TypographyTokens.heading3LetterSpacing,
  );

  static const TextStyle heading2Regular = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.heading2FontSize,
    height:
        TypographyTokens.heading2LineHeight / TypographyTokens.heading2FontSize,
    fontWeight: TypographyTokens.fontWeightRegular,
    letterSpacing: TypographyTokens.heading2LetterSpacing,
  );

  static const TextStyle heading2Medium = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.heading2FontSize,
    height:
        TypographyTokens.heading2LineHeight / TypographyTokens.heading2FontSize,
    fontWeight: TypographyTokens.fontWeightMedium,
    letterSpacing: TypographyTokens.heading2LetterSpacing,
  );
  static const TextStyle heading2Bold = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.heading2FontSize,
    height:
        TypographyTokens.heading2LineHeight / TypographyTokens.heading2FontSize,
    fontWeight: TypographyTokens.fontWeightBold,
    letterSpacing: TypographyTokens.heading2LetterSpacing,
  );

  static const TextStyle heading1Regular = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.heading1FontSize,
    height:
        TypographyTokens.heading1LineHeight / TypographyTokens.heading1FontSize,
    fontWeight: TypographyTokens.fontWeightRegular,
    letterSpacing: TypographyTokens.heading1LetterSpacing,
  );
  static const TextStyle heading1Medium = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.heading1FontSize,
    height:
        TypographyTokens.heading1LineHeight / TypographyTokens.heading1FontSize,
    fontWeight: TypographyTokens.fontWeightMedium,
    letterSpacing: TypographyTokens.heading1LetterSpacing,
  );
  static const TextStyle heading1Bold = TextStyle(
    fontFamily: TypographyTokens.fontFamily,
    fontSize: TypographyTokens.heading1FontSize,
    height:
        TypographyTokens.heading1LineHeight / TypographyTokens.heading1FontSize,
    fontWeight: TypographyTokens.fontWeightBold,
    letterSpacing: TypographyTokens.heading1LetterSpacing,
  );
}

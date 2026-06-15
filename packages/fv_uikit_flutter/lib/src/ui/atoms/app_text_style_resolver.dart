import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

TextStyle resolveAppTextStyle(AppTextSize? size) {
  switch (size) {
    case AppTextSize.bodyXSRegular:
      return TextStyleTokens.bodyXSRegular;
    case AppTextSize.bodyXSMedium:
      return TextStyleTokens.bodyXSMedium;
    case AppTextSize.bodyXSBold:
      return TextStyleTokens.bodyXSBold;
    case AppTextSize.bodySRegular:
      return TextStyleTokens.bodySRegular;
    case AppTextSize.bodySMedium:
      return TextStyleTokens.bodySMedium;
    case AppTextSize.bodySBold:
      return TextStyleTokens.bodySBold;
    case AppTextSize.bodyMRegular:
      return TextStyleTokens.bodyMRegular;
    case AppTextSize.bodyMMedium:
      return TextStyleTokens.bodyMMedium;
    case AppTextSize.bodyMBold:
      return TextStyleTokens.bodyMBold;
    case AppTextSize.bodyLRegular:
      return TextStyleTokens.bodyLRegular;
    case AppTextSize.bodyLMedium:
      return TextStyleTokens.bodyLMedium;
    case AppTextSize.bodyLBold:
      return TextStyleTokens.bodyLBold;
    case AppTextSize.bodyXLRegular:
      return TextStyleTokens.bodyXLRegular;
    case AppTextSize.bodyXLMedium:
      return TextStyleTokens.bodyXLMedium;
    case AppTextSize.bodyXLBold:
      return TextStyleTokens.bodyXLBold;
    case AppTextSize.heading4Regular:
      return TextStyleTokens.heading4Regular;
    case AppTextSize.heading4Medium:
      return TextStyleTokens.heading4Medium;
    case AppTextSize.heading4Bold:
      return TextStyleTokens.heading4Bold;
    case AppTextSize.heading3Regular:
      return TextStyleTokens.heading3Regular;
    case AppTextSize.heading3Medium:
      return TextStyleTokens.heading3Medium;
    case AppTextSize.heading3Bold:
      return TextStyleTokens.heading3Bold;
    case AppTextSize.heading2Regular:
      return TextStyleTokens.heading2Regular;
    case AppTextSize.heading2Medium:
      return TextStyleTokens.heading2Medium;
    case AppTextSize.heading2Bold:
      return TextStyleTokens.heading2Bold;
    case AppTextSize.heading1Regular:
      return TextStyleTokens.heading1Regular;
    case AppTextSize.heading1Medium:
      return TextStyleTokens.heading1Medium;
    case AppTextSize.heading1Bold:
      return TextStyleTokens.heading1Bold;
    case null:
      return TextStyleTokens.bodyMRegular;
  }
}

FontWeight? resolveAppTextFontWeight(AppTextFontWeight? fontWeight) {
  switch (fontWeight) {
    case AppTextFontWeight.regular:
      return TypographyTokens.fontWeightRegular;
    case AppTextFontWeight.medium:
      return TypographyTokens.fontWeightMedium;
    case AppTextFontWeight.bold:
      return TypographyTokens.fontWeightBold;
    case null:
      return null;
  }
}

TextStyle buildAppTextStyle({
  AppTextSize? size,
  Color? color,
  double? fontSize,
  AppTextFontWeight? fontWeight,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  double? height,
}) {
  return resolveAppTextStyle(size).copyWith(
    color: color,
    fontSize: fontSize,
    fontWeight: resolveAppTextFontWeight(fontWeight),
    height: height,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
  );
}

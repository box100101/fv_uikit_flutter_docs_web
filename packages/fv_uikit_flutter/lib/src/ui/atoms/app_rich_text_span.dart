import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'app_text_style_resolver.dart';

class AppRichTextSpan extends TextSpan {
  AppRichTextSpan({
    super.text,
    super.children,
    TextStyle? style,
    AppTextSize? size,
    Color? color,
    double? fontSize,
    AppTextFontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    double? height,
    super.recognizer,
    super.semanticsLabel,
    super.locale,
  }) : super(
         style: buildAppTextStyle(
           size: size,
           color: color,
           fontSize: fontSize,
           fontWeight: fontWeight,
           fontStyle: fontStyle,
           letterSpacing: letterSpacing,
           wordSpacing: wordSpacing,
           height: height,
         ).merge(style),
       );

  factory AppRichTextSpan.text(
    String text, {
    List<InlineSpan>? children,
    TextStyle? style,
    AppTextSize? size,
    Color? color,
    double? fontSize,
    AppTextFontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    double? height,
    GestureRecognizer? recognizer,
    String? semanticsLabel,
    Locale? locale,
  }) {
    return AppRichTextSpan(
      text: text,
      children: children,
      style: style,
      size: size,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: height,
      recognizer: recognizer,
      semanticsLabel: semanticsLabel,
      locale: locale,
    );
  }
}

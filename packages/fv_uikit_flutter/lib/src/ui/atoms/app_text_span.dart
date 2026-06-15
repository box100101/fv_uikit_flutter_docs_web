import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'app_text_style_resolver.dart';

class AppTextSpan extends TextSpan {
  AppTextSpan({
    String? text,
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
  }) : super(
         text: text,
         children: children,
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
         recognizer: recognizer,
         semanticsLabel: semanticsLabel,
         locale: locale,
       );
}

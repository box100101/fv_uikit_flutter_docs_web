import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'app_text_style_resolver.dart';

class AppTextSpan extends TextSpan {
  AppTextSpan({
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
}

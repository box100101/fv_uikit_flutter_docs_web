import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'app_text_style_resolver.dart';

class AppRichText extends StatelessWidget {
  final InlineSpan? text;
  final List<InlineSpan>? spans;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final double? height;
  final Color? color;
  final double? fontSize;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final AppTextSize? size;

  const AppRichText({
    super.key,
    this.text,
    this.spans,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.strutStyle,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.height,
    this.color,
    this.fontSize,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.size,
  }) : assert(
         (text != null && spans == null) || (text == null && spans != null),
         'Provide either text or spans.',
       );

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = buildAppTextStyle(
      size: size,
      color: color,
      fontSize: fontSize,
      height: height,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
    );
    final TextStyle finalStyle = textStyle.merge(style);
    final InlineSpan finalText =
        text ?? TextSpan(children: spans ?? const <InlineSpan>[]);

    return Text.rich(
      finalText,
      style: finalStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      strutStyle: strutStyle,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
    );
  }
}

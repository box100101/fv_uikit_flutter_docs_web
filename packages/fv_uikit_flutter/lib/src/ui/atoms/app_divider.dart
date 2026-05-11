import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

class AppDivider extends StatelessWidget {
  final AppDividerOrientation? orientation;
  final AppDividerVariant? variant;
  final Color? color;
  final double? thickness;
  final double? length;
  final double? indent;
  final double? endIndent;

  const AppDivider({
    super.key,
    this.orientation = AppDividerOrientation.horizontal,
    this.variant = AppDividerVariant.defaultValue,
    this.color,
    this.thickness,
    this.length,
    this.indent,
    this.endIndent,
  });

  static const _defaultThickness = 2.0;

  AppDividerOrientation get _resolvedOrientation =>
      orientation ?? AppDividerOrientation.horizontal;

  AppDividerVariant get _resolvedVariant =>
      variant ?? AppDividerVariant.defaultValue;

  double get _resolvedThickness => thickness ?? _defaultThickness;

  Color _resolveColor() {
    if (color != null) return color!;

    switch (_resolvedVariant) {
      case AppDividerVariant.info:
        return ColorTokens.primaryBorder;
      case AppDividerVariant.warning:
        return ColorTokens.warningBorderHover;
      case AppDividerVariant.danger:
        return ColorTokens.dangerBorderHover;
      case AppDividerVariant.success:
        return ColorTokens.successBorderHover;
      case AppDividerVariant.defaultValue:
        return ColorTokens.borderDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_resolvedOrientation == AppDividerOrientation.vertical) {
      return SizedBox(
        height: length,
        child: VerticalDivider(
          width: _resolvedThickness,
          thickness: _resolvedThickness,
          indent: indent,
          endIndent: endIndent,
          color: _resolveColor(),
        ),
      );
    }

    return SizedBox(
      width: length,
      child: Divider(
        height: _resolvedThickness,
        thickness: _resolvedThickness,
        indent: indent,
        endIndent: endIndent,
        color: _resolveColor(),
      ),
    );
  }
}

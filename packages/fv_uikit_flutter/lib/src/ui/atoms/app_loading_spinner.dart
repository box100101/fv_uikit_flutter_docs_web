import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

class AppLoadingSpinner extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final double? value;
  final EdgeInsetsGeometry padding;
  final String? semanticsLabel;
  final String? semanticsValue;

  const AppLoadingSpinner({
    super.key,
    this.size = IconSizeTokens.iconSizeL,
    this.strokeWidth = 2,
    this.color,
    this.backgroundColor,
    this.value,
    this.padding = EdgeInsets.zero,
    this.semanticsLabel,
    this.semanticsValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox.square(
        dimension: size,
        child: CircularProgressIndicator(
          value: value,
          strokeWidth: strokeWidth,
          color: color ?? ColorTokens.primaryDefault,
          backgroundColor: backgroundColor,
          semanticsLabel: semanticsLabel,
          semanticsValue: semanticsValue,
        ),
      ),
    );
  }
}

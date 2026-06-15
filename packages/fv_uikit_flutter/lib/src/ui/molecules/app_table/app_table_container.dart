import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

class AppTableContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final double? maxHeight;
  final bool isVerticalScrollable;

  const AppTableContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.padding,
    this.maxHeight,
    this.isVerticalScrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? RadiusTokens.radiusMdBorderRadius;

    Widget tableWidget = child;
    if (isVerticalScrollable) {
      tableWidget = SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: tableWidget,
      );
    }

    Widget content = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: tableWidget,
    );

    if (maxHeight != null) {
      content = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight!),
        child: content,
      );
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? ColorTokens.bgContainer,
        borderRadius: effectiveBorderRadius,
        border: border ?? Border.all(color: ColorTokens.borderSecondary, width: 1),
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: content,
      ),
    );
  }
}

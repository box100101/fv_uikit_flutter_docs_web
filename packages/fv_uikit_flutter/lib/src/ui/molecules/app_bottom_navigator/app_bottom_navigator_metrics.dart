part of 'app_bottom_navigator.dart';

class _AppBottomNavigatorMetrics {
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry itemPadding;
  final double height;
  final double iconSize;
  final double itemMinWidth;
  final double borderThickness;
  final double labelTopSpacing;
  final int labelMaxLines;
  final AppTextSize selectedLabelSize;
  final AppTextSize unselectedLabelSize;

  const _AppBottomNavigatorMetrics({
    required this.padding,
    required this.itemPadding,
    required this.height,
    required this.iconSize,
    required this.itemMinWidth,
    required this.borderThickness,
    required this.labelTopSpacing,
    required this.labelMaxLines,
    required this.selectedLabelSize,
    required this.unselectedLabelSize,
  });

  factory _AppBottomNavigatorMetrics.resolve({
    EdgeInsetsGeometry? padding,
    double? height,
    double? iconSize,
    double? itemMinWidth,
    int? labelMaxLines,
  }) {
    return _AppBottomNavigatorMetrics(
      padding: padding ?? const EdgeInsets.only(top: SpacingTokens.paddingM),
      itemPadding: EdgeInsets.zero,
      height: height ?? 88,
      iconSize: iconSize ?? IconSizeTokens.iconSizeL,
      itemMinWidth: itemMinWidth ?? 88,
      borderThickness: 1,
      labelTopSpacing: SpacingTokens.gapXS,
      labelMaxLines: labelMaxLines ?? 2,
      selectedLabelSize: AppTextSize.bodySBold,
      unselectedLabelSize: AppTextSize.bodySRegular,
    );
  }
}

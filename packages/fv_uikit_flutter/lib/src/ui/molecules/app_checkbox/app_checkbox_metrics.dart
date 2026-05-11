part of 'app_checkbox.dart';

class _AppCheckboxMetrics {
  static const _xSmall = _AppCheckboxMetrics(
    controlSize: 12,
    markSize: 10,
    controlRadius: 2,
    controlBorderWidth: 1,
    contentGap: SpacingTokens.gapXS,
    boxHorizontalPadding: SpacingTokens.xPaddingXS,
    boxVerticalPadding: SpacingTokens.yPaddingXS,
    boxMinHeight: 24,
    boxRadius: RadiusTokens.radiusXS,
    selectboxCornerSize: 12,
    selectboxCornerRadius: 8,
    selectboxMarkSize: 7,
    textVariant: AppTextSize.bodyXSRegular,
  );

  static const _small = _AppCheckboxMetrics(
    controlSize: 16,
    markSize: 12,
    controlRadius: 3,
    controlBorderWidth: 1,
    contentGap: SpacingTokens.gapS,
    boxHorizontalPadding: SpacingTokens.xPaddingS,
    boxVerticalPadding: SpacingTokens.yPaddingS,
    boxMinHeight: 32,
    boxRadius: RadiusTokens.radiusS,
    selectboxCornerSize: 14,
    selectboxCornerRadius: 8,
    selectboxMarkSize: 10,
    textVariant: AppTextSize.bodySRegular,
  );

  static const _medium = _AppCheckboxMetrics(
    controlSize: 20,
    markSize: 16,
    controlRadius: RadiusTokens.radiusS,
    controlBorderWidth: 1,
    contentGap: SpacingTokens.gapS,
    boxHorizontalPadding: SpacingTokens.xPaddingM,
    boxVerticalPadding: SpacingTokens.yPaddingM,
    boxMinHeight: 42,
    boxRadius: RadiusTokens.radiusM,
    selectboxCornerSize: 18,
    selectboxCornerRadius: 10,
    selectboxMarkSize: 13,
    textVariant: AppTextSize.bodyMRegular,
  );

  static const _large = _AppCheckboxMetrics(
    controlSize: 22,
    markSize: 18,
    controlRadius: RadiusTokens.radiusM,
    controlBorderWidth: 1,
    contentGap: SpacingTokens.gapS,
    boxHorizontalPadding: SpacingTokens.xPaddingL,
    boxVerticalPadding: SpacingTokens.yPaddingL,
    boxMinHeight: 48,
    boxRadius: RadiusTokens.radiusL,
    selectboxCornerSize: 22,
    selectboxCornerRadius: 12,
    selectboxMarkSize: 16,
    textVariant: AppTextSize.bodyLRegular,
  );

  static const _xLarge = _AppCheckboxMetrics(
    controlSize: 26,
    markSize: 20,
    controlRadius: RadiusTokens.radiusM,
    controlBorderWidth: 1,
    contentGap: SpacingTokens.gapM,
    boxHorizontalPadding: SpacingTokens.xPaddingXL,
    boxVerticalPadding: SpacingTokens.yPaddingXL,
    boxMinHeight: 60,
    boxRadius: RadiusTokens.radiusL,
    selectboxCornerSize: 26,
    selectboxCornerRadius: 12,
    selectboxMarkSize: 19,
    textVariant: AppTextSize.bodyXLRegular,
  );

  final double controlSize;
  final double markSize;
  final double controlRadius;
  final double controlBorderWidth;
  final double contentGap;
  final double boxHorizontalPadding;
  final double boxVerticalPadding;
  final double boxMinHeight;
  final double boxRadius;
  final double selectboxCornerSize;
  final double selectboxCornerRadius;
  final double selectboxMarkSize;
  final AppTextSize textVariant;

  const _AppCheckboxMetrics({
    required this.controlSize,
    required this.markSize,
    required this.controlRadius,
    required this.controlBorderWidth,
    required this.contentGap,
    required this.boxHorizontalPadding,
    required this.boxVerticalPadding,
    required this.boxMinHeight,
    required this.boxRadius,
    required this.selectboxCornerSize,
    required this.selectboxCornerRadius,
    required this.selectboxMarkSize,
    required this.textVariant,
  });

  factory _AppCheckboxMetrics.fromSize(AppCheckboxSize size) {
    switch (size) {
      case AppCheckboxSize.xSmall:
        return _xSmall;
      case AppCheckboxSize.small:
        return _small;
      case AppCheckboxSize.medium:
        return _medium;
      case AppCheckboxSize.large:
        return _large;
      case AppCheckboxSize.xLarge:
        return _xLarge;
    }
  }
}

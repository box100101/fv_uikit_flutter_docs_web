part of 'app_radio.dart';

class _AppRadioMetrics {
  static const _xSmall = _AppRadioMetrics(
    controlSize: 12,
    innerDotSize: 7.2,
    controlBorderWidth: 1,
    contentGap: 6,
    boxHorizontalPadding: 8,
    boxVerticalPadding: 6,
    boxMinHeight: 12,
    textVariant: AppTextSize.bodyXSRegular,
  );

  static const _small = _AppRadioMetrics(
    controlSize: 16,
    innerDotSize: 9.6,
    controlBorderWidth: 1,
    contentGap: 6,
    boxHorizontalPadding: 10,
    boxVerticalPadding: 8,
    boxMinHeight: 16,
    textVariant: AppTextSize.bodySRegular,
  );

  static const _medium = _AppRadioMetrics(
    controlSize: 20,
    innerDotSize: 12,
    controlBorderWidth: 1.5,
    contentGap: SpacingTokens.gapS,
    boxHorizontalPadding: SpacingTokens.paddingM,
    boxVerticalPadding: SpacingTokens.paddingXS,
    boxMinHeight: 36,
    textVariant: AppTextSize.bodyMRegular,
  );

  static const _large = _AppRadioMetrics(
    controlSize: 24,
    innerDotSize: 14.4,
    controlBorderWidth: 1.5,
    contentGap: 8,
    boxHorizontalPadding: SpacingTokens.paddingL,
    boxVerticalPadding: SpacingTokens.paddingS,
    boxMinHeight: 24,
    textVariant: AppTextSize.bodyLRegular,
  );

  static const _xLarge = _AppRadioMetrics(
    controlSize: 24,
    innerDotSize: 14.4,
    controlBorderWidth: 1.5,
    contentGap: 10,
    boxHorizontalPadding: 24,
    boxVerticalPadding: 18,
    boxMinHeight: 24,
    textVariant: AppTextSize.bodyXLRegular,
  );

  final double controlSize;
  final double innerDotSize;
  final double controlBorderWidth;
  final double contentGap;
  final double boxHorizontalPadding;
  final double boxVerticalPadding;
  final double boxMinHeight;
  final AppTextSize textVariant;

  const _AppRadioMetrics({
    required this.controlSize,
    required this.innerDotSize,
    required this.controlBorderWidth,
    required this.contentGap,
    required this.boxHorizontalPadding,
    required this.boxVerticalPadding,
    required this.boxMinHeight,
    required this.textVariant,
  });

  factory _AppRadioMetrics.fromSize(AppRadioSize size) {
    switch (size) {
      case AppRadioSize.xSmall:
        return _xSmall;
      case AppRadioSize.small:
        return _small;
      case AppRadioSize.medium:
        return _medium;
      case AppRadioSize.large:
        return _large;
      case AppRadioSize.xLarge:
        return _xLarge;
    }
  }
}

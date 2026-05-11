part of 'app_button.dart';

class _AppButtonMetrics {
  static const _xSmall = _AppButtonMetrics(
    minHeight: 32,
    horizontalPadding: SpacingTokens.paddingM,
    contentGap: SpacingTokens.gapXS,
    iconSize: IconSizeTokens.iconSizeS,
    loadingIndicatorSize: IconSizeTokens.iconSizeS,
    textVariant: AppTextSize.bodyXSMedium,
  );

  static const _small = _AppButtonMetrics(
    minHeight: 40,
    horizontalPadding: SpacingTokens.paddingL,
    contentGap: 6.0,
    iconSize: IconSizeTokens.iconSizeS,
    loadingIndicatorSize: IconSizeTokens.iconSizeS,
    textVariant: AppTextSize.bodySMedium,
  );

  static const _medium = _AppButtonMetrics(
    minHeight: 48,
    horizontalPadding: SpacingTokens.paddingL,
    contentGap: SpacingTokens.gapS,
    iconSize: IconSizeTokens.iconSizeM,
    loadingIndicatorSize: IconSizeTokens.iconSizeM,
    textVariant: AppTextSize.bodyMMedium,
  );

  static const _large = _AppButtonMetrics(
    minHeight: 56,
    horizontalPadding: 20.0,
    contentGap: 10.0,
    iconSize: IconSizeTokens.iconSizeM,
    loadingIndicatorSize: IconSizeTokens.iconSizeM,
    textVariant: AppTextSize.bodyLMedium,
  );

  static const _xLarge = _AppButtonMetrics(
    minHeight: 64,
    horizontalPadding: SpacingTokens.paddingXL,
    contentGap: SpacingTokens.gapM,
    iconSize: IconSizeTokens.iconSizeL,
    loadingIndicatorSize: IconSizeTokens.iconSizeL,
    textVariant: AppTextSize.bodyXLMedium,
  );

  final double minHeight;
  final double horizontalPadding;
  final double contentGap;
  final double iconSize;
  final double loadingIndicatorSize;
  final AppTextSize textVariant;

  const _AppButtonMetrics({
    required this.minHeight,
    required this.horizontalPadding,
    required this.contentGap,
    required this.iconSize,
    required this.loadingIndicatorSize,
    required this.textVariant,
  });

  factory _AppButtonMetrics.fromSize(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.xSmall:
        return _xSmall;
      case AppButtonSize.small:
        return _small;
      case AppButtonSize.medium:
        return _medium;
      case AppButtonSize.large:
        return _large;
      case AppButtonSize.xLarge:
        return _xLarge;
    }
  }
}

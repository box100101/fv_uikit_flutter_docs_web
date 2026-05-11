part of 'app_switch.dart';

class _AppSwitchMetrics {
  static const _xSmall = _AppSwitchMetrics(
    trackWidth: 20,
    trackHeight: 10,
    thumbInset: 1,
    contentGap: 6,
    textVariant: AppTextSize.bodyXSRegular,
  );

  static const _small = _AppSwitchMetrics(
    trackWidth: 24,
    trackHeight: 12,
    thumbInset: 1,
    contentGap: 6,
    textVariant: AppTextSize.bodySRegular,
  );

  static const _medium = _AppSwitchMetrics(
    trackWidth: 32,
    trackHeight: 16,
    thumbInset: 1.5,
    contentGap: SpacingTokens.gapS,
    textVariant: AppTextSize.bodyMRegular,
  );

  static const _large = _AppSwitchMetrics(
    trackWidth: 32,
    trackHeight: 16,
    thumbInset: 2,
    contentGap: 8,
    textVariant: AppTextSize.bodyLRegular,
  );

  static const _xLarge = _AppSwitchMetrics(
    trackWidth: 48,
    trackHeight: 24,
    thumbInset: 2,
    contentGap: 10,
    textVariant: AppTextSize.bodyXLRegular,
  );

  final double trackWidth;
  final double trackHeight;
  final double thumbInset;
  final double contentGap;
  final AppTextSize textVariant;

  double get thumbSize => trackHeight - (thumbInset * 2);

  const _AppSwitchMetrics({
    required this.trackWidth,
    required this.trackHeight,
    required this.thumbInset,
    required this.contentGap,
    required this.textVariant,
  });

  factory _AppSwitchMetrics.fromSize(AppSwitchSize size) {
    switch (size) {
      case AppSwitchSize.xSmall:
        return _xSmall;
      case AppSwitchSize.small:
        return _small;
      case AppSwitchSize.medium:
        return _medium;
      case AppSwitchSize.large:
        return _large;
      case AppSwitchSize.xLarge:
        return _xLarge;
    }
  }
}

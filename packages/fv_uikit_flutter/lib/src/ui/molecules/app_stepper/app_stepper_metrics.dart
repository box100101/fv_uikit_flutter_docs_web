part of 'app_stepper.dart';

class _AppStepperMetrics {
  static const _small = _AppStepperMetrics(
    buttonSize: 28,
    iconSize: 14,
    inputWidth: 36,
    textSize: AppTextSize.bodyXSMedium,
    borderRadius: RadiusTokens.radiusS,
  );

  static const _medium = _AppStepperMetrics(
    buttonSize: 32,
    iconSize: 16,
    inputWidth: 44,
    textSize: AppTextSize.bodySMedium,
    borderRadius: RadiusTokens.radiusM,
  );

  static const _large = _AppStepperMetrics(
    buttonSize: 40,
    iconSize: 18,
    inputWidth: 52,
    textSize: AppTextSize.bodyMMedium,
    borderRadius: RadiusTokens.radiusM,
  );

  final double buttonSize;
  final double iconSize;
  final double inputWidth;
  final AppTextSize textSize;
  final double borderRadius;

  const _AppStepperMetrics({
    required this.buttonSize,
    required this.iconSize,
    required this.inputWidth,
    required this.textSize,
    required this.borderRadius,
  });

  factory _AppStepperMetrics.fromSize(AppStepperSize size) {
    switch (size) {
      case AppStepperSize.small:
        return _small;
      case AppStepperSize.medium:
        return _medium;
      case AppStepperSize.large:
        return _large;
    }
  }
}

part of 'app_numpad.dart';

class _AppNumpadMetrics {
  static const _medium = _AppNumpadMetrics(
    fontSize: 20,
    keyPadding: 12.0,
    borderRadius: RadiusTokens.radiusS,
    childAspectRatio: 1.2,
    crossAxisSpacing: 3.0,
    mainAxisSpacing: 3.0,
  );

  static const _large = _AppNumpadMetrics(
    fontSize: 24,
    keyPadding: 16.0,
    borderRadius: RadiusTokens.radiusM,
    childAspectRatio: 1.4,
    crossAxisSpacing: 4.0,
    mainAxisSpacing: 4.0,
  );

  final double fontSize;
  final double keyPadding;
  final double borderRadius;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  const _AppNumpadMetrics({
    required this.fontSize,
    required this.keyPadding,
    required this.borderRadius,
    required this.childAspectRatio,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
  });

  factory _AppNumpadMetrics.fromSize(AppNumpadSize size) {
    switch (size) {
      case AppNumpadSize.medium:
        return _medium;
      case AppNumpadSize.large:
        return _large;
    }
  }
}

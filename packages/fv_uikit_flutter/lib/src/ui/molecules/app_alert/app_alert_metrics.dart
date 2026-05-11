part of 'app_alert.dart';

class _AppAlertMetrics {
  static const _xSmall = _AppAlertMetrics(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    gap: 4,
    contentGap: 4,
    actionGap: 12,
    iconSize: IconSizeTokens.iconSizeES,
    closeIconSize: IconSizeTokens.iconSizeES,
    closeButtonSize: 12,
    lineHeight: TypographyTokens.paragraphXsLineHeight,
    actionMinHeight: 24,
    titleTextSize: AppTextSize.bodyXSMedium,
    descriptionTextSize: AppTextSize.bodyXSRegular,
    actionTextSize: AppTextSize.bodyXSMedium,
  );

  static const _small = _AppAlertMetrics(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    gap: 8,
    contentGap: 8,
    actionGap: 12,
    iconSize: IconSizeTokens.iconSizeS,
    closeIconSize: IconSizeTokens.iconSizeS,
    closeButtonSize: 16,
    lineHeight: TypographyTokens.paragraphSLineHeight,
    actionMinHeight: 32,
    titleTextSize: AppTextSize.bodySMedium,
    descriptionTextSize: AppTextSize.bodySRegular,
    actionTextSize: AppTextSize.bodySMedium,
  );

  static const _medium = _AppAlertMetrics(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    gap: 8,
    contentGap: 8,
    actionGap: 24,
    iconSize: IconSizeTokens.iconSizeM,
    closeIconSize: IconSizeTokens.iconSizeM,
    closeButtonSize: 22,
    lineHeight: TypographyTokens.paragraphMLineHeight,
    actionMinHeight: 40,
    titleTextSize: AppTextSize.bodyMMedium,
    descriptionTextSize: AppTextSize.bodyMRegular,
    actionTextSize: AppTextSize.bodyMMedium,
  );

  static const _large = _AppAlertMetrics(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    gap: 8,
    contentGap: 8,
    actionGap: 28,
    iconSize: IconSizeTokens.iconSizeL,
    closeIconSize: IconSizeTokens.iconSizeL,
    closeButtonSize: 24,
    lineHeight: TypographyTokens.paragraphLLineHeight,
    actionMinHeight: 48,
    titleTextSize: AppTextSize.bodyLMedium,
    descriptionTextSize: AppTextSize.bodyLRegular,
    actionTextSize: AppTextSize.bodyLMedium,
  );

  static const _xLarge = _AppAlertMetrics(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    gap: 8,
    contentGap: 8,
    actionGap: 32,
    iconSize: IconSizeTokens.iconSize2XL,
    closeIconSize: IconSizeTokens.iconSize2XL,
    closeButtonSize: 24,
    lineHeight: TypographyTokens.paragraphXLLineHeight,
    actionMinHeight: 56,
    titleTextSize: AppTextSize.bodyXLMedium,
    descriptionTextSize: AppTextSize.bodyXLRegular,
    actionTextSize: AppTextSize.bodyXLMedium,
  );

  final EdgeInsetsGeometry padding;
  final double gap;
  final double contentGap;
  final double actionGap;
  final double iconSize;
  final double closeIconSize;
  final double closeButtonSize;
  final double lineHeight;
  final double actionMinHeight;
  final AppTextSize titleTextSize;
  final AppTextSize descriptionTextSize;
  final AppTextSize actionTextSize;

  const _AppAlertMetrics({
    required this.padding,
    required this.gap,
    required this.contentGap,
    required this.actionGap,
    required this.iconSize,
    required this.closeIconSize,
    required this.closeButtonSize,
    required this.lineHeight,
    required this.actionMinHeight,
    required this.titleTextSize,
    required this.descriptionTextSize,
    required this.actionTextSize,
  });

  factory _AppAlertMetrics.fromSize(AppAlertSize size) {
    switch (size) {
      case AppAlertSize.xSmall:
        return _xSmall;
      case AppAlertSize.small:
        return _small;
      case AppAlertSize.medium:
        return _medium;
      case AppAlertSize.large:
        return _large;
      case AppAlertSize.xLarge:
        return _xLarge;
    }
  }
}

abstract class _AppAlertColorTokens {
  static const Color fallbackBackground = ColorTokens.white;
  static const Color fallbackIcon = Color(0xFF8C8C8C);
  static const Color infoBackground = Color(0xFFE6F1FB);
  static const Color warningBackground = Color(0xFFFFF5EB);
  static const Color dangerBackground = Color(0xFFFFF0F1);
  static const Color successBackground = Color(0xFFEFFFF4);
  static const Color closeIcon = Color(0x73000000);
  static const Color actionText = ColorTokens.primary;
}

import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

class AppBadge extends StatelessWidget {
  final String text;
  final Widget? leading;
  final AppBadgeVariant? variant;
  final AppBadgeSize? size;
  final AppTextSize? textSize;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final double? gap;
  final double? radius;

  const AppBadge({
    super.key,
    required this.text,
    this.leading,
    this.variant = AppBadgeVariant.neutral,
    this.size = AppBadgeSize.medium,
    this.textSize,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.textStyle,
    this.padding,
    this.gap,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final metrics = _AppBadgeMetrics.fromSize(size ?? AppBadgeSize.medium);
    final resolvedTextSize = textSize ?? metrics.textSize;
    final colors = _AppBadgeColors.fromVariant(
      variant ?? AppBadgeVariant.neutral,
    );
    final resolvedTextColor = textColor ?? colors.foregroundColor;
    final resolvedIconColor = iconColor ?? resolvedTextColor;

    return Semantics(
      label: text,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? colors.backgroundColor,
          borderRadius: BorderRadius.circular(radius ?? metrics.borderRadius),
        ),
        child: Padding(
          padding: padding ?? metrics.padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[
                IconTheme.merge(
                  data: IconThemeData(
                    size: metrics.iconSize,
                    color: resolvedIconColor,
                  ),
                  child: leading!,
                ),
                SizedBox(width: gap ?? metrics.gap),
              ],
              Flexible(
                child: AppText(
                  text: text,
                  size: resolvedTextSize,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: resolvedTextColor,
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBadgeColors {
  final Color backgroundColor;
  final Color foregroundColor;

  const _AppBadgeColors({
    required this.backgroundColor,
    required this.foregroundColor,
  });

  factory _AppBadgeColors.fromVariant(AppBadgeVariant variant) {
    switch (variant) {
      case AppBadgeVariant.neutral:
        return const _AppBadgeColors(
          backgroundColor: ColorTokens.fillTertiary,
          foregroundColor: ColorTokens.textDefault,
        );
      case AppBadgeVariant.info:
        return const _AppBadgeColors(
          backgroundColor: ColorTokens.infoBg,
          foregroundColor: ColorTokens.infoActive,
        );
      case AppBadgeVariant.success:
        return const _AppBadgeColors(
          backgroundColor: ColorTokens.successBg,
          foregroundColor: ColorTokens.successActive,
        );
      case AppBadgeVariant.warning:
        return const _AppBadgeColors(
          backgroundColor: ColorTokens.warningBg,
          foregroundColor: ColorTokens.warningActive,
        );
      case AppBadgeVariant.danger:
        return const _AppBadgeColors(
          backgroundColor: ColorTokens.dangerBg,
          foregroundColor: ColorTokens.dangerActive,
        );
    }
  }
}

class _AppBadgeMetrics {
  final EdgeInsetsGeometry padding;
  final double gap;
  final double iconSize;
  final double borderRadius;
  final AppTextSize textSize;

  const _AppBadgeMetrics({
    required this.padding,
    required this.gap,
    required this.iconSize,
    required this.borderRadius,
    required this.textSize,
  });

  static const _xSmall = _AppBadgeMetrics(
    padding: EdgeInsets.symmetric(
      horizontal: SpacingTokens.paddingS,
      vertical: SpacingTokens.yPaddingXS,
    ),
    gap: SpacingTokens.gapXS,
    iconSize: 14,
    borderRadius: 999,
    textSize: AppTextSize.bodyXSBold,
  );

  static const _small = _AppBadgeMetrics(
    padding: EdgeInsets.symmetric(
      horizontal: SpacingTokens.paddingM,
      vertical: SpacingTokens.yPaddingS,
    ),
    gap: SpacingTokens.gapXS,
    iconSize: 16,
    borderRadius: 999,
    textSize: AppTextSize.bodySBold,
  );

  static const _medium = _AppBadgeMetrics(
    padding: EdgeInsets.symmetric(
      horizontal: SpacingTokens.paddingL,
      vertical: SpacingTokens.yPaddingM,
    ),
    gap: SpacingTokens.gapS,
    iconSize: 20,
    borderRadius: 999,
    textSize: AppTextSize.bodyMBold,
  );

  static const _large = _AppBadgeMetrics(
    padding: EdgeInsets.symmetric(
      horizontal: SpacingTokens.paddingXL,
      vertical: SpacingTokens.paddingL,
    ),
    gap: SpacingTokens.gapM,
    iconSize: 24,
    borderRadius: 999,
    textSize: AppTextSize.bodyLBold,
  );

  static const _xLarge = _AppBadgeMetrics(
    padding: EdgeInsets.symmetric(
      horizontal: SpacingTokens.padding2XL,
      vertical: SpacingTokens.paddingL,
    ),
    gap: SpacingTokens.gapM,
    iconSize: 28,
    borderRadius: 999,
    textSize: AppTextSize.bodyXLBold,
  );

  factory _AppBadgeMetrics.fromSize(AppBadgeSize size) {
    switch (size) {
      case AppBadgeSize.xSmall:
        return _xSmall;
      case AppBadgeSize.small:
        return _small;
      case AppBadgeSize.medium:
        return _medium;
      case AppBadgeSize.large:
        return _large;
      case AppBadgeSize.xLarge:
        return _xLarge;
    }
  }
}

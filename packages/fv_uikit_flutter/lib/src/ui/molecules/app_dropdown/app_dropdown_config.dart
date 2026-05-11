import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

abstract final class AppDropdownTokens {
  static const Radius radius = Radius.circular(6);
  static const BorderRadius borderRadius = BorderRadius.all(radius);
  static const BorderRadius topBorderRadius = BorderRadius.vertical(
    top: radius,
  );
  static const BorderRadius bottomBorderRadius = BorderRadius.vertical(
    bottom: radius,
  );

  static const Color stripedBackground = Color(0xFFF5F5F5);

  static const double defaultMenuMaxHeight = 200;
  static const double defaultLoadMoreTriggerOffset = 48;
}

class AppDropdownMetrics {
  static const _extraSmall = AppDropdownMetrics(
    height: 24,
    triggerHorizontalPadding: SpacingTokens.paddingXS,
    triggerVerticalPadding: SpacingTokens.paddingXS,
    itemHorizontalPadding: SpacingTokens.paddingS,
    itemVerticalPadding: SpacingTokens.paddingXS,
    borderRadius: RadiusTokens.radiusXS,
    iconSize: 16,
    textSize: AppTextSize.bodyXSRegular,
    searchFieldSize: AppTextFieldSize.xSmall,
    retryButtonSize: AppButtonSize.xSmall,
  );

  static const _small = AppDropdownMetrics(
    height: 32,
    triggerHorizontalPadding: SpacingTokens.paddingS,
    triggerVerticalPadding: SpacingTokens.paddingXS,
    itemHorizontalPadding: SpacingTokens.paddingS,
    itemVerticalPadding: SpacingTokens.paddingXS,
    borderRadius: RadiusTokens.radiusS,
    iconSize: 16,
    textSize: AppTextSize.bodySRegular,
    searchFieldSize: AppTextFieldSize.small,
    retryButtonSize: AppButtonSize.small,
  );

  static const _medium = AppDropdownMetrics(
    height: 40,
    triggerHorizontalPadding: SpacingTokens.paddingM,
    triggerVerticalPadding: SpacingTokens.paddingS,
    itemHorizontalPadding: SpacingTokens.paddingM,
    itemVerticalPadding: SpacingTokens.paddingM,
    borderRadius: RadiusTokens.radiusM,
    iconSize: 20,
    textSize: AppTextSize.bodyMRegular,
    searchFieldSize: AppTextFieldSize.medium,
    retryButtonSize: AppButtonSize.medium,
  );

  static const _large = AppDropdownMetrics(
    height: 48,
    triggerHorizontalPadding: SpacingTokens.paddingL,
    triggerVerticalPadding: SpacingTokens.paddingM,
    itemHorizontalPadding: SpacingTokens.paddingL,
    itemVerticalPadding: SpacingTokens.paddingM,
    borderRadius: RadiusTokens.radiusL,
    iconSize: 20,
    textSize: AppTextSize.bodyLRegular,
    searchFieldSize: AppTextFieldSize.large,
    retryButtonSize: AppButtonSize.large,
  );

  static const _extraLarge = AppDropdownMetrics(
    height: 56,
    triggerHorizontalPadding: SpacingTokens.paddingXL,
    triggerVerticalPadding: SpacingTokens.paddingM,
    itemHorizontalPadding: SpacingTokens.paddingXL,
    itemVerticalPadding: SpacingTokens.paddingM,
    borderRadius: RadiusTokens.radiusXL,
    iconSize: 24,
    textSize: AppTextSize.bodyXLRegular,
    searchFieldSize: AppTextFieldSize.xLarge,
    retryButtonSize: AppButtonSize.xLarge,
  );

  final double height;
  final double triggerHorizontalPadding;
  final double triggerVerticalPadding;
  final double itemHorizontalPadding;
  final double itemVerticalPadding;
  final double borderRadius;
  final double iconSize;
  final AppTextSize textSize;
  final AppTextFieldSize searchFieldSize;
  final AppButtonSize retryButtonSize;

  const AppDropdownMetrics({
    required this.height,
    required this.triggerHorizontalPadding,
    required this.triggerVerticalPadding,
    required this.itemHorizontalPadding,
    required this.itemVerticalPadding,
    required this.borderRadius,
    required this.iconSize,
    required this.textSize,
    required this.searchFieldSize,
    required this.retryButtonSize,
  });

  factory AppDropdownMetrics.fromSize(AppDropdownSize size) {
    switch (size) {
      case AppDropdownSize.xSmall:
        return _extraSmall;
      case AppDropdownSize.small:
        return _small;
      case AppDropdownSize.medium:
        return _medium;
      case AppDropdownSize.large:
        return _large;
      case AppDropdownSize.xLarge:
        return _extraLarge;
    }
  }
}

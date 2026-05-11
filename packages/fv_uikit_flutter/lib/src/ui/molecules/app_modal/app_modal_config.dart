import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

class AppModalMetrics {
  static const _xSmall = AppModalMetrics(
    maxWidth: 250,
    padding: 16,
    sectionGap: 20,
    headerGap: 12,
    bodyGap: 8,
    footerGap: 12,
    closeButtonSize: 32,
    closeIconSize: 24,
    headerIconSize: 21,
    titleTextSize: AppTextSize.bodyLBold,
    descriptionTextSize: AppTextSize.bodySRegular,
    iconBackSize: 24,
    buttonSize: AppButtonSize.small,
  );

  static const _small = AppModalMetrics(
    maxWidth: 320,
    padding: 16,
    sectionGap: 24,
    headerGap: 16,
    bodyGap: 12,
    footerGap: 16,
    closeButtonSize: 32,
    closeIconSize: 24,
    headerIconSize: 28,
    titleTextSize: AppTextSize.bodyLBold,
    descriptionTextSize: AppTextSize.bodyMRegular,
    iconBackSize: 24,
    buttonSize: AppButtonSize.small,
  );

  static const _medium = AppModalMetrics(
    maxWidth: 480,
    padding: 24,
    sectionGap: 28,
    headerGap: 16,
    bodyGap: 16,
    footerGap: 16,
    closeButtonSize: 32,
    closeIconSize: 24,
    headerIconSize: 42,
    titleTextSize: AppTextSize.bodyLBold,
    descriptionTextSize: AppTextSize.bodyMRegular,
    iconBackSize: 24,
    buttonSize: AppButtonSize.small,
  );

  static const _large = AppModalMetrics(
    maxWidth: 640,
    padding: 24,
    sectionGap: 28,
    headerGap: 16,
    bodyGap: 16,
    footerGap: 16,
    closeButtonSize: 32,
    closeIconSize: 24,
    headerIconSize: 56,
    titleTextSize: AppTextSize.bodyLBold,
    descriptionTextSize: AppTextSize.bodyMRegular,
    iconBackSize: 24,
    buttonSize: AppButtonSize.small,
  );

  static const _xLarge = AppModalMetrics(
    maxWidth: 800,
    padding: 24,
    sectionGap: 28,
    headerGap: 16,
    bodyGap: 16,
    footerGap: 16,
    closeButtonSize: 32,
    closeIconSize: 24,
    headerIconSize: 28,
    titleTextSize: AppTextSize.heading4Bold,
    descriptionTextSize: AppTextSize.bodyMRegular,
    iconBackSize: 24,
    buttonSize: AppButtonSize.small,
  );

  final double maxWidth;
  final double padding;
  final double sectionGap;
  final double headerGap;
  final double bodyGap;
  final double footerGap;
  final double closeButtonSize;
  final double closeIconSize;
  final double headerIconSize;
  final AppTextSize titleTextSize;
  final AppTextSize descriptionTextSize;
  final double iconBackSize;
  final AppButtonSize buttonSize;

  const AppModalMetrics({
    required this.maxWidth,
    required this.padding,
    required this.sectionGap,
    required this.headerGap,
    required this.bodyGap,
    required this.footerGap,
    required this.closeButtonSize,
    required this.closeIconSize,
    required this.headerIconSize,
    required this.titleTextSize,
    required this.descriptionTextSize,
    required this.iconBackSize,
    required this.buttonSize,
  });

  factory AppModalMetrics.fromSize(AppModalSize size) {
    switch (size) {
      case AppModalSize.xSmall:
        return _xSmall;
      case AppModalSize.small:
        return _small;
      case AppModalSize.medium:
        return _medium;
      case AppModalSize.large:
        return _large;
      case AppModalSize.xLarge:
        return _xLarge;
    }
  }
}

class AppModalTypesConfig {
  final Widget? headerIcon;
  final AppButtonVariant primaryButtonVariant;
  final AppButtonVariant? secondaryButtonVariant;
  final AlignmentGeometry? headerAlignment;
  final bool isShowBackButton;

  const AppModalTypesConfig({
    this.headerIcon,
    required this.primaryButtonVariant,
    this.secondaryButtonVariant,
    this.headerAlignment,
    this.isShowBackButton = false,
  });
}

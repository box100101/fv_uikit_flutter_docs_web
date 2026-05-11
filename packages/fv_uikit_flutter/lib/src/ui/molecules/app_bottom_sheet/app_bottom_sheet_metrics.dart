part of 'app_bottom_sheet.dart';

class _AppBottomSheetMetrics {
  static const _xSmall = _AppBottomSheetMetrics(
    maxHeightFactor: 0.35,
    padding: SpacingTokens.paddingL,
    sectionGap: SpacingTokens.gapL,
    headerGap: SpacingTokens.gapS,
    bodyGap: SpacingTokens.gapS,
    footerGap: SpacingTokens.gapS,
    closeButtonSize: 32,
    closeIconSize: 22,
    dragHandleWidth: 40,
    dragHandleHeight: 4,
    dragHandleBottomGap: SpacingTokens.spaceXS,
    titleTextSize: AppTextSize.bodyLBold,
    descriptionTextSize: AppTextSize.bodySRegular,
    buttonSize: AppButtonSize.small,
  );

  static const _small = _AppBottomSheetMetrics(
    maxHeightFactor: 0.45,
    padding: SpacingTokens.paddingL,
    sectionGap: SpacingTokens.gapL,
    headerGap: SpacingTokens.gapS,
    bodyGap: SpacingTokens.gapM,
    footerGap: SpacingTokens.gapS,
    closeButtonSize: 32,
    closeIconSize: 22,
    dragHandleWidth: 40,
    dragHandleHeight: 4,
    dragHandleBottomGap: SpacingTokens.spaceXS,
    titleTextSize: AppTextSize.bodyLBold,
    descriptionTextSize: AppTextSize.bodyMRegular,
    buttonSize: AppButtonSize.small,
  );

  static const _medium = _AppBottomSheetMetrics(
    maxHeightFactor: 0.6,
    padding: SpacingTokens.paddingXL,
    sectionGap: SpacingTokens.gapL,
    headerGap: SpacingTokens.gapM,
    bodyGap: SpacingTokens.gapM,
    footerGap: SpacingTokens.gapS,
    closeButtonSize: 36,
    closeIconSize: 24,
    dragHandleWidth: 44,
    dragHandleHeight: 4,
    dragHandleBottomGap: SpacingTokens.gapXS,
    titleTextSize: AppTextSize.bodyLBold,
    descriptionTextSize: AppTextSize.bodyMRegular,
    buttonSize: AppButtonSize.medium,
  );

  static const _large = _AppBottomSheetMetrics(
    maxHeightFactor: 0.75,
    padding: SpacingTokens.paddingXL,
    sectionGap: SpacingTokens.gapXL,
    headerGap: SpacingTokens.gapM,
    bodyGap: SpacingTokens.gapM,
    footerGap: SpacingTokens.gapM,
    closeButtonSize: 36,
    closeIconSize: 24,
    dragHandleWidth: 44,
    dragHandleHeight: 4,
    dragHandleBottomGap: SpacingTokens.gapXS,
    titleTextSize: AppTextSize.bodyLBold,
    descriptionTextSize: AppTextSize.bodyMRegular,
    buttonSize: AppButtonSize.medium,
  );

  static const _xLarge = _AppBottomSheetMetrics(
    maxHeightFactor: 0.9,
    padding: SpacingTokens.paddingXL,
    sectionGap: SpacingTokens.gapXL,
    headerGap: SpacingTokens.gapM,
    bodyGap: SpacingTokens.gapL,
    footerGap: SpacingTokens.gapM,
    closeButtonSize: 40,
    closeIconSize: 24,
    dragHandleWidth: 48,
    dragHandleHeight: 4,
    dragHandleBottomGap: SpacingTokens.gapXS,
    titleTextSize: AppTextSize.heading4Bold,
    descriptionTextSize: AppTextSize.bodyMRegular,
    buttonSize: AppButtonSize.medium,
  );

  final double maxHeightFactor;
  final double padding;
  final double sectionGap;
  final double headerGap;
  final double bodyGap;
  final double footerGap;
  final double closeButtonSize;
  final double closeIconSize;
  final double dragHandleWidth;
  final double dragHandleHeight;
  final double dragHandleBottomGap;
  final AppTextSize titleTextSize;
  final AppTextSize descriptionTextSize;
  final AppButtonSize buttonSize;

  const _AppBottomSheetMetrics({
    required this.maxHeightFactor,
    required this.padding,
    required this.sectionGap,
    required this.headerGap,
    required this.bodyGap,
    required this.footerGap,
    required this.closeButtonSize,
    required this.closeIconSize,
    required this.dragHandleWidth,
    required this.dragHandleHeight,
    required this.dragHandleBottomGap,
    required this.titleTextSize,
    required this.descriptionTextSize,
    required this.buttonSize,
  });

  factory _AppBottomSheetMetrics.fromSize(AppBottomSheetSize size) {
    switch (size) {
      case AppBottomSheetSize.xSmall:
        return _xSmall;
      case AppBottomSheetSize.small:
        return _small;
      case AppBottomSheetSize.medium:
        return _medium;
      case AppBottomSheetSize.large:
        return _large;
      case AppBottomSheetSize.xLarge:
        return _xLarge;
    }
  }
}

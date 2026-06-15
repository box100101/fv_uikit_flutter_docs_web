part of 'app_bottom_sheet_select.dart';

enum _AppBottomSheetSelectKind { single, multi }

class _AppBottomSheetSelectViewState<T> {
  final List<T> items;
  final bool showLoadingState;
  final bool showErrorState;
  final bool showEmptyState;
  final bool showLoadMoreFooter;

  const _AppBottomSheetSelectViewState({
    required this.items,
    required this.showLoadingState,
    required this.showErrorState,
    required this.showEmptyState,
    required this.showLoadMoreFooter,
  });

  int get totalCount => items.length + (showLoadMoreFooter ? 1 : 0);

  bool isFooterIndex(int index) => showLoadMoreFooter && index == items.length;
}

class _AppBottomSheetSelectMetrics {
  final double itemHorizontalPadding;
  final double itemVerticalPadding;
  final double estimatedItemHeight;
  final AppTextSize itemTextSize;
  final AppTextSize descriptionTextSize;
  final AppTextFieldSize searchFieldSize;
  final AppButtonSize retryButtonSize;

  const _AppBottomSheetSelectMetrics({
    required this.itemHorizontalPadding,
    required this.itemVerticalPadding,
    required this.estimatedItemHeight,
    required this.itemTextSize,
    required this.descriptionTextSize,
    required this.searchFieldSize,
    required this.retryButtonSize,
  });

  factory _AppBottomSheetSelectMetrics.fromFieldSize(AppTextFieldSize size) {
    switch (size) {
      case AppTextFieldSize.xSmall:
        return const _AppBottomSheetSelectMetrics(
          itemHorizontalPadding: SpacingTokens.paddingS,
          itemVerticalPadding: SpacingTokens.paddingS,
          estimatedItemHeight: 52,
          itemTextSize: AppTextSize.bodySRegular,
          descriptionTextSize: AppTextSize.bodyXSRegular,
          searchFieldSize: AppTextFieldSize.small,
          retryButtonSize: AppButtonSize.small,
        );
      case AppTextFieldSize.small:
        return const _AppBottomSheetSelectMetrics(
          itemHorizontalPadding: SpacingTokens.paddingS,
          itemVerticalPadding: SpacingTokens.paddingS,
          estimatedItemHeight: 56,
          itemTextSize: AppTextSize.bodySRegular,
          descriptionTextSize: AppTextSize.bodyXSRegular,
          searchFieldSize: AppTextFieldSize.small,
          retryButtonSize: AppButtonSize.small,
        );
      case AppTextFieldSize.medium:
        return const _AppBottomSheetSelectMetrics(
          itemHorizontalPadding: SpacingTokens.paddingM,
          itemVerticalPadding: SpacingTokens.paddingM,
          estimatedItemHeight: 64,
          itemTextSize: AppTextSize.bodyMRegular,
          descriptionTextSize: AppTextSize.bodySRegular,
          searchFieldSize: AppTextFieldSize.medium,
          retryButtonSize: AppButtonSize.medium,
        );
      case AppTextFieldSize.large:
        return const _AppBottomSheetSelectMetrics(
          itemHorizontalPadding: SpacingTokens.paddingL,
          itemVerticalPadding: SpacingTokens.paddingM,
          estimatedItemHeight: 72,
          itemTextSize: AppTextSize.bodyLRegular,
          descriptionTextSize: AppTextSize.bodyMRegular,
          searchFieldSize: AppTextFieldSize.large,
          retryButtonSize: AppButtonSize.large,
        );
      case AppTextFieldSize.xLarge:
        return const _AppBottomSheetSelectMetrics(
          itemHorizontalPadding: SpacingTokens.paddingXL,
          itemVerticalPadding: SpacingTokens.paddingL,
          estimatedItemHeight: 80,
          itemTextSize: AppTextSize.bodyXLRegular,
          descriptionTextSize: AppTextSize.bodyLRegular,
          searchFieldSize: AppTextFieldSize.xLarge,
          retryButtonSize: AppButtonSize.xLarge,
        );
    }
  }
}

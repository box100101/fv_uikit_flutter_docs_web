import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

// ---------------------------------------------------------------------------
// AppListSection — represents a group of items with a header
// ---------------------------------------------------------------------------

/// A section of items with a title header, used in [AppSectionList].
class AppListSection<T> {
  /// Display title of the section header.
  final String title;

  /// Items that belong to this section.
  final List<T> items;

  /// Optional trailing widget in the section header (e.g. count badge).
  final Widget? trailing;

  /// Whether the section can be collapsed/expanded.
  final bool isCollapsible;

  /// Initial expanded state when [isCollapsible] is `true`.
  final bool isInitiallyExpanded;

  const AppListSection({
    required this.title,
    required this.items,
    this.trailing,
    this.isCollapsible = false,
    this.isInitiallyExpanded = true,
  });
}

// ---------------------------------------------------------------------------
// AppListPaginationConfig
// ---------------------------------------------------------------------------

/// Configuration for infinite-scroll / load-more pagination.
class AppListPaginationConfig {
  /// Whether more pages are available.
  final bool hasMore;

  /// Whether a page load is currently in progress.
  final bool isLoadingMore;

  /// Callback fired when the user scrolls close to the bottom.
  final VoidCallback? onLoadMore;

  /// Distance from the bottom (in logical pixels) at which [onLoadMore]
  /// is triggered. Defaults to `200`.
  final double triggerOffset;

  /// Optional custom loading-more widget. Falls back to
  /// [AppListLoadingMoreFooter] when `null`.
  final Widget? loadingMoreWidget;

  const AppListPaginationConfig({
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.triggerOffset = 200,
    this.loadingMoreWidget,
  });
}

// ---------------------------------------------------------------------------
// AppListTileMetrics — size-dependent measurements
// ---------------------------------------------------------------------------

/// Pre-computed metrics that map an [AppListTileSize] to concrete values.
class AppListTileMetrics {
  final double minHeight;
  final double horizontalPadding;
  final double verticalPadding;
  final double leadingTrailingGap;
  final AppTextSize titleTextSize;
  final AppTextSize subtitleTextSize;
  final AppTextSize descriptionTextSize;
  final double leadingSize;
  final double iconSize;

  const AppListTileMetrics({
    required this.minHeight,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.leadingTrailingGap,
    required this.titleTextSize,
    required this.subtitleTextSize,
    required this.descriptionTextSize,
    required this.leadingSize,
    required this.iconSize,
  });

  /// Resolves metrics from the given [size].
  factory AppListTileMetrics.fromSize(AppListTileSize size) {
    switch (size) {
      case AppListTileSize.small:
        return const AppListTileMetrics(
          minHeight: 44,
          horizontalPadding: SpacingTokens.paddingM,
          verticalPadding: SpacingTokens.paddingS,
          leadingTrailingGap: SpacingTokens.gapS,
          titleTextSize: AppTextSize.bodySMedium,
          subtitleTextSize: AppTextSize.bodyXSRegular,
          descriptionTextSize: AppTextSize.bodyXSRegular,
          leadingSize: 32,
          iconSize: IconSizeTokens.iconSizeS,
        );
      case AppListTileSize.medium:
        return const AppListTileMetrics(
          minHeight: 56,
          horizontalPadding: SpacingTokens.paddingL,
          verticalPadding: SpacingTokens.paddingM,
          leadingTrailingGap: SpacingTokens.gapM,
          titleTextSize: AppTextSize.bodyMMedium,
          subtitleTextSize: AppTextSize.bodySRegular,
          descriptionTextSize: AppTextSize.bodySRegular,
          leadingSize: 40,
          iconSize: IconSizeTokens.iconSizeM,
        );
      case AppListTileSize.large:
        return const AppListTileMetrics(
          minHeight: 72,
          horizontalPadding: SpacingTokens.paddingL,
          verticalPadding: SpacingTokens.paddingM,
          leadingTrailingGap: SpacingTokens.gapL,
          titleTextSize: AppTextSize.bodyLMedium,
          subtitleTextSize: AppTextSize.bodyMRegular,
          descriptionTextSize: AppTextSize.bodyMRegular,
          leadingSize: 48,
          iconSize: IconSizeTokens.iconSizeL,
        );
    }
  }
}

// ---------------------------------------------------------------------------
// AppListStickyHeaderConfig
// ---------------------------------------------------------------------------

/// Configuration for an optional sticky header above the list.
class AppListStickyHeaderConfig {
  /// The widget to display as the sticky header.
  final Widget child;

  /// Background color of the header when sticky.
  /// Defaults to [ColorTokens.bgElevated].
  final Color? backgroundColor;

  /// Elevation (shadow) applied when header is sticky. Defaults to `0`.
  final double elevation;

  const AppListStickyHeaderConfig({
    required this.child,
    this.backgroundColor,
    this.elevation = 0,
  });
}

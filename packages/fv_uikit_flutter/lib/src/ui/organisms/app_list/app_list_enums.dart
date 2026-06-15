/// Size variants for [AppListTile].
enum AppListTileSize { small, medium, large }

/// Visual style of separators between list items.
enum AppListSeparatorStyle {
  /// No separator.
  none,

  /// Thin divider line (uses [AppDivider]).
  divider,

  /// Spacing gap between items.
  spacing,
}

/// How initial loading state is displayed.
enum AppListLoadingStyle {
  /// Centered spinner (uses [AppLoadingSpinner]).
  spinner,

  /// Placeholder shimmer items (uses [AppSkeleton]).
  skeleton,
}

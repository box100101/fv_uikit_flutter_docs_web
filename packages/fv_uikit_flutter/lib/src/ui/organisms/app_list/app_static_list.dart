import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

/// A static list widget for displaying fixed or small/medium-sized data.
///
/// Supports optional **local search**, **separator styles**, **empty states**,
/// and an **optional sticky header**. Does NOT support pagination or remote
/// data loading — use [AppDynamicList] for those use-cases.
///
/// **Performance**: Uses `ListView.builder` internally so only visible items
/// are built — O(visible) build cost instead of O(n).
///
/// ```dart
/// AppStaticList<Product>(
///   items: products,
///   itemBuilder: (context, product, index) => AppListTile(
///     title: product.name,
///     subtitle: product.price.toString(),
///   ),
///   isSearchable: true,
///   searchFilter: (product, query) =>
///       product.name.toLowerCase().contains(query),
/// )
/// ```
class AppStaticList<T> extends StatefulWidget {
  // -- Data ------------------------------------------------------------------

  /// The full list of items to display.
  final List<T> items;

  /// Builder for each item widget. Receives the item and its index.
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  // -- Search ----------------------------------------------------------------

  /// Whether a search bar is shown above the list. Defaults to `false`.
  final bool isSearchable;

  /// Placeholder text for the search field.
  final String searchHintText;

  /// Debounce delay for search input in milliseconds. Defaults to `300`.
  final int searchDelay;

  /// Filter predicate. When provided, items are filtered locally using this.
  /// Receives the item and the lowercased search query.
  final bool Function(T item, String query)? searchFilter;

  // -- Separator -------------------------------------------------------------

  /// Style of separator between items. Defaults to [AppListSeparatorStyle.none].
  final AppListSeparatorStyle separatorStyle;

  /// Custom separator widget. Only used when [separatorStyle] is
  /// [AppListSeparatorStyle.divider] and you want to override the default
  /// [AppDivider].
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  // -- Sticky header ---------------------------------------------------------

  /// Optional sticky header configuration.
  /// When provided, the header sticks to the top while scrolling.
  final AppListStickyHeaderConfig? stickyHeader;

  // -- Empty state -----------------------------------------------------------

  /// Text shown when the list is empty (after filtering).
  final String emptyText;

  /// Custom widget shown when the list is empty. Overrides [emptyText].
  final Widget? emptyWidget;

  // -- Scroll ----------------------------------------------------------------

  /// Optional external scroll controller.
  final ScrollController? scrollController;

  /// Scroll physics. Defaults to platform default.
  final ScrollPhysics? physics;

  /// Padding around the list content.
  final EdgeInsetsGeometry? padding;

  /// Whether the list should shrink-wrap its content. Defaults to `false`.
  /// Use `true` when embedding inside a scrollable parent.
  final bool shrinkWrap;

  const AppStaticList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.isSearchable = false,
    this.searchHintText = 'Tìm kiếm...',
    this.searchDelay = 300,
    this.searchFilter,
    this.separatorStyle = AppListSeparatorStyle.none,
    this.separatorBuilder,
    this.stickyHeader,
    this.emptyText = 'Không có dữ liệu',
    this.emptyWidget,
    this.scrollController,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
  });

  @override
  State<AppStaticList<T>> createState() => _AppStaticListState<T>();
}

class _AppStaticListState<T> extends State<AppStaticList<T>> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    final delay = Duration(milliseconds: widget.searchDelay);
    if (delay == Duration.zero) {
      setState(() => _searchQuery = value.trim().toLowerCase());
      return;
    }

    _debounce = Timer(delay, () {
      if (!mounted) return;
      setState(() => _searchQuery = value.trim().toLowerCase());
    });
  }

  List<T> get _filteredItems {
    if (_searchQuery.isEmpty || widget.searchFilter == null) {
      return widget.items;
    }
    return widget.items
        .where((item) => widget.searchFilter!(item, _searchQuery))
        .toList();
  }

  Widget _buildSeparator(BuildContext context, int index) {
    if (widget.separatorBuilder != null) {
      return widget.separatorBuilder!(context, index);
    }

    switch (widget.separatorStyle) {
      case AppListSeparatorStyle.none:
        return const SizedBox.shrink();
      case AppListSeparatorStyle.divider:
        return const AppDivider(
          indent: SpacingTokens.paddingL,
          endIndent: SpacingTokens.paddingL,
        );
      case AppListSeparatorStyle.spacing:
        return const SizedBox(height: SpacingTokens.gapS);
    }
  }

  Widget _buildList(List<T> items) {
    if (items.isEmpty) {
      return widget.emptyWidget ??
          AppListEmptyState(text: widget.emptyText);
    }

    return ListView.separated(
      controller: widget.scrollController,
      physics: widget.physics,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      itemCount: items.length,
      itemBuilder: (context, index) =>
          widget.itemBuilder(context, items[index], index),
      separatorBuilder: _buildSeparator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;
    final hasSearch = widget.isSearchable;
    final hasStickyHeader = widget.stickyHeader != null;

    // If no sticky header and no search, return simple list
    if (!hasStickyHeader && !hasSearch) {
      return _buildList(items);
    }

    // Use CustomScrollView with slivers for sticky header / search
    return CustomScrollView(
      controller: widget.scrollController,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      slivers: [
        // Sticky header
        if (hasStickyHeader)
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              child: widget.stickyHeader!.child,
              backgroundColor:
                  widget.stickyHeader!.backgroundColor ??
                  ColorTokens.bgElevated,
              elevation: widget.stickyHeader!.elevation,
            ),
          ),

        // Search bar (always pinned when visible)
        if (hasSearch)
          SliverPersistentHeader(
            pinned: true,
            delegate: _SearchBarDelegate(
              searchController: _searchController,
              hintText: widget.searchHintText,
              onChanged: _onSearchChanged,
              searchDelay: widget.searchDelay,
            ),
          ),

        // List content
        if (items.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: widget.emptyWidget ??
                AppListEmptyState(text: widget.emptyText),
          )
        else
          SliverPadding(
            padding: widget.padding ?? EdgeInsets.zero,
            sliver: SliverList.separated(
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  widget.itemBuilder(context, items[index], index),
              separatorBuilder: _buildSeparator,
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sliver delegates
// ---------------------------------------------------------------------------

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final Color backgroundColor;
  final double elevation;

  _StickyHeaderDelegate({
    required this.child,
    required this.backgroundColor,
    required this.elevation,
  });

  @override
  double get minExtent => _kStickyHeaderHeight;

  @override
  double get maxExtent => _kStickyHeaderHeight;

  static const double _kStickyHeaderHeight = 56;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: backgroundColor,
      elevation: overlapsContent ? elevation : 0,
      child: SizedBox(height: _kStickyHeaderHeight, child: child),
    );
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return child != oldDelegate.child ||
        backgroundColor != oldDelegate.backgroundColor ||
        elevation != oldDelegate.elevation;
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final String hintText;
  final ValueChanged<String> onChanged;
  final int searchDelay;

  _SearchBarDelegate({
    required this.searchController,
    required this.hintText,
    required this.onChanged,
    required this.searchDelay,
  });

  static const double _kSearchBarHeight = 64;

  @override
  double get minExtent => _kSearchBarHeight;

  @override
  double get maxExtent => _kSearchBarHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: ColorTokens.bgElevated,
      elevation: overlapsContent ? 1 : 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.paddingL,
          vertical: SpacingTokens.paddingS,
        ),
        child: AppSearchField(
          controller: searchController,
          hintText: hintText,
          onChanged: onChanged,
          searchDelay: searchDelay,
          size: AppTextFieldSize.medium,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SearchBarDelegate oldDelegate) {
    return hintText != oldDelegate.hintText;
  }
}

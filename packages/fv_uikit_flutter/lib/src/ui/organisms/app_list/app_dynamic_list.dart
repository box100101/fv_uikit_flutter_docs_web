import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

/// A dynamic list widget designed for API-driven data.
///
/// Supports **pagination** (infinite scroll / load more), **pull-to-refresh**,
/// **skeleton loading**, **remote & local search**, **error / retry states**,
/// and an **optional sticky header**.
///
/// **Performance:**
/// - Uses `ListView.builder` → O(visible items) build cost.
/// - Debounced search input.
/// - Load-more lock prevents duplicate API calls.
/// - `addAutomaticKeepAlives: false` + `addRepaintBoundaries: true` by default.
///
/// ```dart
/// AppDynamicList<Order>(
///   items: orders,
///   isLoading: isFirstLoad,
///   itemBuilder: (context, order, index) => AppListTile(
///     title: order.id,
///     subtitle: order.status,
///   ),
///   pagination: AppListPaginationConfig(
///     hasMore: hasNextPage,
///     isLoadingMore: isLoadingMore,
///     onLoadMore: () => bloc.add(LoadNextPage()),
///   ),
///   onRefresh: () => bloc.add(RefreshOrders()),
///   isSearchable: true,
///   onSearchChanged: (query) => bloc.add(SearchOrders(query)),
/// )
/// ```
class AppDynamicList<T> extends StatefulWidget {
  // -- Data ------------------------------------------------------------------

  /// The current list of loaded items.
  final List<T> items;

  /// Builder for each item widget.
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  // -- Loading states --------------------------------------------------------

  /// Whether initial data is loading (shows loading / skeleton).
  final bool isLoading;

  /// Visual style of the initial loading state.
  final AppListLoadingStyle loadingStyle;

  /// Number of skeleton items when [loadingStyle] is [AppListLoadingStyle.skeleton].
  final int skeletonCount;

  /// Custom skeleton item builder.
  final Widget Function(BuildContext context, int index)? skeletonBuilder;

  /// Text shown during initial loading spinner.
  final String loadingText;

  // -- Pagination ------------------------------------------------------------

  /// Configuration for infinite scroll / load more.
  final AppListPaginationConfig? pagination;

  // -- Search ----------------------------------------------------------------

  /// Whether a search bar is shown. Defaults to `false`.
  final bool isSearchable;

  /// Placeholder text for the search field.
  final String searchHintText;

  /// Debounce delay in milliseconds. Defaults to `400`.
  final int searchDelay;

  /// Callback when the debounced search query changes (remote search).
  final ValueChanged<String>? onSearchChanged;

  /// Whether to also filter items locally. Defaults to `false`.
  final bool enableLocalFilter;

  /// Local filter predicate. Used when [enableLocalFilter] is `true`.
  final bool Function(T item, String query)? searchFilter;

  // -- Pull-to-refresh -------------------------------------------------------

  /// Callback for pull-to-refresh. When `null`, pull-to-refresh is disabled.
  final Future<void> Function()? onRefresh;

  // -- Error state -----------------------------------------------------------

  /// Error text. When non-null, the error state is shown instead of items.
  final String? errorText;

  /// Called when the user taps the retry button in the error state.
  final VoidCallback? onRetry;

  // -- Empty state -----------------------------------------------------------

  /// Text shown when items are empty and not loading.
  final String emptyText;

  /// Custom empty state widget. Overrides [emptyText].
  final Widget? emptyWidget;

  // -- Separator -------------------------------------------------------------

  /// Separator style between items.
  final AppListSeparatorStyle separatorStyle;

  /// Custom separator builder.
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  // -- Sticky header ---------------------------------------------------------

  /// Optional sticky header configuration.
  final AppListStickyHeaderConfig? stickyHeader;

  // -- Scroll ----------------------------------------------------------------

  /// Optional external scroll controller.
  final ScrollController? scrollController;

  /// Padding around the list content.
  final EdgeInsetsGeometry? padding;

  const AppDynamicList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.isLoading = false,
    this.loadingStyle = AppListLoadingStyle.skeleton,
    this.skeletonCount = 5,
    this.skeletonBuilder,
    this.loadingText = 'Đang tải dữ liệu...',
    this.pagination,
    this.isSearchable = false,
    this.searchHintText = 'Tìm kiếm...',
    this.searchDelay = 400,
    this.onSearchChanged,
    this.enableLocalFilter = false,
    this.searchFilter,
    this.onRefresh,
    this.errorText,
    this.onRetry,
    this.emptyText = 'Không có dữ liệu',
    this.emptyWidget,
    this.separatorStyle = AppListSeparatorStyle.none,
    this.separatorBuilder,
    this.stickyHeader,
    this.scrollController,
    this.padding,
  });

  @override
  State<AppDynamicList<T>> createState() => _AppDynamicListState<T>();
}

class _AppDynamicListState<T> extends State<AppDynamicList<T>> {
  late ScrollController _scrollController;
  bool _ownsScrollController = false;

  final TextEditingController _searchController = TextEditingController();
  String _localSearchQuery = '';
  Timer? _debounce;

  bool _isLoadMoreLocked = false;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _initScrollController();
  }

  @override
  void didUpdateWidget(covariant AppDynamicList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncScrollController(oldWidget);
    _syncLoadMoreLock(oldWidget);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _disposeScrollControllerIfOwned();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // ScrollController management
  // ---------------------------------------------------------------------------

  void _initScrollController() {
    if (widget.scrollController != null) {
      _scrollController = widget.scrollController!;
      _ownsScrollController = false;
    } else {
      _scrollController = ScrollController();
      _ownsScrollController = true;
    }
    _scrollController.addListener(_handleScroll);
  }

  void _syncScrollController(AppDynamicList<T> oldWidget) {
    if (widget.scrollController != oldWidget.scrollController) {
      _scrollController.removeListener(_handleScroll);
      if (_ownsScrollController) {
        _scrollController.dispose();
      }
      _initScrollController();
    }
  }

  void _disposeScrollControllerIfOwned() {
    _scrollController.removeListener(_handleScroll);
    if (_ownsScrollController) {
      _scrollController.dispose();
    }
  }

  // ---------------------------------------------------------------------------
  // Scroll & pagination
  // ---------------------------------------------------------------------------

  void _handleScroll() {
    final pagination = widget.pagination;
    if (pagination == null) return;
    if (!pagination.hasMore || pagination.isLoadingMore) return;
    if (widget.isLoading || _isLoadMoreLocked) return;
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final remaining = position.maxScrollExtent - position.pixels;

    if (remaining <= pagination.triggerOffset) {
      _isLoadMoreLocked = true;
      pagination.onLoadMore?.call();
    }
  }

  void _syncLoadMoreLock(AppDynamicList<T> oldWidget) {
    final oldPagination = oldWidget.pagination;
    final newPagination = widget.pagination;

    final itemCountChanged = oldWidget.items.length != widget.items.length;
    final loadMoreFinished =
        oldPagination?.isLoadingMore == true &&
        newPagination?.isLoadingMore != true;
    final noMore = newPagination?.hasMore != true;

    if (itemCountChanged || loadMoreFinished || noMore) {
      _isLoadMoreLocked = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Search
  // ---------------------------------------------------------------------------

  void _onSearchChanged(String value) {
    // Remote search callback
    widget.onSearchChanged?.call(value);

    // Local filter
    if (widget.enableLocalFilter) {
      _debounce?.cancel();
      final delay = Duration(milliseconds: widget.searchDelay);
      if (delay == Duration.zero) {
        setState(() => _localSearchQuery = value.trim().toLowerCase());
        return;
      }
      _debounce = Timer(delay, () {
        if (!mounted) return;
        setState(() => _localSearchQuery = value.trim().toLowerCase());
      });
    }
  }

  List<T> get _filteredItems {
    if (!widget.enableLocalFilter ||
        _localSearchQuery.isEmpty ||
        widget.searchFilter == null) {
      return widget.items;
    }
    return widget.items
        .where((item) => widget.searchFilter!(item, _localSearchQuery))
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Build helpers
  // ---------------------------------------------------------------------------

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

  int get _totalItemCount {
    final items = _filteredItems;
    final showFooter =
        widget.pagination?.isLoadingMore == true && items.isNotEmpty;
    return items.length + (showFooter ? 1 : 0);
  }

  bool _isFooterIndex(int index) {
    return widget.pagination?.isLoadingMore == true &&
        index == _filteredItems.length;
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText?.isNotEmpty == true;
    final hasStickyHeader = widget.stickyHeader != null;
    final hasSearch = widget.isSearchable;
    final usesSlivers = hasStickyHeader || hasSearch;

    // Wrap with pull-to-refresh if enabled
    Widget result;

    if (usesSlivers) {
      result = _buildSliverLayout(hasError: hasError);
    } else {
      result = _buildFlatLayout(hasError: hasError);
    }

    if (widget.onRefresh != null && !widget.isLoading && !hasError) {
      result = RefreshIndicator(
        onRefresh: widget.onRefresh!,
        color: ColorTokens.primaryDefault,
        child: result,
      );
    }

    return result;
  }

  // -- Flat layout (no sticky header / search) --------------------------------

  Widget _buildFlatLayout({required bool hasError}) {
    if (widget.isLoading) {
      return _buildLoadingState();
    }

    if (hasError) {
      return AppListErrorState(
        text: widget.errorText!,
        onRetry: widget.onRetry,
      );
    }

    final items = _filteredItems;
    if (items.isEmpty) {
      return widget.emptyWidget ?? AppListEmptyState(text: widget.emptyText);
    }

    return ListView.separated(
      controller: _scrollController,
      padding: widget.padding,
      itemCount: _totalItemCount,
      itemBuilder: (context, index) {
        if (_isFooterIndex(index)) {
          return widget.pagination?.loadingMoreWidget ??
              const AppListLoadingMoreFooter();
        }
        return widget.itemBuilder(context, items[index], index);
      },
      separatorBuilder: (context, index) {
        if (_isFooterIndex(index + 1)) return const SizedBox.shrink();
        return _buildSeparator(context, index);
      },
    );
  }

  // -- Sliver layout (sticky header / search) ---------------------------------

  Widget _buildSliverLayout({required bool hasError}) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Sticky header
        if (widget.stickyHeader != null)
          SliverPersistentHeader(
            pinned: true,
            delegate: _DynamicListStickyHeaderDelegate(
              child: widget.stickyHeader!.child,
              backgroundColor:
                  widget.stickyHeader!.backgroundColor ??
                  ColorTokens.bgElevated,
              elevation: widget.stickyHeader!.elevation,
            ),
          ),

        // Search bar
        if (widget.isSearchable)
          SliverPersistentHeader(
            pinned: true,
            delegate: _DynamicListSearchBarDelegate(
              searchController: _searchController,
              hintText: widget.searchHintText,
              onChanged: _onSearchChanged,
              searchDelay: widget.searchDelay,
            ),
          ),

        // Content
        if (widget.isLoading)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _buildLoadingState(),
          )
        else if (hasError)
          SliverFillRemaining(
            hasScrollBody: false,
            child: AppListErrorState(
              text: widget.errorText!,
              onRetry: widget.onRetry,
            ),
          )
        else if (_filteredItems.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: widget.emptyWidget ??
                AppListEmptyState(text: widget.emptyText),
          )
        else ...[
          SliverPadding(
            padding: widget.padding ?? EdgeInsets.zero,
            sliver: SliverList.separated(
              itemCount: _totalItemCount,
              itemBuilder: (context, index) {
                final items = _filteredItems;
                if (_isFooterIndex(index)) {
                  return widget.pagination?.loadingMoreWidget ??
                      const AppListLoadingMoreFooter();
                }
                return widget.itemBuilder(context, items[index], index);
              },
              separatorBuilder: (context, index) {
                if (_isFooterIndex(index + 1)) return const SizedBox.shrink();
                return _buildSeparator(context, index);
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingState() {
    switch (widget.loadingStyle) {
      case AppListLoadingStyle.spinner:
        return AppListLoadingState(text: widget.loadingText);
      case AppListLoadingStyle.skeleton:
        return AppListSkeletonState(
          itemCount: widget.skeletonCount,
          skeletonBuilder: widget.skeletonBuilder,
          padding:
              widget.padding as EdgeInsets? ??
              const EdgeInsets.symmetric(
                horizontal: SpacingTokens.paddingL,
              ),
        );
    }
  }
}

// ---------------------------------------------------------------------------
// Sliver delegates (scoped to this file)
// ---------------------------------------------------------------------------

class _DynamicListStickyHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final Widget child;
  final Color backgroundColor;
  final double elevation;

  _DynamicListStickyHeaderDelegate({
    required this.child,
    required this.backgroundColor,
    required this.elevation,
  });

  static const double _kHeight = 56;

  @override
  double get minExtent => _kHeight;

  @override
  double get maxExtent => _kHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: backgroundColor,
      elevation: overlapsContent ? elevation : 0,
      child: SizedBox(height: _kHeight, child: child),
    );
  }

  @override
  bool shouldRebuild(
    covariant _DynamicListStickyHeaderDelegate oldDelegate,
  ) {
    return child != oldDelegate.child ||
        backgroundColor != oldDelegate.backgroundColor ||
        elevation != oldDelegate.elevation;
  }
}

class _DynamicListSearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final String hintText;
  final ValueChanged<String> onChanged;
  final int searchDelay;

  _DynamicListSearchBarDelegate({
    required this.searchController,
    required this.hintText,
    required this.onChanged,
    required this.searchDelay,
  });

  static const double _kHeight = 64;

  @override
  double get minExtent => _kHeight;

  @override
  double get maxExtent => _kHeight;

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
          onSearchChanged: onChanged,
          searchDelay: searchDelay,
          size: AppTextFieldSize.medium,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _DynamicListSearchBarDelegate oldDelegate) {
    return hintText != oldDelegate.hintText;
  }
}

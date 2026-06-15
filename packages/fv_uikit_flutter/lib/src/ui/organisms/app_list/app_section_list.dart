import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

/// A grouped list widget with **sticky section headers**.
///
/// Each section has a title header that sticks to the top while scrolling
/// through its items. Supports **collapsible sections**, **local search**,
/// **separator styles**, and an **optional sticky header** above the sections.
///
/// Internally uses `CustomScrollView` + `SliverPersistentHeader` +
/// `SliverList` — no nested `ListView` (which would cause layout issues).
///
/// **Performance**: Only visible items are built — O(visible) build cost.
///
/// ```dart
/// AppSectionList<Contact>(
///   sections: [
///     AppListSection(title: 'A', items: contactsA),
///     AppListSection(title: 'B', items: contactsB),
///   ],
///   itemBuilder: (context, contact, index) => AppListTile(
///     title: contact.name,
///     subtitle: contact.phone,
///   ),
///   isStickyHeaders: true,
/// )
/// ```
class AppSectionList<T> extends StatefulWidget {
  // -- Data ------------------------------------------------------------------

  /// The sections to display, each with a header and list of items.
  final List<AppListSection<T>> sections;

  /// Builder for each item widget.
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Custom header builder. Falls back to [AppListSectionHeader].
  final Widget Function(
    BuildContext context,
    AppListSection<T> section,
    int sectionIndex,
    bool isExpanded,
    VoidCallback onToggle,
  )?
  headerBuilder;

  // -- Sticky behavior -------------------------------------------------------

  /// Whether section headers stick to the top. Defaults to `true`.
  final bool isStickyHeaders;

  /// Background color for sticky section headers.
  final Color? sectionHeaderColor;

  // -- Search ----------------------------------------------------------------

  /// Whether a search bar is shown. Defaults to `false`.
  final bool isSearchable;

  /// Placeholder text for the search field.
  final String searchHintText;

  /// Debounce delay in milliseconds. Defaults to `300`.
  final int searchDelay;

  /// Filter predicate for local search.
  final bool Function(T item, String query)? searchFilter;

  // -- Separator -------------------------------------------------------------

  /// Style of separator between items within a section.
  final AppListSeparatorStyle separatorStyle;

  /// Custom separator builder.
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  // -- Sticky header (above everything) --------------------------------------

  /// Optional sticky header configuration (above the section list).
  final AppListStickyHeaderConfig? stickyHeader;

  // -- Empty state -----------------------------------------------------------

  /// Text shown when all sections are empty (after filtering).
  final String emptyText;

  /// Custom empty state widget.
  final Widget? emptyWidget;

  // -- Scroll ----------------------------------------------------------------

  /// Optional external scroll controller.
  final ScrollController? scrollController;

  /// Scroll physics.
  final ScrollPhysics? physics;

  /// Padding around the content.
  final EdgeInsetsGeometry? padding;

  const AppSectionList({
    super.key,
    required this.sections,
    required this.itemBuilder,
    this.headerBuilder,
    this.isStickyHeaders = true,
    this.sectionHeaderColor,
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
  });

  @override
  State<AppSectionList<T>> createState() => _AppSectionListState<T>();
}

class _AppSectionListState<T> extends State<AppSectionList<T>> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounce;

  /// Tracks which collapsible sections are expanded, keyed by section index.
  late Map<int, bool> _expandedMap;

  @override
  void initState() {
    super.initState();
    _initExpandedMap();
  }

  @override
  void didUpdateWidget(covariant AppSectionList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Re-sync expanded map if sections changed
    if (oldWidget.sections.length != widget.sections.length) {
      _initExpandedMap();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _initExpandedMap() {
    _expandedMap = {
      for (int i = 0; i < widget.sections.length; i++)
        i: widget.sections[i].isInitiallyExpanded,
    };
  }

  void _toggleSection(int sectionIndex) {
    setState(() {
      _expandedMap[sectionIndex] = !(_expandedMap[sectionIndex] ?? true);
    });
  }

  // ---------------------------------------------------------------------------
  // Search
  // ---------------------------------------------------------------------------

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

  List<T> _filterItems(List<T> items) {
    if (_searchQuery.isEmpty || widget.searchFilter == null) {
      return items;
    }
    return items
        .where((item) => widget.searchFilter!(item, _searchQuery))
        .toList();
  }

  bool get _hasVisibleItems {
    for (final section in widget.sections) {
      if (_filterItems(section.items).isNotEmpty) return true;
    }
    return false;
  }

  // ---------------------------------------------------------------------------
  // Build
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

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.scrollController,
      physics: widget.physics,
      slivers: [
        // Global sticky header
        if (widget.stickyHeader != null)
          SliverPersistentHeader(
            pinned: true,
            delegate: _SectionListStickyHeaderDelegate(
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
            delegate: _SectionListSearchBarDelegate(
              searchController: _searchController,
              hintText: widget.searchHintText,
              onChanged: _onSearchChanged,
              searchDelay: widget.searchDelay,
            ),
          ),

        // Empty state
        if (!_hasVisibleItems)
          SliverFillRemaining(
            hasScrollBody: false,
            child: widget.emptyWidget ??
                AppListEmptyState(text: widget.emptyText),
          )
        else
          // Sections
          ..._buildSections(),
      ],
    );
  }

  List<Widget> _buildSections() {
    final slivers = <Widget>[];

    for (int sectionIndex = 0;
        sectionIndex < widget.sections.length;
        sectionIndex++) {
      final section = widget.sections[sectionIndex];
      final filteredItems = _filterItems(section.items);

      // Skip empty sections after filtering
      if (filteredItems.isEmpty) continue;

      final isExpanded = _expandedMap[sectionIndex] ?? true;

      // Section header
      slivers.add(
        SliverPersistentHeader(
          pinned: widget.isStickyHeaders,
          delegate: _SectionHeaderDelegate(
            title: section.title,
            trailing: section.trailing,
            isCollapsible: section.isCollapsible,
            isExpanded: isExpanded,
            onToggle: () => _toggleSection(sectionIndex),
            backgroundColor:
                widget.sectionHeaderColor ?? ColorTokens.bgLayout,
            headerBuilder:
                widget.headerBuilder != null
                    ? (context) => widget.headerBuilder!(
                      context,
                      section,
                      sectionIndex,
                      isExpanded,
                      () => _toggleSection(sectionIndex),
                    )
                    : null,
          ),
        ),
      );

      // Section items (only when expanded)
      if (isExpanded) {
        slivers.add(
          SliverPadding(
            padding: widget.padding ?? EdgeInsets.zero,
            sliver: SliverList.separated(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) =>
                  widget.itemBuilder(context, filteredItems[index], index),
              separatorBuilder: _buildSeparator,
            ),
          ),
        );
      }
    }

    return slivers;
  }
}

// ---------------------------------------------------------------------------
// Sliver delegates
// ---------------------------------------------------------------------------

class _SectionListStickyHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final Widget child;
  final Color backgroundColor;
  final double elevation;

  _SectionListStickyHeaderDelegate({
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
    covariant _SectionListStickyHeaderDelegate oldDelegate,
  ) {
    return child != oldDelegate.child ||
        backgroundColor != oldDelegate.backgroundColor ||
        elevation != oldDelegate.elevation;
  }
}

class _SectionListSearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final String hintText;
  final ValueChanged<String> onChanged;
  final int searchDelay;

  _SectionListSearchBarDelegate({
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
          onChanged: onChanged,
          searchDelay: searchDelay,
          size: AppTextFieldSize.medium,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SectionListSearchBarDelegate oldDelegate) {
    return hintText != oldDelegate.hintText;
  }
}

class _SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final Widget? trailing;
  final bool isCollapsible;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Color backgroundColor;
  final Widget Function(BuildContext context)? headerBuilder;

  _SectionHeaderDelegate({
    required this.title,
    this.trailing,
    required this.isCollapsible,
    required this.isExpanded,
    required this.onToggle,
    required this.backgroundColor,
    this.headerBuilder,
  });

  static const double _kHeight = 44;

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
    if (headerBuilder != null) {
      return SizedBox(height: _kHeight, child: headerBuilder!(context));
    }

    return SizedBox(
      height: _kHeight,
      child: AppListSectionHeader(
        title: title,
        trailing: trailing,
        isCollapsible: isCollapsible,
        isExpanded: isExpanded,
        onToggle: onToggle,
        backgroundColor: backgroundColor,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SectionHeaderDelegate oldDelegate) {
    return title != oldDelegate.title ||
        trailing != oldDelegate.trailing ||
        isCollapsible != oldDelegate.isCollapsible ||
        isExpanded != oldDelegate.isExpanded ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}

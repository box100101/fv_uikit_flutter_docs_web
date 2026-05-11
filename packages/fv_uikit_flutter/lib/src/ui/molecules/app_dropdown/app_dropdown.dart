import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';
import 'package:fv_uikit_flutter/src/ui/molecules/app_dropdown/app_dropdown_Trigger.dart';
import 'package:fv_uikit_flutter/src/ui/molecules/app_dropdown/app_dropdown_config.dart';
import 'package:fv_uikit_flutter/src/ui/molecules/app_dropdown/app_dropdown_menu_body.dart';
import 'package:fv_uikit_flutter/src/ui/molecules/app_dropdown/app_dropdown_menu_item.dart';
import 'package:fv_uikit_flutter/src/ui/molecules/app_dropdown/app_dropdown_menu_panel.dart';
import 'package:fv_uikit_flutter/src/ui/molecules/app_dropdown/app_dropdown_overlay.dart';
import 'package:fv_uikit_flutter/src/ui/molecules/app_dropdown/app_dropdown_state.dart';
import 'package:fv_uikit_flutter/src/ui/molecules/app_dropdown/app_dropdown_view_state.dart';

class AppDropdown<T> extends StatefulWidget {
  final String? labelText;
  final String hintText;
  final List<T> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String Function(T) itemAsString;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? isSearchable;
  final String? emptyText;
  final String? searchHintText;
  final bool isLoading;
  final String? errorText;
  final VoidCallback? onMenuOpen;
  final VoidCallback? onRetry;
  final ValueChanged<String>? onSearchChanged;
  final bool enableLocalFilter;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  final double menuMaxHeight;
  final double loadMoreTriggerOffset;
  final bool isShowStripedBg;
  final bool resetSearchOnMenuOpen;
  final AppDropdownSize size;
  final bool isDisabled;

  const AppDropdown({
    super.key,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.isSearchable = false,
    this.emptyText = 'No results found',
    this.searchHintText = 'Search...',
    required this.items,
    required this.value,
    required this.hintText,
    required this.onChanged,
    required this.itemAsString,
    this.isLoading = false,
    this.errorText,
    this.onMenuOpen,
    this.onRetry,
    this.onSearchChanged,
    this.enableLocalFilter = true,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.menuMaxHeight = AppDropdownTokens.defaultMenuMaxHeight,
    this.loadMoreTriggerOffset = AppDropdownTokens.defaultLoadMoreTriggerOffset,
    this.isShowStripedBg = false,
    this.resetSearchOnMenuOpen = true,
    this.size = AppDropdownSize.medium,
    this.isDisabled = false,
  });

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  T? _selectedItem;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _menuScrollController = ScrollController();
  bool _isLoadMoreLocked = false;
  AppDropdownMetrics get _metrics => AppDropdownMetrics.fromSize(widget.size);

  final LayerLink _layerLink = LayerLink();
  final GlobalKey _targetKey = GlobalKey();

  OverlayEntry? _overlayEntry;
  bool _isMenuOpen = false;
  bool _menuOpensAbove = false;

  String get _displayText {
    final selectedItem = _selectedItem;
    if (selectedItem != null) {
      return widget.itemAsString(selectedItem);
    }
    return widget.hintText;
  }

  bool get _isShowingHint => _selectedItem == null;

  bool get _isSearchEnabled => widget.isSearchable ?? false;

  bool get _isRemoteSearchMode => _isSearchEnabled && !widget.enableLocalFilter;

  bool get _isDisabled => widget.isDisabled;

  List<T> get _filteredItems {
    if (!widget.enableLocalFilter) {
      return widget.items;
    }

    final keyword = _searchController.text.trim().toLowerCase();

    if (keyword.isEmpty) {
      return widget.items;
    }

    return widget.items.where((item) {
      final text = widget.itemAsString(item).toLowerCase();
      return text.contains(keyword);
    }).toList();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _refreshOverlayIfNeeded() {
    if (_isMenuOpen) {
      _overlayEntry?.markNeedsBuild();
    }
  }

  void _resetMenuSessionState() {
    _isLoadMoreLocked = false;
  }

  void _teardownMenuSession() {
    _resetMenuSessionState();
    _removeOverlay();
  }

  void _disposeOwnedResources() {
    _teardownMenuSession();
    _menuScrollController.removeListener(_handleMenuScroll);
    _menuScrollController.dispose();
    _searchController.dispose();
  }

  void _toggleMenu() {
    if (_isDisabled) return;

    if (_isMenuOpen) {
      _closeMenu();
      return;
    }

    _openMenu();
  }

  void _syncSearchStateOnMenuOpen() {
    if (!_isSearchEnabled) return;
    if (!widget.resetSearchOnMenuOpen) return;

    _searchController.clear();

    if (_isRemoteSearchMode) {
      widget.onSearchChanged?.call('');
    }
  }

  Size? _resolveTriggerSize() {
    final renderBox =
        _targetKey.currentContext?.findRenderObject() as RenderBox?;

    return renderBox?.size;
  }

  Rect? _resolveTriggerGlobalRect() {
    final renderBox =
        _targetKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null || !renderBox.hasSize) return null;

    final topLeft = renderBox.localToGlobal(Offset.zero);
    return topLeft & renderBox.size;
  }

  _DropdownMenuPlacement _resolveMenuPlacement(Rect triggerRect) {
    final mediaQuery = MediaQuery.of(context);
    final viewportHeight = mediaQuery.size.height;
    final safeTop = mediaQuery.padding.top + SpacingTokens.gapS;
    final safeBottom =
        viewportHeight - mediaQuery.padding.bottom - SpacingTokens.gapS;
    final availableAbove = math.max(0.0, triggerRect.top - safeTop);
    final availableBelow = math.max(0.0, safeBottom - triggerRect.bottom);
    final opensAbove =
        availableBelow < widget.menuMaxHeight &&
        availableAbove > availableBelow;
    final availableHeight = opensAbove ? availableAbove : availableBelow;
    final panelVerticalPadding = SpacingTokens.paddingM;
    final menuMaxHeight = math.max(
      _metrics.height,
      math.min(
        widget.menuMaxHeight,
        math.max(0.0, availableHeight - panelVerticalPadding),
      ),
    );

    return _DropdownMenuPlacement(
      opensAbove: opensAbove,
      menuMaxHeight: menuMaxHeight,
    );
  }

  OverlayEntry _createMenuOverlayEntry(
    Size triggerSize,
    _DropdownMenuPlacement placement,
  ) {
    return OverlayEntry(
      builder: (context) {
        return AppDropdownOverlay(
          layerLink: _layerLink,
          width: triggerSize.width,
          opensAbove: placement.opensAbove,
          onDismiss: _closeMenu,
          child: AppDropdownMenuPanel(
            menuMaxHeight: placement.menuMaxHeight,
            opensAbove: placement.opensAbove,
            searchField: _isSearchEnabled ? _buildSearchField() : null,
            body: _buildMenuBody(),
          ),
        );
      },
    );
  }

  void _openMenu() {
    if (_isDisabled) return;
    if (_isMenuOpen) return;

    _resetMenuSessionState();
    _syncSearchStateOnMenuOpen();
    widget.onMenuOpen?.call();

    final overlay = Overlay.of(context);
    final triggerSize = _resolveTriggerSize();
    final triggerRect = _resolveTriggerGlobalRect();

    if (triggerSize == null || triggerRect == null) return;

    final placement = _resolveMenuPlacement(triggerRect);
    _menuOpensAbove = placement.opensAbove;
    _overlayEntry = _createMenuOverlayEntry(triggerSize, placement);
    overlay.insert(_overlayEntry!);

    setState(() {
      _isMenuOpen = true;
    });
  }

  void _closeMenu() {
    _teardownMenuSession();

    if (!_isMenuOpen) return;

    setState(() {
      _isMenuOpen = false;
    });
  }

  void _selectItem(T item) {
    final shouldNotify = item != _selectedItem;

    _teardownMenuSession();

    setState(() {
      _selectedItem = item;
      _isMenuOpen = false;
    });

    if (shouldNotify) {
      widget.onChanged?.call(item);
    }
  }

  void _handleMenuScroll() {
    if (!_isMenuOpen) return;
    if (widget.enableLocalFilter) return;
    if (widget.onLoadMore == null) return;
    if (!widget.hasMore || widget.isLoading || widget.isLoadingMore) return;
    if (_isLoadMoreLocked) return;
    if (!_menuScrollController.hasClients) return;

    final position = _menuScrollController.position;
    final remainingExtent = position.maxScrollExtent - position.pixels;

    if (remainingExtent <= widget.loadMoreTriggerOffset) {
      _isLoadMoreLocked = true;
      widget.onLoadMore?.call();
    }
  }

  void _syncLoadMoreLock(AppDropdown<T> oldWidget) {
    final itemCountChanged = oldWidget.items.length != widget.items.length;
    final loadMoreFinished = oldWidget.isLoadingMore && !widget.isLoadingMore;

    if (itemCountChanged || loadMoreFinished || !widget.hasMore) {
      _isLoadMoreLocked = false;
    }
  }

  AppDropdownMenuViewState<T> _resolveMenuViewState() {
    final items = _filteredItems;
    final showSearchField = _isSearchEnabled;
    final showLoadingState = widget.isLoading;
    final showErrorState = widget.errorText?.isNotEmpty == true;
    final showEmptyState =
        !showLoadingState && !showErrorState && items.isEmpty;
    final showLoadMoreFooter =
        !showLoadingState &&
        !showErrorState &&
        items.isNotEmpty &&
        widget.isLoadingMore;

    return AppDropdownMenuViewState<T>(
      showSearchField: showSearchField,
      showLoadingState: showLoadingState,
      showErrorState: showErrorState,
      showEmptyState: showEmptyState,
      showLoadMoreFooter: showLoadMoreFooter,
      items: items,
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.value;

    _menuScrollController.addListener(_handleMenuScroll);
  }

  @override
  void dispose() {
    _disposeOwnedResources();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _selectedItem = widget.value;
    }

    if (!oldWidget.isDisabled && widget.isDisabled && _isMenuOpen) {
      _teardownMenuSession();
      _isMenuOpen = false;
    }

    _syncLoadMoreLock(oldWidget);
    _refreshOverlayIfNeeded();
  }

  Widget _buildMenuItem(T item, int index) {
    final isSelected = item == _selectedItem;
    final backgroundColor =
        isSelected
            ? ColorTokens.primaryBg
            : (widget.isShowStripedBg && index.isEven
                ? AppDropdownTokens.stripedBackground
                : ColorTokens.white);

    return AppDropdownMenuItem(
      text: widget.itemAsString(item),
      isSelected: isSelected,
      backgroundColor: backgroundColor,
      onTap: () => _selectItem(item),
      metrics: _metrics,
    );
  }

  Widget _buildSearchField() {
    return AppSearchField(
      controller: _searchController,
      hintText: widget.searchHintText!,
      autofocus: true,
      size: _metrics.searchFieldSize,
      onSearchChanged: _isRemoteSearchMode ? widget.onSearchChanged : null,
    );
  }

  Widget _buildMenuBody() {
    return ListenableBuilder(
      listenable: _searchController,
      builder: (context, _) {
        final viewState = _resolveMenuViewState();

        return AppDropdownMenuBody<T>(
          viewState: viewState,
          scrollController: _menuScrollController,
          loadingState: const AppDropdownLoadingState(),
          errorState: AppDropdownErrorState(
            text: widget.errorText ?? 'Có lỗi xảy ra',
            onRetry: widget.onRetry,
            metrics: _metrics,
          ),
          emptyState: AppDropdownEmptyState(
            text: widget.emptyText!,
            metrics: _metrics,
          ),
          loadingMoreFooter: const AppDropdownLoadingMoreFooter(),
          itemBuilder: _buildMenuItem,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDropdownTrigger(
      labelText: widget.labelText,
      displayText: _displayText,
      isShowingHint: _isShowingHint,
      isMenuOpen: _isMenuOpen,
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.suffixIcon,
      onTap: _toggleMenu,
      layerLink: _layerLink,
      targetKey: _targetKey,
      metrics: _metrics,
      isDisabled: _isDisabled,
      opensAbove: _menuOpensAbove,
    );
  }
}

class _DropdownMenuPlacement {
  final bool opensAbove;
  final double menuMaxHeight;

  const _DropdownMenuPlacement({
    required this.opensAbove,
    required this.menuMaxHeight,
  });
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

class AppBottomSheetSelect<T> extends StatefulWidget {
  final String? labelText;
  final String hintText;
  final String? helperText;
  final String? errorText;
  final List<T> items;
  final T? value;
  final List<T> values;
  final ValueChanged<T?>? onChanged;
  final ValueChanged<List<T>>? onChangedMulti;
  final String Function(T item) itemAsString;
  final String? Function(T item)? itemDescriptionAsString;
  final String Function(List<T> selectedItems)? selectedItemsTextBuilder;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isSearchable;
  final String emptyText;
  final String searchHintText;
  final int searchDelay;
  final bool isLoading;
  final String? sheetErrorText;
  final VoidCallback? onOpen;
  final VoidCallback? onRetry;
  final ValueChanged<String>? onSearchChanged;
  final bool enableLocalFilter;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  final double loadMoreTriggerOffset;
  final bool resetSearchOnOpen;
  final bool isDisabled;
  final bool isRequired;
  final bool isOptional;
  final bool isRounded;
  final AppTextFieldVariant variant;
  final AppTextFieldSize size;
  final FloatingLabelBehavior floatingLabelBehavior;
  final String? sheetTitle;
  final String? sheetDescription;
  final AppBottomSheetSize sheetSize;
  final double sheetListMaxHeight;
  final String cancelButtonText;
  final String applyButtonText;
  final _AppBottomSheetSelectKind kind;

  const AppBottomSheetSelect.single({
    super.key,
    this.labelText,
    this.helperText,
    this.errorText,
    required this.items,
    required this.value,
    required ValueChanged<T?>? onChanged,
    required this.hintText,
    required this.itemAsString,
    this.itemDescriptionAsString,
    this.selectedItemsTextBuilder,
    this.prefixIcon,
    this.suffixIcon,
    this.isSearchable = false,
    this.emptyText = 'No results found',
    this.searchHintText = 'Search...',
    this.searchDelay = 400,
    this.isLoading = false,
    this.sheetErrorText,
    this.onOpen,
    this.onRetry,
    this.onSearchChanged,
    this.enableLocalFilter = true,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.loadMoreTriggerOffset = 48,
    this.resetSearchOnOpen = true,
    this.isDisabled = false,
    this.isRequired = false,
    this.isOptional = false,
    this.isRounded = false,
    this.variant = AppTextFieldVariant.primary,
    this.size = AppTextFieldSize.medium,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    this.sheetTitle,
    this.sheetDescription,
    this.sheetSize = AppBottomSheetSize.large,
    this.sheetListMaxHeight = 360,
    this.cancelButtonText = 'Cancel',
    this.applyButtonText = 'Apply',
  }) : values = const [],
       onChanged = onChanged,
       onChangedMulti = null,
       kind = _AppBottomSheetSelectKind.single;

  const AppBottomSheetSelect.multi({
    super.key,
    this.labelText,
    this.helperText,
    this.errorText,
    required this.items,
    this.values = const [],
    required ValueChanged<List<T>>? onChanged,
    required this.hintText,
    required this.itemAsString,
    this.itemDescriptionAsString,
    this.selectedItemsTextBuilder,
    this.prefixIcon,
    this.suffixIcon,
    this.isSearchable = false,
    this.emptyText = 'No results found',
    this.searchHintText = 'Search...',
    this.searchDelay = 400,
    this.isLoading = false,
    this.sheetErrorText,
    this.onOpen,
    this.onRetry,
    this.onSearchChanged,
    this.enableLocalFilter = true,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.loadMoreTriggerOffset = 48,
    this.resetSearchOnOpen = true,
    this.isDisabled = false,
    this.isRequired = false,
    this.isOptional = false,
    this.isRounded = false,
    this.variant = AppTextFieldVariant.primary,
    this.size = AppTextFieldSize.medium,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    this.sheetTitle,
    this.sheetDescription,
    this.sheetSize = AppBottomSheetSize.large,
    this.sheetListMaxHeight = 360,
    this.cancelButtonText = 'Cancel',
    this.applyButtonText = 'Apply',
  }) : value = null,
       onChanged = null,
       onChangedMulti = onChanged,
       kind = _AppBottomSheetSelectKind.multi;

  bool get isMultiSelect => kind == _AppBottomSheetSelectKind.multi;

  @override
  State<AppBottomSheetSelect<T>> createState() =>
      _AppBottomSheetSelectState<T>();
}

class _AppBottomSheetSelectState<T> extends State<AppBottomSheetSelect<T>> {
  late final TextEditingController _displayController;
  late final FocusNode _triggerFocusNode;
  late final ValueNotifier<int> _sheetRevisionNotifier;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<T> _draftValues = <T>[];
  bool _isSheetOpen = false;
  bool _isLoadMoreLocked = false;

  bool get _isSearchEnabled => widget.isSearchable;

  bool get _isRemoteSearchMode => _isSearchEnabled && !widget.enableLocalFilter;

  _AppBottomSheetSelectMetrics get _metrics =>
      _AppBottomSheetSelectMetrics.fromFieldSize(widget.size);

  bool get _hasSelection =>
      widget.isMultiSelect ? widget.values.isNotEmpty : widget.value != null;

  @override
  void initState() {
    super.initState();
    _displayController = TextEditingController(text: _displayText);
    _triggerFocusNode = FocusNode(canRequestFocus: false, skipTraversal: true);
    _sheetRevisionNotifier = ValueNotifier<int>(0);
    _scrollController.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(covariant AppBottomSheetSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_displayController.text != _displayText) {
      _displayController.text = _displayText;
    }

    _syncLoadMoreLock(oldWidget);
    _refreshSheetIfNeeded();
  }

  @override
  void dispose() {
    _displayController.dispose();
    _triggerFocusNode.dispose();
    _sheetRevisionNotifier.dispose();
    _searchController.dispose();
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  String get _displayText {
    if (widget.isMultiSelect) {
      final selectedItems = widget.values;
      if (selectedItems.isEmpty) return '';

      final formatter = widget.selectedItemsTextBuilder;
      if (formatter != null) {
        return formatter(selectedItems);
      }

      return selectedItems.map(widget.itemAsString).join(', ');
    }

    final selectedItem = widget.value;
    if (selectedItem == null) return '';
    return widget.itemAsString(selectedItem);
  }

  String get _resolvedSheetTitle {
    if (widget.sheetTitle?.trim().isNotEmpty == true) {
      return widget.sheetTitle!.trim();
    }

    if (widget.labelText?.trim().isNotEmpty == true) {
      return widget.labelText!.trim();
    }

    return widget.hintText;
  }

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
      final description = widget.itemDescriptionAsString?.call(item);
      final normalizedDescription = description?.toLowerCase() ?? '';

      return text.contains(keyword) || normalizedDescription.contains(keyword);
    }).toList();
  }

  void _refreshSheetIfNeeded() {
    if (!_isSheetOpen) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_isSheetOpen) return;
      _sheetRevisionNotifier.value += 1;
    });
  }

  void _resetSheetSessionState() {
    _draftValues = List<T>.from(widget.values);
    _isLoadMoreLocked = false;
  }

  void _syncSearchStateOnOpen() {
    if (!_isSearchEnabled) return;
    if (!widget.resetSearchOnOpen) return;

    _searchController.clear();

    if (_isRemoteSearchMode) {
      widget.onSearchChanged?.call('');
    }
  }

  Future<void> _openSheet() async {
    if (widget.isDisabled || _isSheetOpen) return;

    _resetSheetSessionState();
    _syncSearchStateOnOpen();
    widget.onOpen?.call();

    setState(() {
      _isSheetOpen = true;
    });

    await AppBottomSheet.show<void>(
      context: context,
      builder:
          (bottomSheetContext) => AppBottomSheet(
            title: _resolvedSheetTitle,
            description: widget.sheetDescription,
            size: widget.sheetSize,
            actionOrientation: AppBottomSheetActionOrientation.horizontal,
            titleCancelAction:
                widget.isMultiSelect ? widget.cancelButtonText : null,
            onCancelAction:
                widget.isMultiSelect
                    ? () => AppBottomSheet.close(bottomSheetContext)
                    : null,
            titlePrimaryAction:
                widget.isMultiSelect ? widget.applyButtonText : null,
            onPrimaryAction:
                widget.isMultiSelect
                    ? () => _applyMultiSelection(bottomSheetContext)
                    : null,
            child: ValueListenableBuilder<int>(
              valueListenable: _sheetRevisionNotifier,
              builder: (_, __, ___) {
                return _buildSheetContent(bottomSheetContext);
              },
            ),
          ),
    );

    if (!mounted) return;

    setState(() {
      _isSheetOpen = false;
      _draftValues = <T>[];
      _isLoadMoreLocked = false;
    });
  }

  void _handleScroll() {
    if (!_isSheetOpen) return;
    if (widget.enableLocalFilter) return;
    if (widget.onLoadMore == null) return;
    if (!widget.hasMore || widget.isLoading || widget.isLoadingMore) return;
    if (_isLoadMoreLocked) return;
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final remainingExtent = position.maxScrollExtent - position.pixels;

    if (remainingExtent <= widget.loadMoreTriggerOffset) {
      _isLoadMoreLocked = true;
      widget.onLoadMore?.call();
      _refreshSheetIfNeeded();
    }
  }

  void _syncLoadMoreLock(AppBottomSheetSelect<T> oldWidget) {
    final itemCountChanged = oldWidget.items.length != widget.items.length;
    final loadMoreFinished = oldWidget.isLoadingMore && !widget.isLoadingMore;

    if (itemCountChanged || loadMoreFinished || !widget.hasMore) {
      _isLoadMoreLocked = false;
    }
  }

  bool _isItemSelected(T item) {
    if (widget.isMultiSelect) {
      return _draftValues.contains(item);
    }

    return widget.value == item;
  }

  void _toggleMultiItem(T item) {
    final nextValues = List<T>.from(_draftValues);

    if (nextValues.contains(item)) {
      nextValues.remove(item);
    } else {
      nextValues.add(item);
    }

    _draftValues = nextValues;
    _refreshSheetIfNeeded();
  }

  void _applyMultiSelection(BuildContext bottomSheetContext) {
    widget.onChangedMulti?.call(List<T>.unmodifiable(_draftValues));
    AppBottomSheet.close(bottomSheetContext);
  }

  void _clearSelection() {
    if (!_hasSelection || widget.isDisabled) return;

    _displayController.clear();

    if (widget.isMultiSelect) {
      widget.onChangedMulti?.call(<T>[]);
      return;
    }

    widget.onChanged?.call(null);
  }

  void _selectSingleItem(T item, BuildContext bottomSheetContext) {
    final nextValue = widget.value == item ? null : item;
    widget.onChanged?.call(nextValue);
    AppBottomSheet.close(bottomSheetContext);
  }

  Widget _buildTriggerSuffixIcon() {
    if (!_hasSelection || widget.isDisabled) {
      return widget.suffixIcon ?? const Icon(Icons.keyboard_arrow_down_rounded);
    }

    return IconButton(
      onPressed: _clearSelection,
      icon: const Icon(Icons.close_rounded),
      splashRadius: 18,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      visualDensity: VisualDensity.compact,
    );
  }

  _AppBottomSheetSelectViewState<T> _resolveViewState() {
    final items = _filteredItems;
    final showLoadingState = widget.isLoading;
    final showErrorState = widget.sheetErrorText?.isNotEmpty == true;
    final showEmptyState =
        !showLoadingState && !showErrorState && items.isEmpty;
    final showLoadMoreFooter =
        !showLoadingState &&
        !showErrorState &&
        items.isNotEmpty &&
        widget.isLoadingMore;

    return _AppBottomSheetSelectViewState<T>(
      items: items,
      showLoadingState: showLoadingState,
      showErrorState: showErrorState,
      showEmptyState: showEmptyState,
      showLoadMoreFooter: showLoadMoreFooter,
    );
  }

  double _resolveBodyHeight(_AppBottomSheetSelectViewState<T> viewState) {
    if (viewState.showLoadingState ||
        viewState.showErrorState ||
        viewState.showEmptyState) {
      return 120;
    }

    final maxHeight = widget.sheetListMaxHeight;
    final separatorCount = math.max(viewState.totalCount - 1, 0);
    final estimatedHeight =
        viewState.totalCount * _metrics.estimatedItemHeight +
        (separatorCount * SpacingTokens.gapS);

    return math.min(maxHeight, math.max(estimatedHeight, 120));
  }

  Widget _buildSheetContent(BuildContext bottomSheetContext) {
    return ListenableBuilder(
      listenable: _searchController,
      builder: (context, _) {
        final viewState = _resolveViewState();

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isSearchEnabled) ...[
              AppSearchField(
                controller: _searchController,
                hintText: widget.searchHintText,
                size: _metrics.searchFieldSize,
                autofocus: true,
                searchDelay: widget.searchDelay,
                onSearchChanged:
                    _isRemoteSearchMode ? widget.onSearchChanged : null,
              ),
              const SizedBox(height: SpacingTokens.paddingM),
            ],
            SizedBox(
              height: _resolveBodyHeight(viewState),
              child: _buildBody(
                bottomSheetContext: bottomSheetContext,
                viewState: viewState,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody({
    required BuildContext bottomSheetContext,
    required _AppBottomSheetSelectViewState<T> viewState,
  }) {
    if (viewState.showLoadingState) {
      return const _AppBottomSheetSelectLoadingState();
    }

    if (viewState.showErrorState) {
      return _AppBottomSheetSelectErrorState(
        text: widget.sheetErrorText ?? 'Có lỗi xảy ra',
        buttonSize: _metrics.retryButtonSize,
        onRetry: widget.onRetry,
      );
    }

    if (viewState.showEmptyState) {
      return _AppBottomSheetSelectEmptyState(
        text: widget.emptyText,
        textSize: _metrics.descriptionTextSize,
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      itemCount: viewState.totalCount,
      itemBuilder: (context, index) {
        if (viewState.isFooterIndex(index)) {
          return const _AppBottomSheetSelectLoadingMoreFooter();
        }

        return _buildOptionTile(
          item: viewState.items[index],
          bottomSheetContext: bottomSheetContext,
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: SpacingTokens.gapS),
    );
  }

  Widget _buildOptionTile({
    required T item,
    required BuildContext bottomSheetContext,
  }) {
    final isSelected = _isItemSelected(item);
    final description = widget.itemDescriptionAsString?.call(item);

    return Material(
      color: ColorTokens.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(RadiusTokens.radiusM),
        onTap:
            widget.isMultiSelect
                ? () => _toggleMultiItem(item)
                : () => _selectSingleItem(item, bottomSheetContext),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: _metrics.itemHorizontalPadding,
            vertical: _metrics.itemVerticalPadding,
          ),
          decoration: BoxDecoration(
            color: isSelected ? ColorTokens.primaryBg : ColorTokens.white,
            borderRadius: RadiusTokens.radiusMdBorderRadius,
            border: Border.all(
              color:
                  isSelected
                      ? ColorTokens.primaryDefault
                      : ColorTokens.borderDefault,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      text: widget.itemAsString(item),
                      size: _metrics.itemTextSize,
                      color: ColorTokens.textDefault,
                    ),
                    if (description?.trim().isNotEmpty == true) ...[
                      const SizedBox(height: SpacingTokens.gapXS),
                      AppText(
                        text: description!,
                        size: _metrics.descriptionTextSize,
                        color: ColorTokens.textDescription,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: SpacingTokens.gapS),
              widget.isMultiSelect
                  ? AppCheckbox(
                    value: isSelected,
                    onChanged: (_) => _toggleMultiItem(item),
                  )
                  : AppRadio<T>(
                    value: item,
                    groupValue: isSelected ? item : null,
                    onChanged:
                        (_) => _selectSingleItem(item, bottomSheetContext),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: _displayController,
      focusNode: _triggerFocusNode,
      onTap: _openSheet,
      variant: widget.variant,
      size: widget.size,
      isRounded: widget.isRounded,
      hintText: widget.hintText,
      labelText: widget.labelText,
      helperText: widget.helperText,
      errorText: widget.errorText,
      isDisabled: widget.isDisabled,
      isReadOnly: false,
      isRequired: widget.isRequired,
      isOptional: widget.isOptional,
      showClearTextAction: false,
      prefixIcon: widget.prefixIcon,
      suffixIcon: _buildTriggerSuffixIcon(),
      floatingLabelBehavior: widget.floatingLabelBehavior,
      keyboardType: TextInputType.none,
    );
  }
}

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

class _AppBottomSheetSelectLoadingState extends StatelessWidget {
  const _AppBottomSheetSelectLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SpacingTokens.paddingM,
          vertical: SpacingTokens.paddingL,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLoadingSpinner(
              size: 18,
              strokeWidth: 2,
              color: ColorTokens.primaryDefault,
              semanticsLabel: 'Loading data',
            ),
            SizedBox(width: SpacingTokens.gapS),
            AppText(
              text: 'Đang tải dữ liệu...',
              size: AppTextSize.bodyMRegular,
              color: ColorTokens.textLabel,
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBottomSheetSelectEmptyState extends StatelessWidget {
  final String text;
  final AppTextSize textSize;

  const _AppBottomSheetSelectEmptyState({
    required this.text,
    required this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.paddingM,
          vertical: SpacingTokens.paddingL,
        ),
        child: AppText(
          text: text,
          size: textSize,
          color: ColorTokens.textLabel,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _AppBottomSheetSelectErrorState extends StatelessWidget {
  final String text;
  final AppButtonSize buttonSize;
  final VoidCallback? onRetry;

  const _AppBottomSheetSelectErrorState({
    required this.text,
    required this.buttonSize,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.paddingM,
          vertical: SpacingTokens.paddingL,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              text: text,
              size: AppTextSize.bodyMRegular,
              color: ColorTokens.dangerDefault,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SpacingTokens.gapS),
            AppButton(
              text: 'Thử lại',
              variant: AppButtonVariant.primary,
              size: buttonSize,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBottomSheetSelectLoadingMoreFooter extends StatelessWidget {
  const _AppBottomSheetSelectLoadingMoreFooter();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SpacingTokens.paddingM,
        vertical: SpacingTokens.paddingM,
      ),
      child: Row(
        children: [
          AppLoadingSpinner(
            size: 16,
            strokeWidth: 2,
            color: ColorTokens.primaryDefault,
            semanticsLabel: 'Loading more data',
          ),
          SizedBox(width: SpacingTokens.gapS),
          Expanded(
            child: AppText(
              text: 'Đang tải thêm...',
              size: AppTextSize.bodySRegular,
              color: ColorTokens.textLabel,
            ),
          ),
        ],
      ),
    );
  }
}

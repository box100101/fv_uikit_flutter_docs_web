import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

part 'app_bottom_sheet_select_helpers.dart';
part 'app_bottom_sheet_select_models.dart';
part 'app_bottom_sheet_select_sheet.dart';
part 'app_bottom_sheet_select_states.dart';

class AppBottomSheetSelect<T> extends StatefulWidget {
  final String? labelText;
  final String hintText;
  final String? helperText;
  final AppTextSize? helperTextSize;
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
    this.helperTextSize,
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
    this.helperTextSize,
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

  @override
  void initState() {
    super.initState();
    _displayController = TextEditingController(text: _displayText);
    _displayController.addListener(_handleDisplayControllerChanged);
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
    _displayController.removeListener(_handleDisplayControllerChanged);
    _displayController.dispose();
    _triggerFocusNode.dispose();
    _sheetRevisionNotifier.dispose();
    _searchController.dispose();
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleDisplayControllerChanged() {
    final resolvedDisplayText = _displayText;
    if (_displayController.text == resolvedDisplayText) return;

    _displayController.value = TextEditingValue(
      text: resolvedDisplayText,
      selection: TextSelection.collapsed(offset: resolvedDisplayText.length),
    );
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
      helperTextSize: widget.helperTextSize,
      errorText: widget.errorText,
      isDisabled: widget.isDisabled,
      isReadOnly: false,
      showCursor: false,
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

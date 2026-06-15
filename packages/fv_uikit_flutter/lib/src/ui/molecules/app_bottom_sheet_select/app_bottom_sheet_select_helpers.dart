part of 'app_bottom_sheet_select.dart';

extension _AppBottomSheetSelectHelpers<T> on _AppBottomSheetSelectState<T> {
  bool get _isSearchEnabled => widget.isSearchable;

  bool get _isRemoteSearchMode => _isSearchEnabled && !widget.enableLocalFilter;

  _AppBottomSheetSelectMetrics get _metrics =>
      _AppBottomSheetSelectMetrics.fromFieldSize(widget.size);

  bool get _hasSelection =>
      widget.isMultiSelect ? widget.values.isNotEmpty : widget.value != null;

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

  bool _isItemSelected(T item) {
    if (widget.isMultiSelect) {
      return _draftValues.contains(item);
    }

    return widget.value == item;
  }

  void _syncLoadMoreLock(AppBottomSheetSelect<T> oldWidget) {
    final itemCountChanged = oldWidget.items.length != widget.items.length;
    final loadMoreFinished = oldWidget.isLoadingMore && !widget.isLoadingMore;

    if (itemCountChanged || loadMoreFinished || !widget.hasMore) {
      _isLoadMoreLocked = false;
    }
  }

  void _clearSelection() {
    if (!_hasSelection || widget.isDisabled) return;

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
}

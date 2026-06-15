part of 'app_bottom_sheet_select.dart';

extension _AppBottomSheetSelectSheet<T> on _AppBottomSheetSelectState<T> {
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
}

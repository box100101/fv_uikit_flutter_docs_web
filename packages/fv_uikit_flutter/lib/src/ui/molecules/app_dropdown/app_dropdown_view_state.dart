class AppDropdownMenuViewState<T> {
  final bool showSearchField;
  final bool showLoadingState;
  final bool showErrorState;
  final bool showEmptyState;
  final bool showLoadMoreFooter;
  final List<T> items;

  const AppDropdownMenuViewState({
    required this.showSearchField,
    required this.showLoadingState,
    required this.showErrorState,
    required this.showEmptyState,
    required this.showLoadMoreFooter,
    required this.items,
  });

  int get totalCount => items.length + (showLoadMoreFooter ? 1 : 0);

  bool isFooterIndex(int index) => showLoadMoreFooter && index == items.length;
}

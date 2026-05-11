import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';
import 'package:fv_uikit_flutter/src/ui/molecules/app_dropdown/app_dropdown_view_state.dart';

class AppDropdownMenuBody<T> extends StatelessWidget {
  final AppDropdownMenuViewState<T> viewState;
  final ScrollController scrollController;
  final Widget loadingState;
  final Widget errorState;
  final Widget emptyState;
  final Widget loadingMoreFooter;
  final Widget Function(T item, int index) itemBuilder;

  const AppDropdownMenuBody({
    super.key,
    required this.viewState,
    required this.scrollController,
    required this.loadingState,
    required this.errorState,
    required this.emptyState,
    required this.loadingMoreFooter,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (viewState.showLoadingState) {
      return loadingState;
    }

    if (viewState.showErrorState) {
      return errorState;
    }

    if (viewState.showEmptyState) {
      return emptyState;
    }

    return Flexible(
      child: ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: viewState.totalCount,
        itemBuilder: (context, index) {
          final isFooter = viewState.isFooterIndex(index);

          return Padding(
            padding: EdgeInsets.only(
              bottom:
                  index == viewState.totalCount - 1 ? 0 : SpacingTokens.gapS,
            ),
            child:
                isFooter
                    ? loadingMoreFooter
                    : itemBuilder(viewState.items[index], index),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

class AppTablePaginationBar extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final int total;
  final int startRecord;
  final int endRecord;
  final int pageSize;
  final List<int> rowsPerPageOptions;
  final bool hasJumpButton;
  final String Function(int start, int end, int total)? recordTextBuilder;
  final String Function(int size)? pageSizeLabelBuilder;
  final String jumpToPageLabel;
  final String cancelLabel;
  final String goLabel;
  final ValueChanged<int> onGoToPage;
  final ValueChanged<int> onChangePageSize;

  const AppTablePaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.total,
    required this.startRecord,
    required this.endRecord,
    required this.pageSize,
    this.rowsPerPageOptions = const [10, 20, 50, 100],
    this.hasJumpButton = false,
    this.recordTextBuilder,
    this.pageSizeLabelBuilder,
    this.jumpToPageLabel = 'Đi đến trang',
    this.cancelLabel = 'Huỷ',
    this.goLabel = 'Đi',
    required this.onGoToPage,
    required this.onChangePageSize,
  });

  @override
  State<AppTablePaginationBar> createState() => _AppTablePaginationBarState();
}

class _AppTablePaginationBarState extends State<AppTablePaginationBar> {
  late final TextEditingController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<dynamic> _buildPageItems(int currentPage, int totalPages, bool isMobile) {
    final maxItems = isMobile ? 5 : 7;
    if (totalPages <= maxItems) {
      return List<int>.generate(totalPages, (index) => index + 1);
    }

    if (isMobile) {
      if (currentPage <= 3) {
        return [1, 2, 3, 'ellipsis', totalPages];
      } else if (currentPage >= totalPages - 2) {
        return [1, 'ellipsis', totalPages - 2, totalPages - 1, totalPages];
      } else {
        return [1, 'ellipsis', currentPage, 'ellipsis', totalPages];
      }
    } else {
      if (currentPage <= 4) {
        return [1, 2, 3, 4, 5, 'ellipsis', totalPages];
      } else if (currentPage >= totalPages - 3) {
        return [
          1,
          'ellipsis',
          totalPages - 4,
          totalPages - 3,
          totalPages - 2,
          totalPages - 1,
          totalPages
        ];
      } else {
        return [
          1,
          'ellipsis',
          currentPage - 1,
          currentPage,
          currentPage + 1,
          'ellipsis',
          totalPages
        ];
      }
    }
  }

  void _showPageJumpDialog() {
    _pageController.clear();
    AppModal.show(
      context: context,
      builder: (dialogContext) => AppModal(
        title: widget.jumpToPageLabel,
        titleCancelAction: widget.cancelLabel,
        onCancelAction: () => Navigator.pop(dialogContext),
        titlePrimaryAction: widget.goLabel,
        onPrimaryAction: () => _handlePageJump(dialogContext),
        child: Padding(
          padding: const EdgeInsets.only(top: SpacingTokens.spaceS),
          child: AppTextField(
            controller: _pageController,
            autofocus: true,
            keyboardType: TextInputType.number,
            labelText: 'Từ 1 tới ${widget.totalPages}',
          ),
        ),
      ),
    );
  }

  void _handlePageJump(BuildContext dialogContext) {
    final page = int.tryParse(_pageController.text);
    if (page != null && page >= 1 && page <= widget.totalPages) {
      Navigator.pop(dialogContext);
      widget.onGoToPage(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recordTextBuilder = widget.recordTextBuilder ?? (start, end, total) => 'Từ $start-$end trên tổng $total';
    final pageSizeLabelBuilder = widget.pageSizeLabelBuilder ?? (size) => '$size / trang';

    final recordText = recordTextBuilder(widget.startRecord, widget.endRecord, widget.total);
    final hasPreviousPage = widget.currentPage > 1;
    final hasNextPage = widget.currentPage < widget.totalPages;

    Widget buildPageNavigation(bool isMobile) {
      final pageItems = _buildPageItems(widget.currentPage, widget.totalPages, isMobile);

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 20),
            onPressed: hasPreviousPage ? () => widget.onGoToPage(widget.currentPage - 1) : null,
            padding: isMobile ? EdgeInsets.zero : const EdgeInsets.all(8),
            constraints: isMobile ? const BoxConstraints(minWidth: 30, minHeight: 30) : const BoxConstraints(),
            splashRadius: isMobile ? 15 : 18,
            style: isMobile ? IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap) : null,
          ),
          SizedBox(width: isMobile ? 2 : SpacingTokens.spaceXS),
          ...pageItems.map(
            (item) => Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 1.0 : 2),
              child: item == 'ellipsis'
                  ? SizedBox(
                      width: isMobile ? 16 : 24,
                      child: const Center(
                        child: AppText(text: '...', size: AppTextSize.bodyMRegular),
                      ),
                    )
                  : OutlinedButton(
                      onPressed: item == widget.currentPage
                          ? () {} // Keep enabled to show active color border/text
                          : () => widget.onGoToPage(item as int),
                      style: OutlinedButton.styleFrom(
                        fixedSize: isMobile ? const Size(30, 30) : const Size(36, 32),
                        minimumSize: isMobile ? const Size(30, 30) : const Size(36, 32),
                        padding: EdgeInsets.zero,
                        tapTargetSize: isMobile ? MaterialTapTargetSize.shrinkWrap : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(RadiusTokens.radiusM),
                        ),
                        side: BorderSide(
                          color: item == widget.currentPage
                              ? ColorTokens.primaryDefault
                              : ColorTokens.borderSecondary,
                        ),
                      ),
                      child: AppText(
                        text: item.toString(),
                        size: isMobile ? AppTextSize.bodySRegular : AppTextSize.bodyMRegular,
                        color: item == widget.currentPage
                            ? ColorTokens.primaryDefault
                            : ColorTokens.textDefault,
                      ),
                    ),
            ),
          ),
          SizedBox(width: isMobile ? 2 : SpacingTokens.spaceXS),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 20),
            onPressed: hasNextPage ? () => widget.onGoToPage(widget.currentPage + 1) : null,
            padding: isMobile ? EdgeInsets.zero : const EdgeInsets.all(8),
            constraints: isMobile ? const BoxConstraints(minWidth: 30, minHeight: 30) : const BoxConstraints(),
            splashRadius: isMobile ? 15 : 18,
            style: isMobile ? IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap) : null,
          ),
          if (widget.hasJumpButton) ...[
            SizedBox(width: isMobile ? 2 : SpacingTokens.spaceS),
            OutlinedButton(
              onPressed: _showPageJumpDialog,
              style: OutlinedButton.styleFrom(
                fixedSize: isMobile ? const Size(30, 30) : const Size(36, 32),
                minimumSize: isMobile ? const Size(30, 30) : const Size(36, 32),
                padding: EdgeInsets.zero,
                tapTargetSize: isMobile ? MaterialTapTargetSize.shrinkWrap : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(RadiusTokens.radiusM),
                ),
                side: const BorderSide(color: ColorTokens.borderSecondary),
              ),
              child: const Icon(Icons.more_horiz, size: 16),
            ),
          ],
        ],
      );
    }

    Widget buildPageSizeDropdown() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.spaceM),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusTokens.radiusM),
          border: Border.all(color: ColorTokens.borderSecondary),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: widget.pageSize,
            items: widget.rowsPerPageOptions
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: AppText(text: pageSizeLabelBuilder(value), size: AppTextSize.bodyMRegular),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                widget.onChangePageSize(value);
              }
            },
            icon: const Icon(Icons.arrow_drop_down, size: 16),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = constraints.maxWidth < 600 || (constraints.maxWidth == double.infinity && screenWidth < 600);

        return Container(
          padding: EdgeInsets.symmetric(
            vertical: SpacingTokens.yPaddingM,
            horizontal: isMobile ? SpacingTokens.spaceM : SpacingTokens.paddingL,
          ),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: ColorTokens.borderSecondary)),
          ),
          child: isMobile
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AppText(
                            text: recordText,
                            size: AppTextSize.bodyMRegular,
                            color: ColorTokens.textSecondary,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(width: SpacingTokens.spaceM),
                        buildPageSizeDropdown(),
                      ],
                    ),
                    const SizedBox(height: SpacingTokens.spaceM),
                    buildPageNavigation(true),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: AppText(
                        text: recordText,
                        size: AppTextSize.bodyMRegular,
                        color: ColorTokens.textSecondary,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const SizedBox(width: SpacingTokens.spaceM),
                    buildPageNavigation(false),
                    const SizedBox(width: SpacingTokens.spaceL),
                    buildPageSizeDropdown(),
                  ],
                ),
        );
      },
    );
  }
}

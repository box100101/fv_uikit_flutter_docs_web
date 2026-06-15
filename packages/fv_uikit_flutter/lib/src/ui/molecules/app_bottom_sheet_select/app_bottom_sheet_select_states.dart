part of 'app_bottom_sheet_select.dart';

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

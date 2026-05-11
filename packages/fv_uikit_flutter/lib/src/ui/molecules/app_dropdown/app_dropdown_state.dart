import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';
import 'package:fv_uikit_flutter/src/ui/molecules/app_dropdown/app_dropdown_config.dart';

class AppDropdownLoadingState extends StatelessWidget {
  const AppDropdownLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SpacingTokens.paddingM,
        vertical: SpacingTokens.paddingL,
      ),
      child: Row(
        children: [
          AppLoadingSpinner(
            size: 18,
            strokeWidth: 2,
            color: ColorTokens.primaryDefault,
            semanticsLabel: 'Loading data',
          ),
          SizedBox(width: SpacingTokens.gapS),
          Expanded(
            child: AppText(
              text: 'Đang tải dữ liệu...',
              size: AppTextSize.bodyMRegular,
              color: ColorTokens.textLabel,
            ),
          ),
        ],
      ),
    );
  }
}

class AppDropdownEmptyState extends StatelessWidget {
  final String text;
  final AppDropdownMetrics metrics;

  const AppDropdownEmptyState({
    super.key,
    required this.text,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: metrics.itemHorizontalPadding,
        vertical: metrics.itemVerticalPadding,
      ),
      child: Center(
        child: AppText(
          text: text,
          size: metrics.textSize,
          color: ColorTokens.textLabel,
        ),
      ),
    );
  }
}

class AppDropdownErrorState extends StatelessWidget {
  final String text;
  final VoidCallback? onRetry;
  final AppDropdownMetrics metrics;

  const AppDropdownErrorState({
    super.key,
    required this.text,
    required this.onRetry,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: metrics.itemHorizontalPadding,
        vertical: metrics.itemVerticalPadding,
      ),
      child: Column(
        children: [
          AppText(
            text: text,
            size: metrics.textSize,
            color: ColorTokens.dangerDefault,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SpacingTokens.gapS),
          Center(
            child: AppButton(
              text: 'Thử lại',
              variant: AppButtonVariant.primary,
              size: metrics.retryButtonSize,
              alignment: Alignment.center,
              onPressed: () {
                onRetry?.call();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AppDropdownLoadingMoreFooter extends StatelessWidget {
  const AppDropdownLoadingMoreFooter({super.key});

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

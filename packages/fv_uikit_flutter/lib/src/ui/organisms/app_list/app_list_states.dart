import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

// ---------------------------------------------------------------------------
// Loading state — spinner variant
// ---------------------------------------------------------------------------

/// Full-area loading indicator shown during initial data load.
///
/// Reuses [AppLoadingSpinner] and [AppText].
class AppListLoadingState extends StatelessWidget {
  final String text;

  const AppListLoadingState({
    super.key,
    this.text = 'Đang tải dữ liệu...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.paddingL,
          vertical: SpacingTokens.paddingXL,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLoadingSpinner(
              size: 24,
              strokeWidth: 2.5,
              color: ColorTokens.primaryDefault,
              semanticsLabel: 'Loading list data',
            ),
            const SizedBox(height: SpacingTokens.gapM),
            AppText(
              text: text,
              size: AppTextSize.bodyMRegular,
              color: ColorTokens.textSecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading state — skeleton variant
// ---------------------------------------------------------------------------

/// Skeleton shimmer placeholders shown during initial data load.
///
/// Reuses [AppSkeleton].
class AppListSkeletonState extends StatelessWidget {
  /// Number of skeleton items to display. Defaults to `5`.
  final int itemCount;

  /// Optional custom builder for a single skeleton item.
  /// Falls back to a default skeleton layout.
  final Widget Function(BuildContext context, int index)? skeletonBuilder;

  /// Padding around the skeleton list. Defaults to horizontal `paddingL`.
  final EdgeInsetsGeometry padding;

  const AppListSkeletonState({
    super.key,
    this.itemCount = 5,
    this.skeletonBuilder,
    this.padding = const EdgeInsets.symmetric(
      horizontal: SpacingTokens.paddingL,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: SpacingTokens.gapM),
      itemBuilder: (context, index) {
        if (skeletonBuilder != null) {
          return skeletonBuilder!(context, index);
        }
        return const _DefaultSkeletonItem();
      },
    );
  }
}

/// Default skeleton item that resembles a typical list tile layout.
class _DefaultSkeletonItem extends StatelessWidget {
  const _DefaultSkeletonItem();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SpacingTokens.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Leading circle
          const AppSkeleton(
            width: 40,
            height: 40,
            shape: BoxShape.circle,
          ),
          const SizedBox(width: SpacingTokens.gapM),
          // Content lines
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton(
                  height: 14,
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  borderRadius: RadiusTokens.radiusSmBorderRadius,
                ),
                const SizedBox(height: SpacingTokens.gapS),
                AppSkeleton(
                  height: 12,
                  width: MediaQuery.sizeOf(context).width * 0.35,
                  borderRadius: RadiusTokens.radiusSmBorderRadius,
                ),
              ],
            ),
          ),
          const SizedBox(width: SpacingTokens.gapM),
          // Trailing
          const AppSkeleton(
            width: 24,
            height: 14,
            borderRadius: RadiusTokens.radiusSmBorderRadius,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

/// Displayed when the list has no items.
///
/// Reuses [AppText].
class AppListEmptyState extends StatelessWidget {
  final String text;
  final Widget? icon;
  final Widget? action;

  const AppListEmptyState({
    super.key,
    this.text = 'Không có dữ liệu',
    this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.paddingXL,
          vertical: SpacingTokens.padding3XL,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(height: SpacingTokens.gapL),
            ],
            AppText(
              text: text,
              size: AppTextSize.bodyMRegular,
              color: ColorTokens.textTertiary,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: SpacingTokens.gapL),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error state
// ---------------------------------------------------------------------------

/// Displayed when data loading fails.
///
/// Reuses [AppText] and [AppButton].
class AppListErrorState extends StatelessWidget {
  final String text;
  final String retryText;
  final VoidCallback? onRetry;

  const AppListErrorState({
    super.key,
    this.text = 'Có lỗi xảy ra',
    this.retryText = 'Thử lại',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.paddingXL,
          vertical: SpacingTokens.padding3XL,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: ColorTokens.dangerDefault,
            ),
            const SizedBox(height: SpacingTokens.gapM),
            AppText(
              text: text,
              size: AppTextSize.bodyMRegular,
              color: ColorTokens.dangerDefault,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: SpacingTokens.gapL),
              AppButton(
                text: retryText,
                variant: AppButtonVariant.outline,
                size: AppButtonSize.medium,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading more footer
// ---------------------------------------------------------------------------

/// Footer shown at the bottom of the list while loading additional pages.
///
/// Reuses [AppLoadingSpinner] and [AppText].
class AppListLoadingMoreFooter extends StatelessWidget {
  final String text;

  const AppListLoadingMoreFooter({
    super.key,
    this.text = 'Đang tải thêm...',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.paddingL,
        vertical: SpacingTokens.paddingM,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppLoadingSpinner(
            size: 16,
            strokeWidth: 2,
            color: ColorTokens.primaryDefault,
            semanticsLabel: 'Loading more data',
          ),
          const SizedBox(width: SpacingTokens.gapS),
          AppText(
            text: text,
            size: AppTextSize.bodySRegular,
            color: ColorTokens.textSecondary,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

/// Header for a section in [AppSectionList].
///
/// Reuses [AppText].
class AppListSectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final bool isCollapsible;
  final bool isExpanded;
  final VoidCallback? onToggle;
  final Color? backgroundColor;

  const AppListSectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.isCollapsible = false,
    this.isExpanded = true,
    this.onToggle,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final header = Container(
      color: backgroundColor ?? ColorTokens.bgLayout,
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.paddingL,
        vertical: SpacingTokens.paddingM,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppText(
              text: title,
              size: AppTextSize.bodySBold,
              color: ColorTokens.textSecondary,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: SpacingTokens.gapS),
            trailing!,
          ],
          if (isCollapsible) ...[
            const SizedBox(width: SpacingTokens.gapS),
            AnimatedRotation(
              turns: isExpanded ? 0 : -0.25,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: ColorTokens.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );

    if (isCollapsible && onToggle != null) {
      return GestureDetector(
        onTap: onToggle,
        behavior: HitTestBehavior.opaque,
        child: header,
      );
    }

    return header;
  }
}

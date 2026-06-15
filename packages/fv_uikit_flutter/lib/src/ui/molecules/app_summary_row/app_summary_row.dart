import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

/// [AppSummaryRow] is a molecule widget typically used in summary lists, checkout pages,
/// or detail screens to display a label-value pair with an optional bottom divider.
///
/// It follows the Atomic Design principles and project style guide.
class AppSummaryRow extends StatelessWidget {
  /// The descriptive text displayed on the left side of the row.
  final String label;

  /// The text value displayed on the right side of the row.
  ///
  /// This is only used if [valueWidget] is null.
  final String? value;

  /// A custom widget displayed on the right side of the row.
  ///
  /// If provided, this widget takes precedence and is rendered instead of [value].
  final Widget? valueWidget;

  /// Determines if the text should be rendered in bold style.
  ///
  /// When true, both label and value use [AppTextSize.bodyMBold] and the label's color
  /// changes to [ColorTokens.textDefault]. When false, they use [AppTextSize.bodyMRegular]
  /// and the label's color is [ColorTokens.textSecondary].
  final bool isBold;

  /// Determines whether to show a divider at the bottom of the row.
  ///
  /// Defaults to true.
  final bool showBottomDivider;

  /// Optional custom padding for the row container.
  ///
  /// Defaults to [SpacingTokens.paddingS] vertical symmetric padding.
  final EdgeInsetsGeometry? padding;

  /// Optional custom thickness of the bottom divider.
  ///
  /// Defaults to 1.
  final double? dividerHeight;

  /// Optional custom color of the bottom divider.
  ///
  /// Defaults to [ColorTokens.borderSecondary].
  final Color? dividerColor;

  /// Creates an [AppSummaryRow] instance.
  const AppSummaryRow({
    super.key,
    required this.label,
    this.value,
    this.valueWidget,
    this.isBold = false,
    this.showBottomDivider = true,
    this.padding,
    this.dividerHeight,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: padding ?? const EdgeInsets.symmetric(vertical: SpacingTokens.paddingS),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppText(
                  text: label,
                  size: isBold ? AppTextSize.bodyMBold : AppTextSize.bodyMRegular,
                  color: isBold ? ColorTokens.textDefault : ColorTokens.textSecondary,
                ),
              ),
              const SizedBox(width: SpacingTokens.spaceM),
              valueWidget ??
                  AppText(
                    text: value ?? '',
                    size: isBold ? AppTextSize.bodyMBold : AppTextSize.bodyMRegular,
                    color: ColorTokens.textDefault,
                  ),
            ],
          ),
        ),
        if (showBottomDivider)
          AppDivider(
            thickness: dividerHeight ?? 1,
            color: dividerColor ?? ColorTokens.borderSecondary,
          ),
      ],
    );
  }
}

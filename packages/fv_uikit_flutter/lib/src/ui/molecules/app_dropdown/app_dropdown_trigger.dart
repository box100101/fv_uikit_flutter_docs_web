import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';
import 'package:fv_uikit_flutter/src/ui/molecules/app_dropdown/app_dropdown_config.dart';

class AppDropdownTrigger extends StatelessWidget {
  final String? labelText;
  final String displayText;
  final bool isShowingHint;
  final bool isMenuOpen;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback onTap;
  final LayerLink layerLink;
  final GlobalKey targetKey;
  final AppDropdownMetrics metrics;
  final bool isDisabled;
  final bool opensAbove;

  const AppDropdownTrigger({
    super.key,
    required this.labelText,
    required this.displayText,
    required this.isShowingHint,
    required this.isMenuOpen,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.onTap,
    required this.layerLink,
    required this.targetKey,
    required this.metrics,
    required this.isDisabled,
    required this.opensAbove,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor =
        isDisabled ? ColorTokens.textDescription : ColorTokens.textLabel;

    final backgroundColor =
        isDisabled ? ColorTokens.bgContainerDisabled : ColorTokens.bgElevated;

    final textColor =
        isDisabled
            ? ColorTokens.textDisabled
            : (isShowingHint
                ? ColorTokens.textPlaceholder
                : ColorTokens.textDefault);

    final iconColor =
        isDisabled ? ColorTokens.textDisabled : ColorTokens.iconDefault;

    final borderSide = BorderSide(
      color:
          isDisabled ? ColorTokens.borderSecondary : ColorTokens.borderDefault,
    );
    final borderRadius =
        !isMenuOpen
            ? BorderRadius.circular(metrics.borderRadius)
            : opensAbove
            ? BorderRadius.vertical(
              bottom: Radius.circular(metrics.borderRadius),
            )
            : BorderRadius.vertical(top: Radius.circular(metrics.borderRadius));
    final border =
        !isMenuOpen
            ? Border.fromBorderSide(borderSide)
            : opensAbove
            ? Border(left: borderSide, right: borderSide, bottom: borderSide)
            : Border(top: borderSide, left: borderSide, right: borderSide);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(bottom: SpacingTokens.spaceXS),
            child: AppText(
              text: labelText!,
              size: metrics.textSize,
              color: labelColor,
            ),
          ),
        CompositedTransformTarget(
          key: targetKey,
          link: layerLink,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: isDisabled ? null : onTap,
            child: Container(
              constraints: BoxConstraints(minHeight: metrics.height),
              padding: EdgeInsets.symmetric(
                horizontal: metrics.triggerHorizontalPadding,
                vertical: metrics.triggerVerticalPadding,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: borderRadius,
                border: border,
              ),
              child: Row(
                children: [
                  if (prefixIcon != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        color: iconColor,
                        size: metrics.iconSize,
                      ),
                      child: prefixIcon!,
                    ),
                    const SizedBox(width: SpacingTokens.gapS),
                  ],
                  Expanded(
                    child: AppText(
                      text: displayText,
                      size: metrics.textSize,
                      color: textColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  suffixIcon ??
                      AnimatedRotation(
                        turns: isMenuOpen ? 0.5 : 0,
                        duration: const Duration(milliseconds: 160),
                        child: IconTheme(
                          data: IconThemeData(
                            color: iconColor,
                            size: metrics.iconSize,
                          ),
                          child: const Icon(Icons.keyboard_arrow_down_rounded),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

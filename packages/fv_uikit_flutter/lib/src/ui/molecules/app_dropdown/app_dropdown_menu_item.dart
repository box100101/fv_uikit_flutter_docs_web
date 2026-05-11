import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';
import 'package:fv_uikit_flutter/src/ui/molecules/app_dropdown/app_dropdown_config.dart';

class AppDropdownMenuItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Color backgroundColor;
  final VoidCallback onTap;
  final AppDropdownMetrics metrics;

  const AppDropdownMenuItem({
    super.key,
    required this.text,
    required this.isSelected,
    required this.backgroundColor,
    required this.onTap,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: metrics.itemHorizontalPadding,
          vertical: metrics.itemVerticalPadding,
        ),
        decoration: BoxDecoration(
        color: backgroundColor,
          borderRadius: BorderRadius.circular(metrics.borderRadius),
        ),
        child: Row(
          children: [
            Expanded(
              child: AppText(
                text: text,
                size: metrics.textSize,
                color: ColorTokens.textDefault,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_rounded,
                color: ColorTokens.primaryDefault,
                size: metrics.iconSize,
              ),
          ],
        ),
      ),
    );
  }
}

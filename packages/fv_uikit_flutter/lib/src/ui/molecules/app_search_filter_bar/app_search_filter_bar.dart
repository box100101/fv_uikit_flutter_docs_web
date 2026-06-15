import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';


class AppSearchFilterBar extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final String hintText;
  final ValueChanged<String>? onSearchChanged;
  final int searchDelay;
  final VoidCallback onFilterTap;
  final bool isFilterActive;
  final EdgeInsetsGeometry? padding;
  final String filterLabel;

  const AppSearchFilterBar({
    super.key,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.hintText = 'Tìm kiếm...',
    this.onSearchChanged,
    this.searchDelay = 400,
    required this.onFilterTap,
    this.isFilterActive = false,
    this.padding,
    this.filterLabel = 'Lọc',
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: AppSearchField(
              controller: controller,
              focusNode: focusNode,
              autofocus: autofocus,
              hintText: hintText,
              onSearchChanged: onSearchChanged,
              searchDelay: searchDelay,
              size: AppTextFieldSize.medium,
            ),
          ),
          const SizedBox(width: SpacingTokens.spaceS),
          Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                color: isFilterActive ? ColorTokens.primaryBg : ColorTokens.bgContainer,
                borderRadius: BorderRadius.circular(RadiusTokens.radiusM),
                border: Border.all(
                  color: isFilterActive ? ColorTokens.primaryDefault : ColorTokens.borderSecondary,
                ),
              ),
              child: InkWell(
                onTap: onFilterTap,
                borderRadius: BorderRadius.circular(RadiusTokens.radiusM),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpacingTokens.paddingL,
                    vertical: SpacingTokens.paddingM,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.filter_list_rounded,
                        color: isFilterActive ? ColorTokens.primaryDefault : ColorTokens.textDefault,
                        size: 16,
                      ),
                      const SizedBox(width: SpacingTokens.spaceXS),
                      AppText(
                        text: filterLabel,
                        size: AppTextSize.bodyMMedium,
                        color: isFilterActive ? ColorTokens.primaryDefault : ColorTokens.textDefault,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

enum AppSegmentedControlStyle { tablet, mobile }

class AppSegmentedControlItem {
  final String label;
  final int? count;
  final Widget? icon;

  const AppSegmentedControlItem({
    required this.label,
    this.count,
    this.icon,
  });
}

class AppSegmentedControl extends StatelessWidget {
  final List<AppSegmentedControlItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final AppSegmentedControlStyle style;
  final Color? activeColor;
  final Color? inactiveColor;
  final EdgeInsetsGeometry? padding;

  const AppSegmentedControl({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.style = AppSegmentedControlStyle.tablet,
    this.activeColor,
    this.inactiveColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (style == AppSegmentedControlStyle.tablet) {
      return _buildTabletStyle(context);
    } else {
      return _buildMobileStyle(context);
    }
  }

  Widget _buildTabletStyle(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(SpacingTokens.spaceXS),
      decoration: BoxDecoration(
        color: inactiveColor ?? ColorTokens.fillTertiary,
        borderRadius: BorderRadius.circular(RadiusTokens.radiusM),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(items.length, (index) {
            final isSelected = selectedIndex == index;
            final item = items[index];

            final childWidget = ClipRRect(
              borderRadius: BorderRadius.circular(RadiusTokens.radiusM),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected
                      ? (activeColor ?? ColorTokens.primaryDefault)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(RadiusTokens.radiusM),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onSelected(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: SpacingTokens.paddingM,
                        horizontal: SpacingTokens.paddingL,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (item.icon != null) ...[
                            IconTheme.merge(
                              data: IconThemeData(
                                color: isSelected
                                    ? ColorTokens.textLight
                                    : ColorTokens.textDefault,
                              ),
                              child: item.icon!,
                            ),
                            const SizedBox(width: SpacingTokens.spaceXS),
                          ],
                          AppText(
                            text: item.label,
                            size: isSelected
                                ? AppTextSize.bodyMMedium
                                : AppTextSize.bodyMRegular,
                            color: isSelected
                                ? ColorTokens.textLight
                                : ColorTokens.textDefault,
                          ),
                          if (item.count != null) ...[
                            const SizedBox(width: SpacingTokens.spaceXS),
                            AppBadge(
                              text: item.count.toString(),
                              size: AppBadgeSize.xSmall,
                              backgroundColor: isSelected
                                  ? const Color(0x33FFFFFF)
                                  : ColorTokens.fillSecondary,
                              textColor: isSelected
                                  ? ColorTokens.textLight
                                  : ColorTokens.textDefault,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );

            if (index == 0) return childWidget;
            final hasSpacing = inactiveColor == Colors.transparent;
            return Padding(
              padding: EdgeInsets.only(left: hasSpacing ? SpacingTokens.gapS : 0),
              child: childWidget,
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMobileStyle(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(SpacingTokens.spaceXS),
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: SpacingTokens.spaceXS),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: ColorTokens.bgContainer,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: selectedIndex == i
                          ? (activeColor ?? ColorTokens.primaryDefault)
                          : ColorTokens.borderSecondary,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onSelected(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: SpacingTokens.paddingM,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (items[i].icon != null) ...[
                                IconTheme.merge(
                                  data: IconThemeData(
                                    color: selectedIndex == i
                                        ? (activeColor ?? ColorTokens.primaryDefault)
                                        : ColorTokens.textDefault,
                                  ),
                                  child: items[i].icon!,
                                ),
                                const SizedBox(width: SpacingTokens.spaceXS),
                              ],
                              AppText(
                                text: items[i].label,
                                size: selectedIndex == i
                                    ? AppTextSize.bodyMMedium
                                    : AppTextSize.bodyMRegular,
                                color: selectedIndex == i
                                    ? (activeColor ?? ColorTokens.primaryDefault)
                                    : ColorTokens.textDefault,
                              ),
                              if (items[i].count != null) ...[
                                const SizedBox(width: SpacingTokens.spaceXS),
                                AppBadge(
                                  text: items[i].count.toString(),
                                  size: AppBadgeSize.xSmall,
                                  backgroundColor: selectedIndex == i
                                      ? (activeColor ?? ColorTokens.primaryDefault)
                                      : ColorTokens.fillSecondary,
                                  textColor: selectedIndex == i
                                      ? ColorTokens.textLight
                                      : ColorTokens.textDefault,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

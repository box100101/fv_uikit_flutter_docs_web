import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

part 'app_bottom_navigator_metrics.dart';

@immutable
class AppBottomNavigatorItem {
  final String label;
  final Widget icon;
  final Widget? activeIcon;
  final bool enabled;
  final String? semanticsLabel;

  const AppBottomNavigatorItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    this.enabled = true,
    this.semanticsLabel,
  });
}

class AppBottomNavigator extends StatelessWidget {
  final List<AppBottomNavigatorItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? disabledColor;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? iconSize;
  final double? itemMinWidth;
  final int? labelMaxLines;
  final double? labelSpacing;
  final bool? respectBottomSafeArea;
  final AppTextSize? selectedLabelSize;
  final AppTextSize? unselectedLabelSize;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  const AppBottomNavigator({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.selectedColor,
    this.unselectedColor,
    this.disabledColor,
    this.padding,
    this.height,
    this.iconSize,
    this.itemMinWidth,
    this.labelMaxLines,
    this.labelSpacing,
    this.respectBottomSafeArea = true,
    this.selectedLabelSize,
    this.unselectedLabelSize,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
  }) : assert(items.length > 0, 'items must not be empty'),
       assert(
         currentIndex >= 0 && currentIndex < items.length,
         'currentIndex must be within items range',
       );

  Color get _resolvedBackgroundColor => backgroundColor ?? ColorTokens.white;

  Color get _resolvedBorderColor => borderColor ?? ColorTokens.borderSecondary;

  Color _resolveItemColor({required bool isSelected, required bool isEnabled}) {
    if (!isEnabled) return disabledColor ?? ColorTokens.textDisabled;
    if (isSelected) return selectedColor ?? ColorTokens.primaryDefault;
    return unselectedColor ?? ColorTokens.iconDefault;
  }

  Widget _buildIcon({
    required AppBottomNavigatorItem item,
    required _AppBottomNavigatorMetrics metrics,
    required bool isSelected,
    required Color color,
  }) {
    final Widget resolvedIcon =
        isSelected ? item.activeIcon ?? item.icon : item.icon;

    return IconTheme(
      data: IconThemeData(size: metrics.iconSize, color: color),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: color),
        child: resolvedIcon,
      ),
    );
  }

  Widget _buildItemContent({
    required AppBottomNavigatorItem item,
    required bool isSelected,
    required _AppBottomNavigatorMetrics metrics,
  }) {
    final Color itemColor = _resolveItemColor(
      isSelected: isSelected,
      isEnabled: item.enabled,
    );
    final TextStyle? labelStyle =
        isSelected ? selectedLabelStyle : unselectedLabelStyle;

    return Padding(
      padding: metrics.itemPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(
            item: item,
            metrics: metrics,
            isSelected: isSelected,
            color: itemColor,
          ),
          SizedBox(height: labelSpacing ?? metrics.labelTopSpacing),
          AppText(
            text: item.label,
            size:
                isSelected
                    ? (selectedLabelSize ?? metrics.selectedLabelSize)
                    : (unselectedLabelSize ?? metrics.unselectedLabelSize),
            color: itemColor,
            style: labelStyle,
            maxLines: metrics.labelMaxLines,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSingleItemFallback(_AppBottomNavigatorMetrics metrics) {
    final AppBottomNavigatorItem item = items.first;
    final bool isInteractive = item.enabled && onTap != null;

    return InkWell(
      onTap: isInteractive ? () => onTap?.call(0) : null,
      child: Align(
        alignment: Alignment.topCenter,
        child: _buildItemContent(
          item: item,
          isSelected: true,
          metrics: metrics,
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required AppBottomNavigatorItem item,
    required int index,
    required bool isSelected,
    required _AppBottomNavigatorMetrics metrics,
  }) {
    final bool isInteractive = item.enabled && onTap != null;

    return Semantics(
      button: true,
      selected: isSelected,
      enabled: item.enabled,
      label: item.semanticsLabel ?? item.label,
      child: Tooltip(
        message: item.semanticsLabel ?? item.label,
        child: InkWell(
          onTap: isInteractive ? () => onTap?.call(index) : null,
          child: Align(
            alignment: Alignment.topCenter,
            child: _buildItemContent(
              item: item,
              isSelected: isSelected,
              metrics: metrics,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationBar(
    BuildContext context,
    _AppBottomNavigatorMetrics metrics,
  ) {
    if (items.length == 1) {
      return _buildSingleItemFallback(metrics);
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double viewportWidth =
            constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;
        final double minWidth = metrics.itemMinWidth * items.length;
        final bool shouldScroll =
            (viewportWidth / items.length) < metrics.itemMinWidth;

        final Widget navigationBar = SizedBox(
          width:
              shouldScroll ? math.max(viewportWidth, minWidth) : viewportWidth,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int index = 0; index < items.length; index++)
                  shouldScroll
                      ? SizedBox(
                        width: metrics.itemMinWidth,
                        child: _buildNavigationItem(
                          item: items[index],
                          index: index,
                          isSelected: currentIndex == index,
                          metrics: metrics,
                        ),
                      )
                      : Expanded(
                        child: _buildNavigationItem(
                          item: items[index],
                          index: index,
                          isSelected: currentIndex == index,
                          metrics: metrics,
                        ),
                      ),
              ],
            ),
          ),
        );

        if (!shouldScroll) {
          return navigationBar;
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: navigationBar,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _AppBottomNavigatorMetrics metrics =
        _AppBottomNavigatorMetrics.resolve(
          padding: padding,
          height: height,
          iconSize: iconSize,
          itemMinWidth: itemMinWidth,
          labelMaxLines: labelMaxLines,
        );

    final Widget content = Padding(
      padding: metrics.padding,
      child: _buildNavigationBar(context, metrics),
    );

    return Material(
      color: _resolvedBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: AppDivider(
              color: _resolvedBorderColor,
              thickness: metrics.borderThickness,
            ),
          ),
          if (respectBottomSafeArea ?? true)
            SafeArea(top: false, child: content)
          else
            content,
        ],
      ),
    );
  }
}

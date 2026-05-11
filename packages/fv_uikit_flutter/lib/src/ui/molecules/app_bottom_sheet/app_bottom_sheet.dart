import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

part 'app_bottom_sheet_metrics.dart';

class AppBottomSheet extends StatelessWidget {
  final Widget child;
  final String title;
  final String? description;
  final List<Widget>? buttons;
  final AppBottomSheetSize? size;
  final AppBottomSheetActionOrientation? actionOrientation;
  final bool? showDragHandle;
  final bool? showCloseIcon;
  final bool? useSafeArea;
  final Color? backgroundColor;
  final BorderRadiusGeometry? topBorderRadius;
  final AppTextSize? titleTextSize;
  final Color? titleColor;
  final TextStyle? titleStyle;
  final TextAlign? titleTextAlign;
  final Color? descriptionColor;
  final TextStyle? descriptionStyle;
  final Color? dragHandleColor;
  final double? dragHandleWidth;
  final double? dragHandleHeight;
  final double? dragHandleBottomGap;
  final Widget? closeIcon;
  final Color? closeIconColor;
  final double? closeIconSize;
  final double? closeButtonSize;
  final double? closeButtonTopOffset;
  final double? closeButtonRightOffset;
  final VoidCallback? onClose;
  final AppButtonSize? actionButtonSize;
  final double? actionSpacing;
  final TextStyle? actionTextStyle;
  final Color? primaryActionTextColor;
  final Color? secondaryActionTextColor;
  final Color? cancelActionTextColor;
  final AppButtonVariant? primaryActionVariant;
  final AppButtonVariant? secondaryActionVariant;
  final AppButtonVariant? cancelActionVariant;
  final String? titlePrimaryAction;
  final VoidCallback? onPrimaryAction;
  final String? titleSecondaryAction;
  final VoidCallback? onSecondaryAction;
  final String? titleCancelAction;
  final VoidCallback? onCancelAction;

  const AppBottomSheet({
    super.key,
    required this.child,
    required this.title,
    this.description,
    this.buttons,
    this.size = AppBottomSheetSize.medium,
    this.actionOrientation = AppBottomSheetActionOrientation.vertical,
    this.showDragHandle = true,
    this.showCloseIcon = true,
    this.useSafeArea = true,
    this.backgroundColor,
    this.topBorderRadius,
    this.titleTextSize,
    this.titleColor,
    this.titleStyle,
    this.titleTextAlign,
    this.descriptionColor,
    this.descriptionStyle,
    this.dragHandleColor,
    this.dragHandleWidth,
    this.dragHandleHeight,
    this.dragHandleBottomGap,
    this.closeIcon,
    this.closeIconColor,
    this.closeIconSize,
    this.closeButtonSize,
    this.closeButtonTopOffset,
    this.closeButtonRightOffset,
    this.onClose,
    this.actionButtonSize,
    this.actionSpacing,
    this.actionTextStyle,
    this.primaryActionTextColor,
    this.secondaryActionTextColor,
    this.cancelActionTextColor,
    this.primaryActionVariant,
    this.secondaryActionVariant,
    this.cancelActionVariant,
    this.titlePrimaryAction,
    this.onPrimaryAction,
    this.titleSecondaryAction,
    this.onSecondaryAction,
    this.titleCancelAction,
    this.onCancelAction,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required AppBottomSheet Function(BuildContext bottomSheetContext) builder,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useRootNavigator = false,
    bool isScrollControlled = true,
    Color? barrierColor,
    RouteSettings? routeSettings,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useRootNavigator: useRootNavigator,
      isScrollControlled: isScrollControlled,
      barrierColor: barrierColor ?? ColorTokens.bgMask,
      backgroundColor: ColorTokens.transparent,
      elevation: 0,
      routeSettings: routeSettings,
      builder: (bottomSheetContext) {
        final viewInsets = MediaQuery.viewInsetsOf(bottomSheetContext);

        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: viewInsets.bottom),
          child: builder(bottomSheetContext),
        );
      },
    );
  }

  static void close<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }

  AppBottomSheetSize get _resolvedSize => size ?? AppBottomSheetSize.medium;

  AppBottomSheetActionOrientation get _resolvedActionOrientation =>
      actionOrientation ?? AppBottomSheetActionOrientation.vertical;

  bool get _showDragHandle => showDragHandle ?? true;

  bool get _showCloseIcon => showCloseIcon ?? true;

  bool get _useSafeArea => useSafeArea ?? true;

  bool get _hasDescription =>
      description != null && description!.trim().isNotEmpty;

  double _resolvedCloseIconSize(_AppBottomSheetMetrics metrics) =>
      closeIconSize ?? metrics.closeIconSize;

  double _resolvedCloseButtonSize(_AppBottomSheetMetrics metrics) =>
      closeButtonSize ?? metrics.closeButtonSize;

  double _defaultCloseOffset(_AppBottomSheetMetrics metrics) {
    final hitAreaOverflow =
        _resolvedCloseButtonSize(metrics) - _resolvedCloseIconSize(metrics);

    if (hitAreaOverflow <= 0) return 0;
    return -(hitAreaOverflow / 2);
  }

  double _resolvedCloseButtonTopOffset(_AppBottomSheetMetrics metrics) =>
      closeButtonTopOffset ?? _defaultCloseOffset(metrics);

  double _resolvedCloseButtonRightOffset(_AppBottomSheetMetrics metrics) =>
      closeButtonRightOffset ?? _defaultCloseOffset(metrics);

  List<Widget> _buildFooterButtons(_AppBottomSheetMetrics metrics) {
    if (buttons != null && buttons!.isNotEmpty) {
      return buttons!;
    }

    final footerButtons = <Widget>[];
    final buttonSize = actionButtonSize ?? metrics.buttonSize;

    if (titleCancelAction != null) {
      footerButtons.add(
        AppButton(
          text: titleCancelAction!,
          variant: cancelActionVariant ?? AppButtonVariant.fallback,
          size: buttonSize,
          isFullWidth: true,
          textStyle: actionTextStyle,
          textColor: cancelActionTextColor,
          onPressed: onCancelAction,
        ),
      );
    }

    if (titleSecondaryAction != null) {
      footerButtons.add(
        AppButton(
          text: titleSecondaryAction!,
          variant: secondaryActionVariant ?? AppButtonVariant.outline,
          size: buttonSize,
          isFullWidth: true,
          textStyle: actionTextStyle,
          textColor: secondaryActionTextColor,
          onPressed: onSecondaryAction,
        ),
      );
    }

    if (titlePrimaryAction != null) {
      footerButtons.add(
        AppButton(
          text: titlePrimaryAction!,
          variant: primaryActionVariant ?? AppButtonVariant.primary,
          size: buttonSize,
          isFullWidth: true,
          textStyle: actionTextStyle,
          textColor: primaryActionTextColor,
          onPressed: onPrimaryAction,
        ),
      );
    }

    return footerButtons;
  }

  Widget _buildDragHandle(_AppBottomSheetMetrics metrics) {
    final handleHeight = dragHandleHeight ?? metrics.dragHandleHeight;

    return Center(
      child: Container(
        width: dragHandleWidth ?? metrics.dragHandleWidth,
        height: handleHeight,
        decoration: BoxDecoration(
          color: dragHandleColor ?? ColorTokens.borderDefault,
          borderRadius: BorderRadius.circular(handleHeight / 2),
        ),
      ),
    );
  }

  Widget _buildCloseButton(
    BuildContext context,
    _AppBottomSheetMetrics metrics,
  ) {
    return SizedBox.square(
      dimension: _resolvedCloseButtonSize(metrics),
      child: Material(
        color: ColorTokens.transparent,
        child: InkWell(
          onTap: onClose ?? () => Navigator.of(context).maybePop(),
          customBorder: const CircleBorder(),
          child: Center(
            child: IconTheme.merge(
              data: IconThemeData(
                size: _resolvedCloseIconSize(metrics),
                color: closeIconColor ?? ColorTokens.iconDefault,
              ),
              child: closeIcon ?? const Icon(Icons.close),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, _AppBottomSheetMetrics metrics) {
    final closeButtonExtent = _resolvedCloseButtonSize(metrics);
    final closeTitleInset =
        _showCloseIcon ? closeButtonExtent + metrics.headerGap : 0.0;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: closeButtonExtent),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: closeTitleInset),
          child: AppText(
            text: title,
            size: titleTextSize ?? metrics.titleTextSize,
            color: titleColor ?? ColorTokens.textDefault,
            style: titleStyle,
            textAlign: titleTextAlign ?? TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayCloseButton(
    BuildContext context,
    _AppBottomSheetMetrics metrics,
  ) {
    return Positioned(
      top: _resolvedCloseButtonTopOffset(metrics),
      right: _resolvedCloseButtonRightOffset(metrics),
      child: _buildCloseButton(context, metrics),
    );
  }

  Widget _buildVerticalFooter(
    List<Widget> footerButtons,
    _AppBottomSheetMetrics metrics,
  ) {
    final spacing = actionSpacing ?? metrics.footerGap;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < footerButtons.length; index++) ...[
          if (index > 0) SizedBox(height: spacing),
          footerButtons[index],
        ],
      ],
    );
  }

  Widget _buildHorizontalFooter(
    List<Widget> footerButtons,
    _AppBottomSheetMetrics metrics,
  ) {
    final spacing = actionSpacing ?? metrics.footerGap;

    return Row(
      children: [
        for (var index = 0; index < footerButtons.length; index++) ...[
          if (index > 0) SizedBox(width: spacing),
          Expanded(child: footerButtons[index]),
        ],
      ],
    );
  }

  Widget? _buildFooter(
    List<Widget> footerButtons,
    _AppBottomSheetMetrics metrics,
  ) {
    if (footerButtons.isEmpty) return null;

    switch (_resolvedActionOrientation) {
      case AppBottomSheetActionOrientation.horizontal:
        return _buildHorizontalFooter(footerButtons, metrics);
      case AppBottomSheetActionOrientation.vertical:
        return _buildVerticalFooter(footerButtons, metrics);
    }
  }

  Widget _buildDescription(_AppBottomSheetMetrics metrics) {
    return AppText(
      text: description!,
      size: metrics.descriptionTextSize,
      color: descriptionColor ?? ColorTokens.textDescription,
      style: descriptionStyle,
    );
  }

  BorderRadiusGeometry get _resolvedTopBorderRadius =>
      topBorderRadius ??
      const BorderRadius.vertical(top: Radius.circular(RadiusTokens.radiusL));

  Widget _wrapSafeArea(Widget sheet) {
    if (!_useSafeArea) return sheet;

    return SafeArea(top: false, child: sheet);
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _AppBottomSheetMetrics.fromSize(_resolvedSize);
    final footerButtons = _buildFooterButtons(metrics);
    final footer = _buildFooter(footerButtons, metrics);
    final maxHeight =
        MediaQuery.sizeOf(context).height * metrics.maxHeightFactor;

    final sheet = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? ColorTokens.bgElevated,
        borderRadius: _resolvedTopBorderRadius,
        boxShadow: BoxShadowTokens.boxShadowTertiary,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: EdgeInsets.all(metrics.padding),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_showDragHandle) ...[
                    _buildDragHandle(metrics),
                    SizedBox(
                      height:
                          dragHandleBottomGap ?? metrics.dragHandleBottomGap,
                    ),
                  ],
                  _buildHeader(context, metrics),
                  if (_hasDescription) ...[
                    SizedBox(height: metrics.bodyGap),
                    _buildDescription(metrics),
                  ],
                  SizedBox(height: metrics.bodyGap),
                  Flexible(
                    fit: FlexFit.loose,
                    child: ClipRect(child: SingleChildScrollView(child: child)),
                  ),
                  if (footer != null) ...[
                    SizedBox(height: metrics.sectionGap),
                    footer,
                  ],
                ],
              ),
              if (_showCloseIcon) _buildOverlayCloseButton(context, metrics),
            ],
          ),
        ),
      ),
    );

    return _wrapSafeArea(sheet);
  }
}

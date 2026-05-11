import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

part 'app_button_dashed_border_painter.dart';
part 'app_button_metrics.dart';

class AppButton extends StatelessWidget {
  static const double _disabledOpacity = 0.5;

  final AppButtonVariant? variant;
  final AppButtonSize? size;
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final TextStyle? textStyle;
  final double? textFontSize;
  final Color? textColor;
  final Widget? iconLeft;
  final Widget? iconRight;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? spacing;
  final bool? isFullWidth;
  final bool? isLoading;
  final bool? isDisabled;
  final Alignment? alignment;

  const AppButton({
    super.key,
    this.variant = AppButtonVariant.fallback,
    this.size = AppButtonSize.medium,
    required this.text,
    this.onPressed,
    this.iconLeft,
    this.iconRight,
    this.backgroundColor,
    this.borderColor,
    this.style,
    this.textStyle,
    this.textFontSize,
    this.textColor,
    this.spacing,
    this.isFullWidth = false,
    this.isDisabled = false,
    this.isLoading = false,
    this.alignment,
  });

  AppButtonVariant get _resolvedVariant => variant ?? AppButtonVariant.fallback;

  AppButtonSize get _resolvedSize => size ?? AppButtonSize.medium;

  bool get _isFullWidthEnabled => isFullWidth ?? false;

  bool get _isLoadingState => isLoading ?? false;

  bool get _isDisabledState => isDisabled ?? false;

  bool get _isFlatVariant =>
      _resolvedVariant == AppButtonVariant.text ||
      _resolvedVariant == AppButtonVariant.link;

  bool get _isDashedVariant => _resolvedVariant == AppButtonVariant.dash;

  bool get _isInteractionDisabled =>
      _isDisabledState || _isLoadingState || onPressed == null;

  bool get _isVisuallyDisabled => _isDisabledState || onPressed == null;

  VoidCallback? get _effectiveOnPressed =>
      _isInteractionDisabled ? null : onPressed;

  ButtonStyle _buildButtonStyle({
    required Color foregroundColor,
    Color? backgroundColor,
    BorderSide? side,
  }) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
        backgroundColor ?? ColorTokens.transparent,
      ),
      foregroundColor: WidgetStateProperty.all(foregroundColor),
      side: side != null ? WidgetStateProperty.all(side) : null,
    );
  }

  ButtonStyle _buildFlatButtonStyle({required Color foregroundColor}) {
    return _buildButtonStyle(foregroundColor: foregroundColor).copyWith(
      overlayColor: WidgetStateProperty.all(ColorTokens.transparent),
      shadowColor: WidgetStateProperty.all(ColorTokens.transparent),
      surfaceTintColor: WidgetStateProperty.all(ColorTokens.transparent),
      elevation: WidgetStateProperty.all(0),
    );
  }

  ButtonStyle _getVariantButtonStyle() {
    late final ButtonStyle buttonStyle;

    switch (_resolvedVariant) {
      case AppButtonVariant.primary:
        buttonStyle = _buildButtonStyle(
          backgroundColor: ColorTokens.primary,
          foregroundColor: ColorTokens.white,
        );
        break;
      case AppButtonVariant.outline:
        buttonStyle = _buildButtonStyle(
          backgroundColor: ColorTokens.white,
          foregroundColor: ColorTokens.primary,
          side: BorderSide(color: borderColor ?? ColorTokens.borderOutline),
        );
        break;
      case AppButtonVariant.dash:
        buttonStyle = _buildButtonStyle(
          backgroundColor: ColorTokens.white,
          foregroundColor: ColorTokens.textDefault,
          side: BorderSide(color: borderColor ?? ColorTokens.borderDefault),
        );
        break;
      case AppButtonVariant.text:
        buttonStyle = _buildFlatButtonStyle(
          foregroundColor: ColorTokens.textDefault,
        );
        break;
      case AppButtonVariant.link:
        buttonStyle = _buildFlatButtonStyle(
          foregroundColor: ColorTokens.primary,
        );
        break;
      case AppButtonVariant.danger:
        buttonStyle = _buildButtonStyle(
          backgroundColor: ColorTokens.danger,
          foregroundColor: ColorTokens.white,
        );
        break;
      case AppButtonVariant.warning:
        buttonStyle = _buildButtonStyle(
          backgroundColor: ColorTokens.warning,
          foregroundColor: ColorTokens.white,
        );
        break;
      default:
        buttonStyle = _buildButtonStyle(
          backgroundColor: ColorTokens.white,
          foregroundColor: ColorTokens.textDefault,
          side: BorderSide(color: borderColor ?? ColorTokens.borderDefault),
        );
        break;
    }

    return buttonStyle.copyWith(
      backgroundColor:
          backgroundColor != null
              ? WidgetStateProperty.all(backgroundColor)
              : null,
    );
  }

  Set<WidgetState> _getCurrentStates() {
    return {if (_isInteractionDisabled) WidgetState.disabled};
  }

  TextStyle? _getResolvedTextStyle() {
    final buttonTextStyle = style?.textStyle?.resolve(_getCurrentStates());
    final resolvedTextStyle = buttonTextStyle?.merge(textStyle) ?? textStyle;

    if (textFontSize == null && textColor == null) {
      return resolvedTextStyle;
    }

    return (resolvedTextStyle ?? const TextStyle()).copyWith(
      fontSize: textFontSize,
      color: textColor,
    );
  }

  ButtonStyle _getEffectiveButtonStyle(_AppButtonMetrics metrics) {
    final defaultButtonStyle = _getVariantButtonStyle().copyWith(
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: RadiusTokens.radiusMdBorderRadius),
      ),
      padding: WidgetStateProperty.all(
        _isFlatVariant
            ? EdgeInsets.zero
            : EdgeInsets.symmetric(horizontal: metrics.horizontalPadding),
      ),
      minimumSize: WidgetStateProperty.all(
        Size(0, _isFlatVariant ? 0 : metrics.minHeight),
      ),
      iconSize: WidgetStateProperty.all(metrics.iconSize),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    final buttonStyle = style?.merge(defaultButtonStyle) ?? defaultButtonStyle;

    return buttonStyle;
  }

  double _getContentGap(_AppButtonMetrics metrics) {
    return spacing ?? metrics.contentGap;
  }

  bool _hasVisibleBorderColor(Color color) => color.a != 0;

  BorderSide _getResolvedDashBorderSide(ButtonStyle buttonStyle) {
    final resolvedSide = buttonStyle.side?.resolve(_getCurrentStates());

    return BorderSide(
      color:
          borderColor ??
          ((resolvedSide != null && _hasVisibleBorderColor(resolvedSide.color))
              ? resolvedSide.color
              : ColorTokens.borderDefault),
      width: resolvedSide?.width ?? 1,
    );
  }

  BorderRadius _getResolvedDashBorderRadius(
    BuildContext context,
    ButtonStyle buttonStyle,
  ) {
    final resolvedShape = buttonStyle.shape?.resolve(_getCurrentStates());

    if (resolvedShape is RoundedRectangleBorder) {
      return resolvedShape.borderRadius.resolve(Directionality.of(context));
    }

    return RadiusTokens.radiusMdBorderRadius.resolve(
      Directionality.of(context),
    );
  }

  ButtonStyle _getDashButtonStyle(ButtonStyle buttonStyle) {
    final resolvedSide = _getResolvedDashBorderSide(buttonStyle);

    return buttonStyle.copyWith(
      side: WidgetStateProperty.all(
        resolvedSide.copyWith(color: ColorTokens.transparent),
      ),
    );
  }

  Widget _buildIcon(Widget? icon, _AppButtonMetrics metrics) {
    if (icon == null) return const SizedBox.shrink();
    return IconTheme(data: IconThemeData(size: metrics.iconSize), child: icon);
  }

  List<Widget> _buildContentChildren(_AppButtonMetrics metrics) {
    final children = <Widget>[
      if (iconLeft != null) _buildIcon(iconLeft, metrics),
      AppText(
        text: text,
        size: metrics.textVariant,
        style: _getResolvedTextStyle(),
      ),
      if (iconRight != null) _buildIcon(iconRight, metrics),
    ];

    if (children.length <= 1) return children;

    final spacedChildren = <Widget>[];

    for (var index = 0; index < children.length; index++) {
      if (index > 0) {
        spacedChildren.add(SizedBox(width: _getContentGap(metrics)));
      }
      spacedChildren.add(children[index]);
    }

    return spacedChildren;
  }

  Widget _buildContent(_AppButtonMetrics metrics) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: _buildContentChildren(metrics),
    );
  }

  Widget _buildLoadingIndicator(
    ButtonStyle buttonStyle,
    _AppButtonMetrics metrics,
  ) {
    final indicatorColor =
        buttonStyle.foregroundColor?.resolve(_getCurrentStates()) ??
        ColorTokens.primaryDefault;

    return AppLoadingSpinner(
      size: metrics.loadingIndicatorSize,
      strokeWidth: 2,
      color: indicatorColor,
      semanticsLabel: 'Loading',
    );
  }

  Widget _buildButtonChild(ButtonStyle buttonStyle, _AppButtonMetrics metrics) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: _isLoadingState ? 0 : 1,
          child: _buildContent(metrics),
        ),
        if (_isLoadingState) _buildLoadingIndicator(buttonStyle, metrics),
      ],
    );
  }

  Widget _buildBaseButton(ButtonStyle buttonStyle, Widget buttonChild) {
    if (_isFlatVariant) {
      return TextButton(
        onPressed: _effectiveOnPressed,
        style: buttonStyle,
        child: buttonChild,
      );
    }

    return ElevatedButton(
      onPressed: _effectiveOnPressed,
      style: buttonStyle,
      child: buttonChild,
    );
  }

  Widget _wrapDashedBorder(
    BuildContext context,
    Widget button,
    ButtonStyle baseButtonStyle,
    ButtonStyle buttonStyle,
  ) {
    if (!_isDashedVariant) return button;

    final dashBorderSide = _getResolvedDashBorderSide(baseButtonStyle);

    return CustomPaint(
      foregroundPainter: _DashedRoundedRectPainter(
        color: dashBorderSide.color,
        strokeWidth: dashBorderSide.width,
        borderRadius: _getResolvedDashBorderRadius(context, buttonStyle),
      ),
      child: button,
    );
  }

  Widget _wrapButtonWidth(Widget button) {
    if (!_isFullWidthEnabled) {
      return Align(
        alignment: alignment ?? Alignment.centerLeft,
        widthFactor: 1,
        child: button,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedWidth) return button;

        return SizedBox(width: constraints.maxWidth, child: button);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _AppButtonMetrics.fromSize(_resolvedSize);
    final baseButtonStyle = _getEffectiveButtonStyle(metrics);
    final buttonStyle =
        _isDashedVariant
            ? _getDashButtonStyle(baseButtonStyle)
            : baseButtonStyle;
    final buttonChild = _buildButtonChild(buttonStyle, metrics);
    final button = _wrapDashedBorder(
      context,
      _buildBaseButton(buttonStyle, buttonChild),
      baseButtonStyle,
      buttonStyle,
    );

    final buttonWithOpacity =
        _isVisuallyDisabled
            ? Opacity(opacity: _disabledOpacity, child: button)
            : button;

    return _wrapButtonWidth(buttonWithOpacity);
  }
}

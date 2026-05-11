import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

part 'app_radio_metrics.dart';

class AppRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final AppRadioSize? size;
  final AppRadioVariant? variant;
  final String? label;
  final Widget? labelWidget;
  final AppRadioLabelPosition? labelPosition;
  final bool? isDisabled;
  final bool? isReadOnly;
  final Color? activeColor;
  final Color? inactiveBorderColor;
  final Color? disabledBorderColor;
  final Color? disabledFillColor;
  final Color? disabledSelectedColor;
  final Color? labelColor;
  final TextStyle? labelStyle;
  final Color? boxedBackgroundColor;
  final Color? boxedBorderColor;
  final double? spacing;
  final Duration? animationDuration;
  final Curve? animationCurve;

  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.size = AppRadioSize.medium,
    this.variant = AppRadioVariant.standard,
    this.label,
    this.labelWidget,
    this.labelPosition = AppRadioLabelPosition.right,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.activeColor,
    this.inactiveBorderColor,
    this.disabledBorderColor,
    this.disabledFillColor,
    this.disabledSelectedColor,
    this.labelColor,
    this.labelStyle,
    this.boxedBackgroundColor,
    this.boxedBorderColor,
    this.spacing,
    this.animationDuration,
    this.animationCurve,
  });

  static const _defaultAnimationDuration = Duration(milliseconds: 160);
  static const _defaultAnimationCurve = Curves.easeOut;

  AppRadioSize get _resolvedSize => size ?? AppRadioSize.medium;

  AppRadioVariant get _resolvedVariant => variant ?? AppRadioVariant.standard;

  AppRadioLabelPosition get _resolvedLabelPosition =>
      labelPosition ?? AppRadioLabelPosition.right;

  bool get _isSelected => value == groupValue;

  bool get _isDisabledState => isDisabled ?? false;

  bool get _isReadOnlyState => isReadOnly ?? false;

  bool get _isVisuallyDisabled => _isDisabledState || onChanged == null;

  bool get _isInteractive =>
      !_isDisabledState && !_isReadOnlyState && onChanged != null;

  bool get _isBoxedVariant => _resolvedVariant == AppRadioVariant.boxed;

  Duration get _duration => animationDuration ?? _defaultAnimationDuration;

  Curve get _curve => animationCurve ?? _defaultAnimationCurve;

  Color _resolveOuterColor() {
    if (_isVisuallyDisabled) {
      return disabledFillColor ?? ColorTokens.fillTertiary;
    }

    return ColorTokens.white;
  }

  Color _resolveBorderColor() {
    if (_isVisuallyDisabled) {
      return disabledBorderColor ?? ColorTokens.borderDefault;
    }

    return _isSelected
        ? activeColor ?? ColorTokens.primary
        : inactiveBorderColor ?? ColorTokens.borderDefault;
  }

  Color _resolveInnerColor() {
    if (!_isSelected) return ColorTokens.transparent;

    if (_isVisuallyDisabled) {
      return disabledSelectedColor ?? ColorTokens.gray;
    }

    return activeColor ?? ColorTokens.primary;
  }

  Color _resolveLabelColor() {
    if (labelColor != null) return labelColor!;
    if (_isVisuallyDisabled) return ColorTokens.textDisabled;
    return ColorTokens.textDefault;
  }

  Widget _buildControl(_AppRadioMetrics metrics) {
    return AnimatedContainer(
      duration: _duration,
      curve: _curve,
      width: metrics.controlSize,
      height: metrics.controlSize,
      decoration: BoxDecoration(
        color: _resolveOuterColor(),
        shape: BoxShape.circle,
        border: Border.all(
          color: _resolveBorderColor(),
          width: metrics.controlBorderWidth,
        ),
      ),
      alignment: Alignment.center,
      child: AnimatedContainer(
        duration: _duration,
        curve: _curve,
        width: _isSelected ? metrics.innerDotSize : 0,
        height: _isSelected ? metrics.innerDotSize : 0,
        decoration: BoxDecoration(
          color: _resolveInnerColor(),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget? _buildLabel(_AppRadioMetrics metrics) {
    if (labelWidget != null) return labelWidget;
    if (label?.isNotEmpty != true) return null;

    return AppText(
      text: label!,
      size: metrics.textVariant,
      color: _resolveLabelColor(),
      style: labelStyle,
    );
  }

  List<Widget> _buildChildren(_AppRadioMetrics metrics) {
    final control = _buildControl(metrics);
    final labelContent = _buildLabel(metrics);

    if (labelContent == null) return [control];

    final gap = SizedBox(width: spacing ?? metrics.contentGap);

    if (_resolvedLabelPosition == AppRadioLabelPosition.left) {
      return [labelContent, gap, control];
    }

    return [control, gap, labelContent];
  }

  Widget _wrapBoxedVariant(Widget child, _AppRadioMetrics metrics) {
    if (!_isBoxedVariant) return child;

    return Container(
      constraints: BoxConstraints(minHeight: metrics.boxMinHeight),
      padding: EdgeInsets.symmetric(
        horizontal: metrics.boxHorizontalPadding,
        vertical: metrics.boxVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: boxedBackgroundColor ?? ColorTokens.white,
        borderRadius: RadiusTokens.radiusSmBorderRadius,
        border: Border.all(
          color: boxedBorderColor ?? ColorTokens.borderDefault,
        ),
      ),
      child: child,
    );
  }

  void _handleTap() {
    if (!_isInteractive) return;
    onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _AppRadioMetrics.fromSize(_resolvedSize);
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _buildChildren(metrics),
    );

    return Semantics(
      checked: _isSelected,
      enabled: _isInteractive,
      button: true,
      inMutuallyExclusiveGroup: true,
      label: label,
      child: MouseRegion(
        cursor:
            _isInteractive
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _isInteractive ? _handleTap : null,
          child: _wrapBoxedVariant(content, metrics),
        ),
      ),
    );
  }
}

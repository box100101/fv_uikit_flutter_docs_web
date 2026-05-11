import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

part 'app_checkbox_metrics.dart';

class AppCheckbox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final AppCheckboxSize? size;
  final AppCheckboxVariant? variant;
  final String? label;
  final Widget? labelWidget;
  final AppCheckboxLabelPosition? labelPosition;
  final bool? tristate;
  final bool? isDisabled;
  final bool? isReadOnly;
  final Color? activeColor;
  final Color? inactiveBackgroundColor;
  final Color? inactiveBorderColor;
  final Color? disabledBackgroundColor;
  final Color? disabledBorderColor;
  final Color? disabledSelectedColor;
  final Color? checkColor;
  final Color? labelColor;
  final TextStyle? labelStyle;
  final Color? boxedBackgroundColor;
  final Color? boxedBorderColor;
  final double? spacing;
  final Duration? animationDuration;
  final Curve? animationCurve;

  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.size = AppCheckboxSize.medium,
    this.variant = AppCheckboxVariant.standard,
    this.label,
    this.labelWidget,
    this.labelPosition = AppCheckboxLabelPosition.right,
    this.tristate = false,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.activeColor,
    this.inactiveBackgroundColor,
    this.inactiveBorderColor,
    this.disabledBackgroundColor,
    this.disabledBorderColor,
    this.disabledSelectedColor,
    this.checkColor,
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

  AppCheckboxSize get _resolvedSize => size ?? AppCheckboxSize.medium;

  AppCheckboxVariant get _resolvedVariant =>
      variant ?? AppCheckboxVariant.standard;

  AppCheckboxLabelPosition get _resolvedLabelPosition =>
      labelPosition ?? AppCheckboxLabelPosition.right;

  bool get _isChecked => value == true;

  bool get _isIndeterminate => value == null;

  bool get _isSelected => _isChecked || _isIndeterminate;

  bool get _isTristate => tristate ?? false;

  bool get _isDisabledState => isDisabled ?? false;

  bool get _isReadOnlyState => isReadOnly ?? false;

  bool get _isVisuallyDisabled => _isDisabledState || onChanged == null;

  bool get _isInteractive =>
      !_isDisabledState && !_isReadOnlyState && onChanged != null;

  bool get _isBoxedVariant => _resolvedVariant == AppCheckboxVariant.boxed;

  bool get _isSelectboxVariant =>
      _resolvedVariant == AppCheckboxVariant.selectbox;

  Duration get _duration => animationDuration ?? _defaultAnimationDuration;

  Curve get _curve => animationCurve ?? _defaultAnimationCurve;

  Color _resolveControlColor() {
    if (_isVisuallyDisabled) {
      if (_isSelected) {
        return disabledSelectedColor ?? ColorTokens.fill;
      }

      return disabledBackgroundColor ?? ColorTokens.fillTertiary;
    }

    if (_isSelected) return activeColor ?? ColorTokens.primary;

    return inactiveBackgroundColor ?? ColorTokens.white;
  }

  Color _resolveControlBorderColor() {
    if (_isVisuallyDisabled) {
      return disabledBorderColor ?? ColorTokens.borderDefault;
    }

    if (_isSelected) return activeColor ?? ColorTokens.primary;

    return inactiveBorderColor ?? ColorTokens.borderDefault;
  }

  Color _resolveMarkColor() {
    if (_isVisuallyDisabled) {
      return ColorTokens.textDisabled;
    }

    return checkColor ?? ColorTokens.white;
  }

  Color _resolveLabelColor() {
    if (labelColor != null) return labelColor!;
    if (_isVisuallyDisabled) return ColorTokens.textDisabled;
    return ColorTokens.textDefault;
  }

  Widget _buildCheckMark(_AppCheckboxMetrics metrics) {
    if (!_isSelected) return const SizedBox.shrink();

    return Icon(
      _isIndeterminate ? Icons.remove : Icons.check,
      size: metrics.markSize,
      color: _resolveMarkColor(),
    );
  }

  Widget _buildControl(_AppCheckboxMetrics metrics) {
    return AnimatedContainer(
      duration: _duration,
      curve: _curve,
      width: metrics.controlSize,
      height: metrics.controlSize,
      decoration: BoxDecoration(
        color: _resolveControlColor(),
        borderRadius: BorderRadius.circular(metrics.controlRadius),
        border: Border.all(
          color: _resolveControlBorderColor(),
          width: metrics.controlBorderWidth,
        ),
      ),
      alignment: Alignment.center,
      child: _buildCheckMark(metrics),
    );
  }

  Widget? _buildLabel(_AppCheckboxMetrics metrics) {
    if (labelWidget != null) return labelWidget;
    if (label?.isNotEmpty != true) return null;

    return AppText(
      text: label!,
      size: metrics.textVariant,
      color: _resolveLabelColor(),
      style: labelStyle,
    );
  }

  List<Widget> _buildStandardChildren(_AppCheckboxMetrics metrics) {
    final control = _buildControl(metrics);
    final labelContent = _buildLabel(metrics);

    if (labelContent == null) return [control];

    final gap = SizedBox(width: spacing ?? metrics.contentGap);

    if (_resolvedLabelPosition == AppCheckboxLabelPosition.left) {
      return [labelContent, gap, control];
    }

    return [control, gap, labelContent];
  }

  Widget _buildStandardContent(_AppCheckboxMetrics metrics) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _buildStandardChildren(metrics),
    );
  }

  Widget _buildSelectboxCheck(_AppCheckboxMetrics metrics) {
    if (!_isSelected) return const SizedBox.shrink();

    return Positioned(
      top: 0,
      right: 0,
      child: AnimatedContainer(
        duration: _duration,
        curve: _curve,
        width: metrics.selectboxCornerSize,
        height: metrics.selectboxCornerSize,
        decoration: BoxDecoration(
          color: _resolveControlColor(),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(metrics.boxRadius),
            bottomLeft: Radius.circular(metrics.selectboxCornerRadius),
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          _isIndeterminate ? Icons.remove : Icons.check,
          size: metrics.selectboxMarkSize,
          color: _resolveMarkColor(),
        ),
      ),
    );
  }

  Widget _buildSelectboxContent(_AppCheckboxMetrics metrics) {
    final labelContent = _buildLabel(metrics) ?? const SizedBox.shrink();
    final rightPadding =
        metrics.boxHorizontalPadding +
        (_isSelected ? metrics.selectboxCornerSize : 0);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          constraints: BoxConstraints(minHeight: metrics.boxMinHeight),
          padding: EdgeInsets.only(
            left: metrics.boxHorizontalPadding,
            top: metrics.boxVerticalPadding,
            right: rightPadding,
            bottom: metrics.boxVerticalPadding,
          ),
          decoration: BoxDecoration(
            color: boxedBackgroundColor ?? ColorTokens.white,
            borderRadius: BorderRadius.circular(metrics.boxRadius),
            border: Border.all(
              color: boxedBorderColor ?? ColorTokens.borderDefault,
            ),
          ),
          child: labelContent,
        ),
        _buildSelectboxCheck(metrics),
      ],
    );
  }

  Widget _wrapBoxedVariant(Widget child, _AppCheckboxMetrics metrics) {
    if (!_isBoxedVariant) return child;

    return Container(
      constraints: BoxConstraints(minHeight: metrics.boxMinHeight),
      padding: EdgeInsets.symmetric(
        horizontal: metrics.boxHorizontalPadding,
        vertical: metrics.boxVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: boxedBackgroundColor ?? ColorTokens.white,
        borderRadius: BorderRadius.circular(metrics.boxRadius),
        border: Border.all(
          color: boxedBorderColor ?? ColorTokens.borderDefault,
        ),
      ),
      child: child,
    );
  }

  bool? _nextValue() {
    if (!_isTristate) return value != true;
    if (value == false) return true;
    if (value == true) return null;
    return false;
  }

  void _handleTap() {
    if (!_isInteractive) return;
    onChanged?.call(_nextValue());
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _AppCheckboxMetrics.fromSize(_resolvedSize);
    final content =
        _isSelectboxVariant
            ? _buildSelectboxContent(metrics)
            : _wrapBoxedVariant(_buildStandardContent(metrics), metrics);

    return Semantics(
      checked: _isChecked,
      enabled: _isInteractive,
      button: true,
      label: label,
      child: MouseRegion(
        cursor:
            _isInteractive
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _isInteractive ? _handleTap : null,
          child: content,
        ),
      ),
    );
  }
}

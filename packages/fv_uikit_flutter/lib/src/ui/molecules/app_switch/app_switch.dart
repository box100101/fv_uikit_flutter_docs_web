import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

part 'app_switch_metrics.dart';

class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final AppSwitchSize? size;
  final String? label;
  final Widget? labelWidget;
  final AppSwitchLabelPosition? labelPosition;
  final bool? isDisabled;
  final bool? isReadOnly;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? disabledActiveTrackColor;
  final Color? disabledInactiveTrackColor;
  final Color? activeThumbColor;
  final Color? inactiveThumbColor;
  final Color? disabledThumbColor;
  final Color? labelColor;
  final TextStyle? labelStyle;
  final double? spacing;
  final Duration? animationDuration;
  final Curve? animationCurve;

  const AppSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.size = AppSwitchSize.medium,
    this.label,
    this.labelWidget,
    this.labelPosition = AppSwitchLabelPosition.right,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.disabledActiveTrackColor,
    this.disabledInactiveTrackColor,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.disabledThumbColor,
    this.labelColor,
    this.labelStyle,
    this.spacing,
    this.animationDuration,
    this.animationCurve,
  });

  static const _defaultAnimationDuration = Duration(milliseconds: 180);
  static const _defaultAnimationCurve = Curves.easeOut;

  AppSwitchSize get _resolvedSize => size ?? AppSwitchSize.medium;

  AppSwitchLabelPosition get _resolvedLabelPosition =>
      labelPosition ?? AppSwitchLabelPosition.right;

  bool get _isDisabledState => isDisabled ?? false;

  bool get _isReadOnlyState => isReadOnly ?? false;

  bool get _isVisuallyDisabled => _isDisabledState || onChanged == null;

  bool get _isInteractive =>
      !_isDisabledState && !_isReadOnlyState && onChanged != null;

  Duration get _duration => animationDuration ?? _defaultAnimationDuration;

  Curve get _curve => animationCurve ?? _defaultAnimationCurve;

  Color _resolveTrackColor() {
    if (_isVisuallyDisabled) {
      if (value) {
        return disabledActiveTrackColor ?? ColorTokens.borderOutline;
      }

      return disabledInactiveTrackColor ?? ColorTokens.fillSecondary;
    }

    return value
        ? activeTrackColor ?? ColorTokens.primary
        : inactiveTrackColor ?? ColorTokens.fill;
  }

  Color _resolveThumbColor() {
    if (_isVisuallyDisabled) {
      return disabledThumbColor ?? ColorTokens.white;
    }

    return value
        ? activeThumbColor ?? ColorTokens.white
        : inactiveThumbColor ?? ColorTokens.white;
  }

  Color _resolveLabelColor() {
    if (labelColor != null) return labelColor!;
    if (_isVisuallyDisabled) return ColorTokens.textDisabled;
    return ColorTokens.textDefault;
  }

  Widget _buildControl(_AppSwitchMetrics metrics) {
    return AnimatedContainer(
      duration: _duration,
      curve: _curve,
      width: metrics.trackWidth,
      height: metrics.trackHeight,
      padding: EdgeInsets.all(metrics.thumbInset),
      decoration: BoxDecoration(
        color: _resolveTrackColor(),
        borderRadius: BorderRadius.circular(metrics.trackHeight / 2),
      ),
      child: AnimatedAlign(
        duration: _duration,
        curve: _curve,
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: metrics.thumbSize,
          height: metrics.thumbSize,
          decoration: BoxDecoration(
            color: _resolveThumbColor(),
            shape: BoxShape.circle,
            boxShadow:
                _isVisuallyDisabled
                    ? null
                    : [
                      BoxShadow(
                        color: ColorTokens.black.withAlpha(31),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
          ),
        ),
      ),
    );
  }

  Widget? _buildLabel(_AppSwitchMetrics metrics) {
    if (labelWidget != null) return labelWidget;
    if (label?.isNotEmpty != true) return null;

    return AppText(
      text: label!,
      size: metrics.textVariant,
      color: _resolveLabelColor(),
      style: labelStyle,
    );
  }

  List<Widget> _buildChildren(_AppSwitchMetrics metrics) {
    final control = _buildControl(metrics);
    final labelContent = _buildLabel(metrics);

    if (labelContent == null) return [control];

    final gap = SizedBox(width: spacing ?? metrics.contentGap);

    if (_resolvedLabelPosition == AppSwitchLabelPosition.left) {
      return [labelContent, gap, control];
    }

    return [control, gap, labelContent];
  }

  void _handleTap() {
    if (!_isInteractive) return;
    onChanged?.call(!value);
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _AppSwitchMetrics.fromSize(_resolvedSize);

    return Semantics(
      toggled: value,
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _buildChildren(metrics),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';
import '../../atoms/app_text_style_resolver.dart';

part 'app_stepper_metrics.dart';

/// A stepper widget: [−] [value] [+]
///
/// - [value]: current quantity (must be >= [min]).
/// - [min]: minimum allowed value, defaults to 0.
/// - [max]: maximum allowed value, null means unlimited.
/// - [step]: amount to increment/decrement per tap, defaults to 1.
/// - [allowKeyboardInput]: if true (default), the center value field is
///   editable from the keyboard. If false, it is read-only and tapping it
///   does nothing.
/// - [size]: visual size variant.
/// - [onChanged]: called with the new value whenever it changes.
class AppStepper extends StatefulWidget {
  final int value;
  final int min;
  final int? max;
  final int step;
  final bool allowKeyboardInput;
  final AppStepperSize size;
  final ValueChanged<int>? onChanged;

  const AppStepper({
    super.key,
    required this.value,
    this.min = 0,
    this.max,
    this.step = 1,
    this.allowKeyboardInput = true,
    this.size = AppStepperSize.medium,
    this.onChanged,
  }) : assert(step > 0, 'step must be > 0');

  @override
  State<AppStepper> createState() => _AppStepperState();
}

class _AppStepperState extends State<AppStepper> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.value}');
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(AppStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      final newText = '${widget.value}';
      if (_controller.text != newText) {
        _controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    // When the user leaves the field, clamp and commit the value.
    if (!_focusNode.hasFocus) {
      _commitText(_controller.text);
    }
  }

  void _commitText(String raw) {
    final parsed = int.tryParse(raw.trim());
    if (parsed == null) {
      // Restore previous valid value.
      _controller.text = '${widget.value}';
      return;
    }
    _emit(_clamp(parsed));
  }

  int _clamp(int v) {
    if (v < widget.min) return widget.min;
    if (widget.max != null && v > widget.max!) return widget.max!;
    return v;
  }

  void _emit(int newValue) {
    if (newValue == widget.value) {
      // Sync display even if value unchanged (handles out-of-range input).
      _controller.text = '$newValue';
      return;
    }
    widget.onChanged?.call(newValue);
  }

  void _decrement() {
    final next = _clamp(widget.value - widget.step);
    _emit(next);
  }

  void _increment() {
    final next = _clamp(widget.value + widget.step);
    _emit(next);
  }

  bool get _canDecrement => widget.value > widget.min;
  bool get _canIncrement =>
      widget.max == null || widget.value < widget.max!;

  @override
  Widget build(BuildContext context) {
    final metrics = _AppStepperMetrics.fromSize(widget.size);
    final radius = BorderRadius.circular(metrics.borderRadius);
    final isDisabled = widget.onChanged == null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(
          icon: Icons.remove,
          size: metrics.buttonSize,
          iconSize: metrics.iconSize,
          borderRadius: radius,
          enabled: !isDisabled && _canDecrement,
          onTap: _decrement,
        ),
        _ValueField(
          controller: _controller,
          focusNode: _focusNode,
          width: metrics.inputWidth,
          height: metrics.buttonSize,
          textSize: metrics.textSize,
          borderRadius: radius,
          allowKeyboardInput: widget.allowKeyboardInput && !isDisabled,
          onSubmitted: _commitText,
        ),
        _StepButton(
          icon: Icons.add,
          size: metrics.buttonSize,
          iconSize: metrics.iconSize,
          borderRadius: radius,
          enabled: !isDisabled && _canIncrement,
          onTap: _increment,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Internal widgets
// ---------------------------------------------------------------------------

class _StepButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final BorderRadius borderRadius;
  final bool enabled;
  final VoidCallback onTap;

  const _StepButton({
    required this.icon,
    required this.size,
    required this.iconSize,
    required this.borderRadius,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: ColorTokens.fillTertiary,
          borderRadius: borderRadius,
          border: Border.all(color: ColorTokens.borderSecondary),
        ),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: borderRadius,
          child: Center(
            child: Icon(
              icon,
              size: iconSize,
              color: enabled
                  ? ColorTokens.textDefault
                  : ColorTokens.textPlaceholder,
            ),
          ),
        ),
      ),
    );
  }
}

class _ValueField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final double width;
  final double height;
  final AppTextSize textSize;
  final BorderRadius borderRadius;
  final bool allowKeyboardInput;
  final ValueChanged<String> onSubmitted;

  const _ValueField({
    required this.controller,
    required this.focusNode,
    required this.width,
    required this.height,
    required this.textSize,
    required this.borderRadius,
    required this.allowKeyboardInput,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = buildAppTextStyle(
      size: textSize,
      color: ColorTokens.textDefault,
    );

    if (!allowKeyboardInput) {
      return SizedBox(
        width: width,
        height: height,
        child: Center(
          child: AppText(
            text: controller.text,
            size: textSize,
            color: ColorTokens.textDefault,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: textStyle,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          onSubmitted: onSubmitted,
        ),
      ),
    );
  }
}

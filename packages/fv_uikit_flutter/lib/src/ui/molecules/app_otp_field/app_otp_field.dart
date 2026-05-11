import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

class AppOtpField extends StatefulWidget {
  final int length;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool autofocus;
  final bool isDisabled;
  final double cellWidth;
  final double cellHeight;
  final double cellSpacing;
  final BorderRadiusGeometry? borderRadius;

  const AppOtpField({
    super.key,
    this.length = 6,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onCompleted,
    this.autofocus = false,
    this.isDisabled = false,
    this.cellWidth = 48,
    this.cellHeight = 56,
    this.cellSpacing = SpacingTokens.spaceM,
    this.borderRadius = RadiusTokens.radiusLgBorderRadius,
  }) : assert(length > 0, 'OTP length must be greater than zero.');

  @override
  State<AppOtpField> createState() => _AppOtpFieldState();
}

class _AppOtpFieldState extends State<AppOtpField> {
  TextEditingController? _internalController;
  FocusNode? _internalFocusNode;
  bool _isApplyingSanitizedValue = false;
  String _lastPublishedValue = '';

  TextEditingController get _controller =>
      widget.controller ?? (_internalController ??= TextEditingController());

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleControllerChanged);
    _initializeControllerState();
  }

  @override
  void didUpdateWidget(covariant AppOtpField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncController(oldWidget);
    _syncFocusNode(oldWidget);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _internalController?.dispose();
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final focusNode = _focusNode;

    return AnimatedBuilder(
      animation: Listenable.merge([controller, focusNode]),
      builder: (context, _) {
        final value = _sanitize(controller.text);
        final activeIndex =
            focusNode.hasFocus ? math.min(value.length, widget.length - 1) : -1;

        return GestureDetector(
          key: const ValueKey('app-otp-field-tap-target'),
          behavior: HitTestBehavior.translucent,
          onTap: _handleTap,
          child: Semantics(
            textField: true,
            enabled: !widget.isDisabled,
            label: 'OTP input',
            value: value,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final resolvedCellWidth = _resolveCellWidth(constraints);

                return Stack(
                  children: [
                    _buildHiddenInput(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(widget.length, (index) {
                        final cell = _OtpDigitCell(
                          key: ValueKey('app-otp-field-cell-$index'),
                          value: index < value.length ? value[index] : '',
                          isFocused: index == activeIndex,
                          isFilled: index < value.length,
                          isDisabled: widget.isDisabled,
                          width: resolvedCellWidth,
                          height: widget.cellHeight,
                          borderRadius: widget.borderRadius!,
                        );

                        if (index == widget.length - 1) {
                          return cell;
                        }

                        return Padding(
                          padding: EdgeInsets.only(right: widget.cellSpacing),
                          child: cell,
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildHiddenInput() {
    return IgnorePointer(
      child: SizedBox(
        width: 1,
        height: 1,
        child: Opacity(
          opacity: 0,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            enabled: !widget.isDisabled,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            autofillHints: const <String>[AutofillHints.oneTimeCode],
            enableSuggestions: false,
            autocorrect: false,
            showCursor: false,
            enableInteractiveSelection: false,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(widget.length),
            ],
            style: const TextStyle(
              color: Colors.transparent,
              fontSize: 0.1,
              height: 0.1,
            ),
            decoration: const InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              counterText: '',
            ),
          ),
        ),
      ),
    );
  }

  double _resolveCellWidth(BoxConstraints constraints) {
    if (!constraints.hasBoundedWidth) {
      return widget.cellWidth;
    }

    final totalSpacing = widget.cellSpacing * (widget.length - 1);
    final availableWidth = math.max(0, constraints.maxWidth - totalSpacing);
    final adaptiveWidth = availableWidth / widget.length;

    return math.min(widget.cellWidth, adaptiveWidth);
  }

  void _initializeControllerState() {
    final sanitizedValue = _sanitize(_controller.text);
    _lastPublishedValue = sanitizedValue;

    if (sanitizedValue == _controller.text) return;

    _setControllerValue(sanitizedValue);
  }

  void _syncController(AppOtpField oldWidget) {
    if (oldWidget.controller == widget.controller) return;

    final previousController = oldWidget.controller ?? _internalController;
    previousController?.removeListener(_handleControllerChanged);

    if (widget.controller == null) {
      _internalController = TextEditingController.fromValue(
        oldWidget.controller?.value ?? TextEditingValue.empty,
      );
    } else {
      _internalController?.dispose();
      _internalController = null;
    }

    _controller.addListener(_handleControllerChanged);
    _initializeControllerState();
  }

  void _syncFocusNode(AppOtpField oldWidget) {
    if (oldWidget.focusNode == widget.focusNode) return;

    if (widget.focusNode == null) {
      _internalFocusNode ??= FocusNode();
      return;
    }

    _internalFocusNode?.dispose();
    _internalFocusNode = null;
  }

  void _handleControllerChanged() {
    if (_isApplyingSanitizedValue) return;

    final sanitizedValue = _sanitize(_controller.text);

    if (sanitizedValue != _controller.text) {
      _setControllerValue(sanitizedValue);
    }

    _publishValueIfNeeded(sanitizedValue);
  }

  void _publishValueIfNeeded(String value) {
    if (value == _lastPublishedValue) return;

    _lastPublishedValue = value;
    widget.onChanged?.call(value);

    if (value.length == widget.length) {
      widget.onCompleted?.call(value);
    }
  }

  void _setControllerValue(String value) {
    _isApplyingSanitizedValue = true;
    _controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    _isApplyingSanitizedValue = false;
  }

  void _handleTap() {
    if (widget.isDisabled) return;

    _focusNode.requestFocus();
    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length,
    );
  }

  String _sanitize(String rawValue) {
    final digitsOnly = rawValue.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length <= widget.length) {
      return digitsOnly;
    }

    return digitsOnly.substring(0, widget.length);
  }
}

class _OtpDigitCell extends StatelessWidget {
  final String value;
  final bool isFocused;
  final bool isFilled;
  final bool isDisabled;
  final double width;
  final double height;
  final BorderRadiusGeometry borderRadius;

  const _OtpDigitCell({
    super.key,
    required this.value,
    required this.isFocused,
    required this.isFilled,
    required this.isDisabled,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isDisabled
            ? ColorTokens.borderSecondary
            : isFocused
            ? ColorTokens.primaryDefault
            : isFilled
            ? ColorTokens.gray300
            : ColorTokens.border;

    final backgroundColor =
        isDisabled ? ColorTokens.bgContainerDisabled : ColorTokens.white;

    final textColor =
        isDisabled ? ColorTokens.textDisabled : ColorTokens.textDefault;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor),
      ),
      child: AppText(
        text: value,
        size: AppTextSize.heading4Medium,
        color: textColor,
        textAlign: TextAlign.center,
      ),
    );
  }
}

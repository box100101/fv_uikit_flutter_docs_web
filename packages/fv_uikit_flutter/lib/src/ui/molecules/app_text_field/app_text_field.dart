import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

part 'app_text_field_config.dart';
part 'app_text_field_layout.dart';

class AppTextField extends StatefulWidget {
  final AppTextFieldVariant variant;
  final bool? isRounded;
  final AppTextFieldSize size;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final AppTextSize? helperTextSize;
  final AppTextSize? errorTextSize;
  final bool? isPassword;
  final bool? isReadOnly;
  final bool? isDisabled;
  final bool? showCursor;
  final bool? isError;
  final bool? isSuccess;
  final bool? isWarning;
  final bool? isInfo;
  final bool? isRequired;
  final bool? isOptional;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? clearTextIcon;
  final Widget? prefix;
  final Widget? suffix;
  final bool showClearTextAction;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final String? Function(String value)? validate;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final int? maxLength;

  const AppTextField({
    super.key,
    this.variant = AppTextFieldVariant.primary,
    this.isRounded,
    this.size = AppTextFieldSize.medium,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.helperTextSize,
    this.errorTextSize,
    this.isPassword,
    this.isReadOnly,
    this.isDisabled,
    this.showCursor,
    this.isError,
    this.isSuccess,
    this.isWarning,
    this.isInfo,
    this.isRequired,
    this.isOptional,
    this.prefixIcon,
    this.suffixIcon,
    this.clearTextIcon,
    this.prefix,
    this.suffix,
    this.showClearTextAction = true,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onTap,
    this.validate,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
    this.maxLength,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  TextEditingController? _internalController;
  FocusNode? _internalFocusNode;
  String? _validationErrorText;

  TextEditingController get _controller =>
      widget.controller ?? (_internalController ??= TextEditingController());

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _validationErrorText = widget.validate?.call(_controller.text);
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncController(oldWidget);
    _syncFocusNode(oldWidget);
    if (oldWidget.validate != widget.validate ||
        oldWidget.controller != widget.controller) {
      _validate(_controller.text);
    }
  }

  @override
  void dispose() {
    _internalController?.dispose();
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _syncController(AppTextField oldWidget) {
    if (oldWidget.controller == widget.controller) return;

    if (widget.controller == null) {
      _internalController ??= TextEditingController.fromValue(
        oldWidget.controller?.value,
      );
      return;
    }

    _internalController?.dispose();
    _internalController = null;
  }

  void _syncFocusNode(AppTextField oldWidget) {
    if (oldWidget.focusNode == widget.focusNode) return;

    if (widget.focusNode == null) {
      _internalFocusNode ??= FocusNode();
      return;
    }

    _internalFocusNode?.dispose();
    _internalFocusNode = null;
  }

  String? get _effectiveErrorText =>
      widget.errorText?.isNotEmpty == true
          ? widget.errorText
          : _validationErrorText;

  void _validate(String value) {
    final errorText = widget.validate?.call(value);
    if (errorText == _validationErrorText) return;

    setState(() {
      _validationErrorText = errorText;
    });
  }

  void _handleChanged(String value) {
    _validate(value);
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final focusNode = _focusNode;
    final metrics = _AppTextFieldMetrics.fromSize(widget.size);

    return AnimatedBuilder(
      animation: Listenable.merge([controller, focusNode]),
      builder: (context, _) {
        final state = _AppTextFieldStateData.resolve(
          widget: widget,
          controller: controller,
          focusNode: focusNode,
          errorText: _effectiveErrorText,
        );
        final palette = _AppTextFieldPalette.resolve(state);

        return _AppTextFieldLayout(
          field: widget,
          controller: controller,
          focusNode: focusNode,
          metrics: metrics,
          palette: palette,
          state: state,
          onChanged: _handleChanged,
        );
      },
    );
  }
}

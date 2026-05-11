import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

class AppPasswordField extends StatefulWidget {
  final AppTextFieldVariant variant;
  final bool? isRounded;
  final AppTextFieldSize size;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final AppTextSize? errorTextSize;
  final bool isReadOnly;
  final bool isDisabled;
  final bool isError;
  final bool isSuccess;
  final bool isWarning;
  final bool isRequired;
  final bool isOptional;
  final bool autofocus;
  final bool showVisibilityToggle;
  final bool showClearTextAction;
  final bool initiallyObscured;
  final Widget? prefixIcon;
  final Widget? visibleIcon;
  final Widget? obscuredIcon;
  final Widget? clearTextIcon;
  final Widget? prefix;
  final Widget? suffix;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? onVisibilityChanged;
  final VoidCallback? onTap;
  final String? Function(String value)? validate;
  final TextInputAction? textInputAction;
  final int? maxLength;

  const AppPasswordField({
    super.key,
    this.variant = AppTextFieldVariant.primary,
    this.isRounded,
    this.size = AppTextFieldSize.medium,
    this.hintText = 'Nhập mật khẩu',
    this.labelText,
    this.helperText,
    this.errorText,
    this.errorTextSize,
    this.isReadOnly = false,
    this.isDisabled = false,
    this.isError = false,
    this.isSuccess = false,
    this.isWarning = false,
    this.isRequired = false,
    this.isOptional = false,
    this.autofocus = false,
    this.showVisibilityToggle = true,
    this.showClearTextAction = false,
    this.initiallyObscured = true,
    this.prefixIcon,
    this.visibleIcon,
    this.obscuredIcon,
    this.clearTextIcon,
    this.prefix,
    this.suffix,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onVisibilityChanged,
    this.onTap,
    this.validate,
    this.textInputAction,
    this.maxLength,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  late bool _obscureText = widget.initiallyObscured;

  @override
  void didUpdateWidget(covariant AppPasswordField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyObscured != widget.initiallyObscured) {
      _obscureText = widget.initiallyObscured;
    }
  }

  void _toggleVisibility() {
    if (widget.isDisabled) return;

    setState(() {
      _obscureText = !_obscureText;
    });

    widget.onVisibilityChanged?.call(!_obscureText);
  }

  double get _toggleIconSize {
    switch (widget.size) {
      case AppTextFieldSize.xSmall:
      case AppTextFieldSize.small:
        return 16;
      case AppTextFieldSize.medium:
      case AppTextFieldSize.large:
        return 20;
      case AppTextFieldSize.xLarge:
        return 24;
    }
  }

  Widget? get _effectivePrefixIcon {
    if (widget.prefixIcon != null || widget.prefix != null) {
      return widget.prefixIcon;
    }

    return const Icon(Icons.lock_outline_rounded);
  }

  Widget? _buildSuffix() {
    if (widget.suffix == null && !widget.showVisibilityToggle) {
      return null;
    }

    final trailingChildren = <Widget>[];

    if (widget.suffix != null) {
      trailingChildren.add(widget.suffix!);
    }

    if (widget.showVisibilityToggle) {
      if (trailingChildren.isNotEmpty) {
        trailingChildren.add(const SizedBox(width: SpacingTokens.spaceXS));
      }

      trailingChildren.add(
        SizedBox.square(
          dimension: _toggleIconSize,
          child: IconButton(
            onPressed: widget.isDisabled ? null : _toggleVisibility,
            padding: EdgeInsets.zero,
            splashRadius: _toggleIconSize,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
            icon:
                _obscureText
                    ? (widget.obscuredIcon ??
                        const Icon(Icons.visibility_off_outlined))
                    : (widget.visibleIcon ??
                        const Icon(Icons.visibility_outlined)),
          ),
        ),
      );
    }

    return Row(mainAxisSize: MainAxisSize.min, children: trailingChildren);
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      variant: widget.variant,
      isRounded: widget.isRounded,
      size: widget.size,
      hintText: widget.hintText,
      labelText: widget.labelText,
      helperText: widget.helperText,
      errorText: widget.errorText,
      errorTextSize: widget.errorTextSize,
      isPassword: _obscureText,
      isReadOnly: widget.isReadOnly,
      isDisabled: widget.isDisabled,
      isError: widget.isError,
      isSuccess: widget.isSuccess,
      isWarning: widget.isWarning,
      isRequired: widget.isRequired,
      isOptional: widget.isOptional,
      prefixIcon: _effectivePrefixIcon,
      clearTextIcon: widget.clearTextIcon,
      prefix: widget.prefix,
      suffix: _buildSuffix(),
      showClearTextAction: widget.showClearTextAction,
      floatingLabelBehavior: widget.floatingLabelBehavior,
      controller: widget.controller,
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      validate: widget.validate,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      autofocus: widget.autofocus,
      maxLength: widget.maxLength,
    );
  }
}

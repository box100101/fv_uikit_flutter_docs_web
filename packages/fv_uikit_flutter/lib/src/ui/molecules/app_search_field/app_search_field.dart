import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

class AppSearchField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSearchChanged;
  final String hintText;
  final int searchDelay;
  final AppTextFieldSize size;
  final bool autofocus;
  final bool isDisabled;
  final bool isReadOnly;
  final List<Widget>? prefixIcons;
  final Widget? prefixIcon;
  final List<Widget>? suffixIcons;
  final Widget? suffixIcon;
  final String? helperText;
  final String? errorText;

  const AppSearchField({
    super.key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.hintText = 'Tìm kiếm...',
    this.size = AppTextFieldSize.medium,
    this.autofocus = false,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.prefixIcons,
    this.prefixIcon,
    this.suffixIcons,
    this.suffixIcon,
    this.helperText,
    this.errorText,
    this.onSearchChanged,
    this.searchDelay = 400,
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _handleChanged(String value) {
    widget.onChanged?.call(value);

    final callback = widget.onSearchChanged;
    if (callback == null) return;

    _debounce?.cancel();

    if (Duration(milliseconds: widget.searchDelay) == Duration.zero) {
      callback(value);
      return;
    }

    _debounce = Timer(Duration(milliseconds: widget.searchDelay), () {
      if (!mounted) return;
      callback(value);
    });
  }

  Widget? _buildIconGroup(List<Widget>? icons) {
    if (icons == null || icons.isEmpty) return null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < icons.length; index++) ...[
          if (index > 0) const SizedBox(width: SpacingTokens.spaceXS),
          icons[index],
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefixGroup = _buildIconGroup(widget.prefixIcons);
    final suffixGroup = _buildIconGroup(widget.suffixIcons);

    return AppTextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      onChanged: _handleChanged,
      hintText: widget.hintText,
      helperText: widget.helperText,
      errorText: widget.errorText,
      prefixIcon:
          prefixGroup == null
              ? (widget.prefixIcon ?? const Icon(Icons.search_rounded))
              : widget.prefixIcon,
      suffixIcon: widget.suffixIcon,
      prefix: prefixGroup,
      suffix: suffixGroup,
      size: widget.size,
      autofocus: widget.autofocus,
      isDisabled: widget.isDisabled,
      isReadOnly: widget.isReadOnly,
      floatingLabelBehavior: FloatingLabelBehavior.never,
    );
  }
}

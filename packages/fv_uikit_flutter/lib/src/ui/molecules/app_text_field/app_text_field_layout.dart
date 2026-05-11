part of 'app_text_field.dart';

class _AppTextFieldLayout extends StatelessWidget {
  final AppTextField field;
  final TextEditingController controller;
  final FocusNode focusNode;
  final _AppTextFieldMetrics metrics;
  final _AppTextFieldPalette palette;
  final _AppTextFieldStateData state;
  final ValueChanged<String> onChanged;

  const _AppTextFieldLayout({
    required this.field,
    required this.controller,
    required this.focusNode,
    required this.metrics,
    required this.palette,
    required this.state,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius =
        (field.isRounded ?? false)
            ? BorderRadius.circular(metrics.height / 2)
            : BorderRadius.circular(metrics.borderRadius);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLabel(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            constraints: BoxConstraints(minHeight: metrics.height),
            padding: EdgeInsets.symmetric(
              horizontal: metrics.horizontalPadding,
            ),
            decoration: BoxDecoration(
              color: palette.background,
              borderRadius: borderRadius,
              border: Border.all(color: palette.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _buildFieldChildren(),
            ),
          ),
          _buildSupportingText(),
        ],
      ),
    );
  }

  Widget _buildLabel() {
    if (!state.showLabel) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingTokens.spaceS),
      child: Text.rich(
        TextSpan(
          text: field.labelText,
          style: TextStyleTokens.bodySRegular.copyWith(color: palette.label),
          children: [
            if (field.isRequired == true)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: ColorTokens.dangerDefault),
              ),
            if (field.isOptional == true)
              const TextSpan(
                text: ' (optional)',
                style: TextStyle(color: ColorTokens.textDescription),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportingText() {
    final supportingText = state.supportingText;
    if (supportingText?.isNotEmpty != true) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: SpacingTokens.spaceXS),
      child: AppText(
        text: supportingText!,
        size:
            state.isShowingErrorText
                ? field.errorTextSize ?? metrics.size
                : metrics.size,
        color: state.resolveSupportingColor(palette),
      ),
    );
  }

  Widget _buildIconSlot(Widget icon) {
    return SizedBox.square(
      dimension: metrics.iconSize,
      child: Center(
        child: IconTheme.merge(
          data: IconThemeData(size: metrics.iconSize, color: palette.icon),
          child: icon,
        ),
      ),
    );
  }

  Widget _buildActionIconSlot({
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return SizedBox.square(
      dimension: metrics.iconSize,
      child: IconTheme.merge(
        data: IconThemeData(
          size: metrics.iconSize,
          color: ColorTokens.iconDefault,
        ),
        child: IconButton(
          onPressed: onTap,
          icon: icon,
          padding: EdgeInsets.zero,
          splashRadius: metrics.iconSize,
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }

  Widget _buildAffixSlot(Widget child) {
    return IconTheme.merge(
      data: IconThemeData(size: metrics.iconSize, color: palette.text),
      child: DefaultTextStyle.merge(
        style: metrics.textStyle.copyWith(color: palette.text),
        child: _resolveAffixChild(child),
      ),
    );
  }

  Widget _buildCounter() {
    return AppText(
      text: '${controller.text.characters.length} / ${field.maxLength}',
      size: metrics.size,
      color: palette.secondaryText,
    );
  }

  Widget _buildInput() {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: field.autofocus,
      enabled: !state.isDisabled,
      readOnly: state.isReadOnly,
      obscureText: state.obscureText,
      keyboardType: field.keyboardType,
      textInputAction: field.textInputAction,
      maxLength: field.maxLength,
      onChanged: onChanged,
      onTap: _handleTap,
      cursorColor: palette.cursor,
      style: metrics.textStyle.copyWith(color: palette.text),
      textAlignVertical: TextAlignVertical.center,
      buildCounter:
          (
            BuildContext context, {
            required int currentLength,
            required bool isFocused,
            int? maxLength,
          }) => null,
      decoration: InputDecoration.collapsed(
        hintText: state.effectiveHintText,
        hintStyle: metrics.textStyle.copyWith(color: palette.placeholder),
      ),
    );
  }

  bool get _shouldShowClearTextAction =>
      field.showClearTextAction &&
      controller.text.isNotEmpty &&
      !state.isDisabled &&
      !state.isReadOnly;

  void _handleTap() {
    if (state.isDisabled) return;

    field.onTap?.call();
    _focusInput();
  }

  void _focusInput() {
    if (state.isDisabled || focusNode.hasFocus) return;
    focusNode.requestFocus();
  }

  void _clearText() {
    if (controller.text.isEmpty) return;

    controller.clear();
    onChanged(controller.text);
  }

  List<Widget> _buildFieldChildren() {
    final children = <Widget>[];

    void append(Widget child) {
      if (children.isNotEmpty) {
        children.add(SizedBox(width: metrics.gap));
      }
      children.add(child);
    }

    if (field.prefixIcon != null) {
      append(_buildIconSlot(field.prefixIcon!));
    }

    if (field.prefix != null) {
      append(_buildAffixSlot(field.prefix!));
    }

    append(Expanded(child: _buildInput()));

    if (state.showCounter) {
      append(_buildCounter());
    }

    if (field.suffix != null) {
      append(_buildAffixSlot(field.suffix!));
    }

    if (_shouldShowClearTextAction) {
      append(
        _buildActionIconSlot(
          icon: field.clearTextIcon ?? const Icon(Icons.cancel_outlined),
          onTap: _clearText,
        ),
      );
    }

    if (field.suffixIcon != null) {
      append(_buildIconSlot(field.suffixIcon!));
    }

    return children;
  }

  Widget _resolveAffixChild(Widget child) {
    if (child is! AppText) return child;

    final shouldInheritFieldSize =
        child.size == null && child.style == null && child.fontSize == null;

    return AppText(
      key: child.key,
      text: child.text,
      style: child.style,
      textAlign: child.textAlign,
      maxLines: child.maxLines,
      overflow: child.overflow,
      strutStyle: child.strutStyle,
      textDirection: child.textDirection,
      locale: child.locale,
      softWrap: child.softWrap,
      height: child.height,
      color: child.color,
      fontSize: child.fontSize,
      fontWeight: child.fontWeight,
      fontStyle: child.fontStyle,
      letterSpacing: child.letterSpacing,
      wordSpacing: child.wordSpacing,
      size: shouldInheritFieldSize ? metrics.size : child.size,
    );
  }
}

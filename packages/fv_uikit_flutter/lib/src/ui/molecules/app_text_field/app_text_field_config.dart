part of 'app_text_field.dart';

enum _AppTextFieldVisualState { primary, error, warning, success }

class _AppTextFieldStateData {
  final bool isDisabled;
  final bool isReadOnly;
  final bool hasFocus;
  final bool showCounter;
  final bool showLabel;
  final bool isShowingErrorText;
  final bool obscureText;
  final String? effectiveHintText;
  final String? supportingText;
  final _AppTextFieldVisualState visualState;

  const _AppTextFieldStateData({
    required this.isDisabled,
    required this.isReadOnly,
    required this.hasFocus,
    required this.showCounter,
    required this.showLabel,
    required this.isShowingErrorText,
    required this.obscureText,
    required this.effectiveHintText,
    required this.supportingText,
    required this.visualState,
  });

  factory _AppTextFieldStateData.resolve({
    required AppTextField widget,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String? errorText,
  }) {
    final visualState = _resolveVisualState(widget, errorText);
    final floatingLabelBehavior =
        widget.floatingLabelBehavior ?? FloatingLabelBehavior.always;
    final showLabel = _shouldShowLabel(
      labelText: widget.labelText,
      floatingLabelBehavior: floatingLabelBehavior,
      hasFocus: focusNode.hasFocus,
      hasText: controller.text.isNotEmpty,
    );

    return _AppTextFieldStateData(
      isDisabled: widget.isDisabled ?? false,
      isReadOnly: widget.isReadOnly ?? false,
      hasFocus: focusNode.hasFocus,
      showCounter: widget.maxLength != null,
      showLabel: showLabel,
      isShowingErrorText: errorText?.isNotEmpty == true,
      obscureText: widget.isPassword == true,
      effectiveHintText: _resolveHintText(
        widget: widget,
        floatingLabelBehavior: floatingLabelBehavior,
        showLabel: showLabel,
      ),
      supportingText: _resolveSupportingText(widget, visualState, errorText),
      visualState: visualState,
    );
  }

  Color resolveSupportingColor(_AppTextFieldPalette palette) {
    switch (visualState) {
      case _AppTextFieldVisualState.error:
        return ColorTokens.dangerDefault;
      case _AppTextFieldVisualState.warning:
        return ColorTokens.warningDefault;
      case _AppTextFieldVisualState.success:
        return ColorTokens.successDefault;
      case _AppTextFieldVisualState.primary:
        return ColorTokens.primaryDefault;
    }
  }

  static bool _shouldShowLabel({
    required String? labelText,
    required FloatingLabelBehavior floatingLabelBehavior,
    required bool hasFocus,
    required bool hasText,
  }) {
    if (labelText?.isNotEmpty != true) return false;

    switch (floatingLabelBehavior) {
      case FloatingLabelBehavior.never:
        return false;
      case FloatingLabelBehavior.always:
        return true;
      case FloatingLabelBehavior.auto:
        return hasFocus || hasText;
    }
  }

  static String? _resolveHintText({
    required AppTextField widget,
    required FloatingLabelBehavior floatingLabelBehavior,
    required bool showLabel,
  }) {
    if (floatingLabelBehavior == FloatingLabelBehavior.auto &&
        !showLabel &&
        widget.labelText?.isNotEmpty == true &&
        widget.hintText == null) {
      return widget.labelText;
    }

    return widget.hintText;
  }

  static String? _resolveSupportingText(
    AppTextField widget,
    _AppTextFieldVisualState visualState,
    String? errorText,
  ) {
    if (visualState == _AppTextFieldVisualState.error) {
      return errorText?.isNotEmpty == true ? errorText : widget.helperText;
    }

    return widget.helperText;
  }

  static _AppTextFieldVisualState _resolveVisualState(
    AppTextField widget,
    String? errorText,
  ) {
    if (errorText?.isNotEmpty == true ||
        widget.isError == true ||
        widget.variant == AppTextFieldVariant.danger) {
      return _AppTextFieldVisualState.error;
    }

    if (widget.isWarning == true ||
        widget.variant == AppTextFieldVariant.warning) {
      return _AppTextFieldVisualState.warning;
    }

    if (widget.isSuccess == true ||
        widget.variant == AppTextFieldVariant.success) {
      return _AppTextFieldVisualState.success;
    }

    return _AppTextFieldVisualState.primary;
  }
}

class _AppTextFieldMetrics {
  static const _extraSmall = _AppTextFieldMetrics(
    height: 32,
    horizontalPadding: SpacingTokens.paddingM,
    gap: SpacingTokens.gapXS,
    borderRadius: 4,
    iconSize: 16,
    textStyle: TextStyleTokens.bodyXSRegular,
    size: AppTextSize.bodyXSRegular,
  );

  static const _small = _AppTextFieldMetrics(
    height: 40,
    horizontalPadding: SpacingTokens.paddingL,
    gap: 6,
    borderRadius: 4,
    iconSize: 16,
    textStyle: TextStyleTokens.bodySRegular,
    size: AppTextSize.bodySRegular,
  );

  static const _medium = _AppTextFieldMetrics(
    height: 48,
    horizontalPadding: SpacingTokens.paddingL,
    gap: SpacingTokens.gapS,
    borderRadius: 4,
    iconSize: 20,
    textStyle: TextStyleTokens.bodyMRegular,
    size: AppTextSize.bodyMRegular,
  );

  static const _large = _AppTextFieldMetrics(
    height: 56,
    horizontalPadding: 20,
    gap: 10,
    borderRadius: 8,
    iconSize: 20,
    textStyle: TextStyleTokens.bodyLRegular,
    size: AppTextSize.bodyLRegular,
  );

  static const _extraLarge = _AppTextFieldMetrics(
    height: 64,
    horizontalPadding: SpacingTokens.paddingXL,
    gap: SpacingTokens.gapM,
    borderRadius: 8,
    iconSize: 24,
    textStyle: TextStyleTokens.bodyXLRegular,
    size: AppTextSize.bodyXLRegular,
  );

  final double height;
  final double horizontalPadding;
  final double gap;
  final double borderRadius;
  final double iconSize;
  final TextStyle textStyle;
  final AppTextSize size;

  const _AppTextFieldMetrics({
    required this.height,
    required this.horizontalPadding,
    required this.gap,
    required this.borderRadius,
    required this.iconSize,
    required this.textStyle,
    required this.size,
  });

  factory _AppTextFieldMetrics.fromSize(AppTextFieldSize size) {
    switch (size) {
      case AppTextFieldSize.xSmall:
        return _extraSmall;
      case AppTextFieldSize.small:
        return _small;
      case AppTextFieldSize.medium:
        return _medium;
      case AppTextFieldSize.large:
        return _large;
      case AppTextFieldSize.xLarge:
        return _extraLarge;
    }
  }
}

class _AppTextFieldPalette {
  final Color background;
  final Color border;
  final Color text;
  final Color placeholder;
  final Color secondaryText;
  final Color icon;
  final Color label;
  final Color cursor;

  const _AppTextFieldPalette({
    required this.background,
    required this.border,
    required this.text,
    required this.placeholder,
    required this.secondaryText,
    required this.icon,
    required this.label,
    required this.cursor,
  });

  factory _AppTextFieldPalette.resolve(_AppTextFieldStateData state) {
    if (state.isDisabled) {
      return const _AppTextFieldPalette(
        background: ColorTokens.bgContainerDisabled,
        border: ColorTokens.borderSecondary,
        text: ColorTokens.textDisabled,
        placeholder: ColorTokens.textDisabled,
        secondaryText: ColorTokens.textDisabled,
        icon: ColorTokens.textDisabled,
        label: ColorTokens.textDescription,
        cursor: ColorTokens.textDisabled,
      );
    }

    final accentColor = _resolveAccentColor(state.visualState);
    final borderColor = _resolveBorderColor(
      visualState: state.visualState,
      accentColor: accentColor,
      hasFocus: state.hasFocus,
    );

    return _AppTextFieldPalette(
      background:
          state.isReadOnly ? ColorTokens.bgWarm : ColorTokens.bgContainer,
      border: borderColor,
      text: ColorTokens.textDefault,
      placeholder: ColorTokens.textPlaceholder,
      secondaryText: ColorTokens.textDescription,
      icon:
          state.visualState != _AppTextFieldVisualState.primary
              ? accentColor
              : ColorTokens.iconDefault,
      label: ColorTokens.textLabel,
      cursor: accentColor,
    );
  }

  static Color _resolveAccentColor(_AppTextFieldVisualState visualState) {
    switch (visualState) {
      case _AppTextFieldVisualState.error:
        return ColorTokens.dangerDefault;
      case _AppTextFieldVisualState.warning:
        return ColorTokens.warningDefault;
      case _AppTextFieldVisualState.success:
        return ColorTokens.successDefault;
      case _AppTextFieldVisualState.primary:
        return ColorTokens.primaryDefault;
    }
  }

  static Color _resolveBorderColor({
    required _AppTextFieldVisualState visualState,
    required Color accentColor,
    required bool hasFocus,
  }) {
    if (hasFocus) return accentColor;

    switch (visualState) {
      case _AppTextFieldVisualState.error:
        return ColorTokens.dangerBorder;
      case _AppTextFieldVisualState.warning:
        return ColorTokens.warningBorder;
      case _AppTextFieldVisualState.success:
        return ColorTokens.successBorder;
      case _AppTextFieldVisualState.primary:
        return ColorTokens.border;
    }
  }
}

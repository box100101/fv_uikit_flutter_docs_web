import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

class AppLabel extends StatelessWidget {
  final String text;
  final AppLabelSize? size;
  final bool? isRequired;
  final AppLabelRequiredPosition? requiredPosition;
  final bool? isOptional;
  final String? optionalText;
  final bool? showInfoIcon;
  final Widget? infoIcon;
  final VoidCallback? onInfoTap;
  final String? tooltipMessage;
  final Color? textColor;
  final Color? optionalColor;
  final Color? requiredColor;
  final Color? iconColor;
  final TextStyle? textStyle;
  final TextStyle? optionalStyle;
  final double? spacing;

  const AppLabel({
    super.key,
    required this.text,
    this.size = AppLabelSize.medium,
    this.isRequired = false,
    this.requiredPosition = AppLabelRequiredPosition.trailing,
    this.isOptional = false,
    this.optionalText,
    this.showInfoIcon = false,
    this.infoIcon,
    this.onInfoTap,
    this.tooltipMessage,
    this.textColor,
    this.optionalColor,
    this.requiredColor,
    this.iconColor,
    this.textStyle,
    this.optionalStyle,
    this.spacing,
  });

  AppLabelSize get _resolvedSize => size ?? AppLabelSize.medium;

  AppLabelRequiredPosition get _resolvedRequiredPosition =>
      requiredPosition ?? AppLabelRequiredPosition.trailing;

  bool get _isRequired => isRequired ?? false;

  bool get _isOptional => isOptional ?? false;

  bool get _showInfoIcon => showInfoIcon ?? false;

  bool get _showLeadingRequired =>
      _isRequired &&
      (_resolvedRequiredPosition == AppLabelRequiredPosition.leading ||
          _resolvedRequiredPosition == AppLabelRequiredPosition.both);

  bool get _showTrailingRequired =>
      _isRequired &&
      (_resolvedRequiredPosition == AppLabelRequiredPosition.trailing ||
          _resolvedRequiredPosition == AppLabelRequiredPosition.both);

  TextStyle _mergeStyle(TextStyle baseStyle, TextStyle? override) {
    return baseStyle.merge(override);
  }

  TextSpan _requiredSpan(_AppLabelMetrics metrics) {
    return TextSpan(
      text: '*',
      style: metrics.textStyle.copyWith(
        color: requiredColor ?? ColorTokens.dangerDefault,
      ),
    );
  }

  Widget _buildText(_AppLabelMetrics metrics) {
    final contentStyle = _mergeStyle(
      metrics.textStyle.copyWith(color: textColor ?? ColorTokens.textDefault),
      textStyle,
    );
    final optionalTextStyle = _mergeStyle(
      metrics.optionalTextStyle.copyWith(
        color: optionalColor ?? ColorTokens.textDescription,
      ),
      optionalStyle,
    );

    return Text.rich(
      TextSpan(
        children: [
          if (_showLeadingRequired) ...[
            _requiredSpan(metrics),
            TextSpan(text: ' ', style: contentStyle),
          ],
          TextSpan(text: text, style: contentStyle),
          if (_showTrailingRequired) ...[
            TextSpan(text: ' ', style: contentStyle),
            _requiredSpan(metrics),
          ],
          if (_isOptional)
            TextSpan(
              text: ' ${optionalText ?? '(optional)'}',
              style: optionalTextStyle,
            ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildInfoIcon(_AppLabelMetrics metrics) {
    final icon = IconTheme.merge(
      data: IconThemeData(
        size: metrics.iconSize,
        color: iconColor ?? ColorTokens.iconDefault,
      ),
      child: infoIcon ?? const Icon(Icons.info_outline),
    );

    final iconSlot = SizedBox.square(
      dimension: metrics.iconSlotSize,
      child: Center(child: icon),
    );

    final tappableIcon =
        onInfoTap == null
            ? iconSlot
            : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onInfoTap,
              child: iconSlot,
            );

    if (tooltipMessage?.isNotEmpty == true) {
      return Tooltip(message: tooltipMessage!, child: tappableIcon);
    }

    return tappableIcon;
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _AppLabelMetrics.fromSize(_resolvedSize);

    return Semantics(
      label: text,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildText(metrics),
          if (_showInfoIcon) ...[
            SizedBox(width: spacing ?? metrics.contentGap),
            _buildInfoIcon(metrics),
          ],
        ],
      ),
    );
  }
}

class _AppLabelMetrics {
  static const _xSmall = _AppLabelMetrics(
    textStyle: TextStyleTokens.bodyXSMedium,
    optionalTextStyle: TextStyleTokens.bodyXSMedium,
    contentGap: 4,
    iconSize: 12,
    iconSlotSize: 14,
  );

  static const _small = _AppLabelMetrics(
    textStyle: TextStyleTokens.bodySMedium,
    optionalTextStyle: TextStyleTokens.bodySMedium,
    contentGap: 6,
    iconSize: 12,
    iconSlotSize: 14,
  );

  static const _medium = _AppLabelMetrics(
    textStyle: TextStyleTokens.bodyMMedium,
    optionalTextStyle: TextStyleTokens.bodyMMedium,
    contentGap: 8,
    iconSize: 16,
    iconSlotSize: 18,
  );

  static const _large = _AppLabelMetrics(
    textStyle: TextStyleTokens.bodyLMedium,
    optionalTextStyle: TextStyleTokens.bodyLMedium,
    contentGap: 8,
    iconSize: 20,
    iconSlotSize: 22,
  );

  static const _xLarge = _AppLabelMetrics(
    textStyle: TextStyleTokens.bodyXLMedium,
    optionalTextStyle: TextStyleTokens.bodyXLMedium,
    contentGap: 10,
    iconSize: 24,
    iconSlotSize: 26,
  );

  final TextStyle textStyle;
  final TextStyle optionalTextStyle;
  final double contentGap;
  final double iconSize;
  final double iconSlotSize;

  const _AppLabelMetrics({
    required this.textStyle,
    required this.optionalTextStyle,
    required this.contentGap,
    required this.iconSize,
    required this.iconSlotSize,
  });

  factory _AppLabelMetrics.fromSize(AppLabelSize size) {
    switch (size) {
      case AppLabelSize.xSmall:
        return _xSmall;
      case AppLabelSize.small:
        return _small;
      case AppLabelSize.medium:
        return _medium;
      case AppLabelSize.large:
        return _large;
      case AppLabelSize.xLarge:
        return _xLarge;
    }
  }
}

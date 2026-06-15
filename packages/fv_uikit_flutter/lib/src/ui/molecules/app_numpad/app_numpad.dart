import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';
import '../../atoms/app_text_style_resolver.dart';

part 'app_numpad_metrics.dart';

class AppNumpadItem {
  final String label;
  final String value;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isBackspace;
  final bool isActionKey;

  const AppNumpadItem({
    required this.label,
    required this.value,
    this.backgroundColor,
    this.textColor,
    this.isBackspace = false,
    this.isActionKey = false,
  });
}

class AppNumpad extends StatefulWidget {
  final TextEditingController controller;
  final double width;
  final int crossAxisCount;
  final List<AppNumpadItem> keys;
  final ValueChanged<String>? onChanged;
  final int maxValue;
  final AppNumpadSize size;

  // Header display options
  final bool showDisplayHeader;
  final String? headerTitle;
  final double? headerAmount;
  final String? headerSubtitle;
  final double? headerSubtitleValue;
  final String currencyUnit;

  const AppNumpad({
    super.key,
    required this.controller,
    this.onChanged,
    this.width = 360,
    this.crossAxisCount = 4,
    this.keys = const [
      AppNumpadItem(label: '1', value: '1'),
      AppNumpadItem(label: '2', value: '2'),
      AppNumpadItem(label: '3', value: '3'),
      AppNumpadItem(label: '100', value: '100', isActionKey: true),
      AppNumpadItem(label: '4', value: '4'),
      AppNumpadItem(label: '5', value: '5'),
      AppNumpadItem(label: '6', value: '6'),
      AppNumpadItem(label: '50', value: '50', isActionKey: true),
      AppNumpadItem(label: '7', value: '7'),
      AppNumpadItem(label: '8', value: '8'),
      AppNumpadItem(label: '9', value: '9'),
      AppNumpadItem(label: '20', value: '20', isActionKey: true),
      AppNumpadItem(label: '0', value: '0'),
      AppNumpadItem(label: '000', value: '000'),
      AppNumpadItem(label: '', value: 'backspace', isBackspace: true),
      AppNumpadItem(label: '10', value: '10', isActionKey: true),
    ],
    this.maxValue = 9999999999,
    this.size = AppNumpadSize.medium,
    this.showDisplayHeader = false,
    this.headerTitle,
    this.headerAmount,
    this.headerSubtitle,
    this.headerSubtitleValue,
    this.currencyUnit = 'đ',
  });

  @override
  State<AppNumpad> createState() => _AppNumpadState();
}

class _AppNumpadState extends State<AppNumpad> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(AppNumpad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  bool _isNumeric(String str) {
    if (str.isEmpty) return false;
    return int.tryParse(str) != null;
  }

  void _onKeyPress(AppNumpadItem numPadKey) {
    final controller = widget.controller;
    if (numPadKey.value == 'backspace') {
      final currentText = controller.text;
      if (currentText.isNotEmpty) {
        controller.text = currentText.substring(0, currentText.length - 1);
      }
    } else {
      final after = controller.text + numPadKey.value;
      if (_isNumeric(after)) {
        final parsed = int.tryParse(after);
        if (parsed != null) {
          controller.text =
              parsed > widget.maxValue
                  ? widget.maxValue.toString()
                  : parsed.toString();
        }
      } else if (controller.text.isEmpty && _isNumeric(numPadKey.value)) {
        final parsed = int.tryParse(numPadKey.value);
        if (parsed != null) {
          controller.text =
              parsed > widget.maxValue
                  ? widget.maxValue.toString()
                  : parsed.toString();
        }
      }
    }
    widget.onChanged?.call(controller.text);
  }

  String _formatCurrency(num money) {
    final number = money.toInt();
    final regex = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return number.toString().replaceAll(regex, ',');
  }

  Widget _buildHeader() {
    final title = widget.headerTitle;
    final amount = widget.headerAmount ?? 0.0;
    final subtitle = widget.headerSubtitle;
    final subtitleVal = widget.headerSubtitleValue;

    return Container(
      padding: const EdgeInsets.all(SpacingTokens.paddingM),
      decoration: BoxDecoration(
        color: ColorTokens.bgWarm,
        borderRadius: BorderRadius.circular(RadiusTokens.radiusM),
        border: Border.all(color: ColorTokens.borderSecondary),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            AppText(
              text: title,
              size: AppTextSize.bodyMRegular,
              color: ColorTokens.textSecondary,
            ),
            const SizedBox(height: SpacingTokens.gapXS),
            Align(
              alignment: Alignment.centerRight,
              child: AppText(
                text: '${_formatCurrency(amount)} ${widget.currencyUnit}',
                style: buildAppTextStyle(
                  fontSize: 24,
                  fontWeight: AppTextFontWeight.bold,
                  color: ColorTokens.textDefault,
                ),
              ),
            ),
          ],
          if (subtitle != null && subtitleVal != null) ...[
            const SizedBox(height: SpacingTokens.gapS),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: subtitle,
                  size: AppTextSize.bodyMRegular,
                  color: ColorTokens.textSecondary,
                ),
                AppText(
                  text: '${_formatCurrency(subtitleVal)} ${widget.currencyUnit}',
                  style: buildAppTextStyle(
                    fontSize: 14,
                    fontWeight: AppTextFontWeight.bold,
                    color: ColorTokens.primary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _AppNumpadMetrics.fromSize(widget.size);

    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.showDisplayHeader) ...[
            _buildHeader(),
            const SizedBox(height: SpacingTokens.gapL),
          ],
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: widget.crossAxisCount,
            mainAxisSpacing: metrics.mainAxisSpacing,
            crossAxisSpacing: metrics.crossAxisSpacing,
            childAspectRatio: metrics.childAspectRatio,
            physics: const NeverScrollableScrollPhysics(),
            children:
                widget.keys
                    .map(
                      (numPadKey) => _NumpadButton(
                        numPadKey: numPadKey,
                        onTap: () => _onKeyPress(numPadKey),
                        fontSize: metrics.fontSize,
                        padding: metrics.keyPadding,
                        borderRadius: metrics.borderRadius,
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}

class _NumpadButton extends StatelessWidget {
  final AppNumpadItem numPadKey;
  final VoidCallback onTap;
  final double fontSize;
  final double padding;
  final double borderRadius;

  const _NumpadButton({
    required this.numPadKey,
    required this.onTap,
    required this.fontSize,
    required this.padding,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBg =
        numPadKey.isActionKey
            ? ColorTokens.fillTertiary
            : ColorTokens.white;
    final backgroundColor = numPadKey.backgroundColor ?? defaultBg;
    final textColor = numPadKey.textColor ?? ColorTokens.textDefault;
    final radius = BorderRadius.circular(borderRadius);

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: radius,
          border: Border.all(color: ColorTokens.borderSecondary),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Center(
            child:
                numPadKey.isBackspace
                    ? Icon(
                      Icons.backspace_outlined,
                      size: fontSize * 1.2,
                      color: textColor,
                    )
                    : AppText(
                      text: numPadKey.label,
                      style: buildAppTextStyle(
                        fontSize: fontSize,
                        color: textColor,
                        fontWeight: AppTextFontWeight.medium,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}

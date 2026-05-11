import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'docs.dart';

class CheckboxesScreen extends StatefulWidget {
  const CheckboxesScreen({super.key});

  @override
  State<CheckboxesScreen> createState() => _CheckboxesScreenState();
}

class _CheckboxesScreenState extends State<CheckboxesScreen> {
  final Map<AppCheckboxSize, bool?> _sizeValues = {
    AppCheckboxSize.xSmall: true,
    AppCheckboxSize.small: true,
    AppCheckboxSize.medium: true,
    AppCheckboxSize.large: true,
    AppCheckboxSize.xLarge: true,
  };

  bool? _defaultValue = false;
  bool? _checkedValue = true;
  bool? _indeterminateValue;

  void _setSizeValue(AppCheckboxSize size, bool? value) {
    setState(() {
      _sizeValues[size] = value;
    });
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingTokens.paddingS),
      child: AppText(
        text: text,
        size: AppTextSize.bodyLBold,
        color: ColorTokens.textDefault,
      ),
    );
  }

  Widget _buildSizeCheckbox(
    AppCheckboxSize size, {
    AppCheckboxVariant variant = AppCheckboxVariant.standard,
  }) {
    return AppCheckbox(
      value: _sizeValues[size],
      size: size,
      variant: variant,
      label: 'Checkbox label',
      onChanged: (value) => _setSizeValue(size, value),
    );
  }

  Widget _buildStateCheckbox({
    required bool? value,
    required ValueChanged<bool?>? onChanged,
    bool isDisabled = false,
    AppCheckboxVariant variant = AppCheckboxVariant.standard,
  }) {
    return AppCheckbox(
      value: value,
      variant: variant,
      label: 'Checkbox label',
      tristate: true,
      isDisabled: isDisabled,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DocsScaffold(
      title: const DocsText(en: 'Checkboxes', vi: 'Checkboxes'),
      description: const DocsText(
        en:
            'Selection controls for multi-select, tristate, boxed, and selectbox patterns.',
        vi: 'Điều khiển lựa chọn cho multi-select, tristate, boxed và selectbox.',
      ),
      doc: widgetDocFor('checkbox'),
      children: [
        ExampleSection(
          title: const DocsText(en: 'Live examples', vi: 'Ví dụ trực tiếp'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Checkbox sizes'),
              Wrap(
                spacing: SpacingTokens.gap4XL,
                runSpacing: SpacingTokens.gapL,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final size in AppCheckboxSize.values)
                    _buildSizeCheckbox(size),
                  for (final size in AppCheckboxSize.values)
                    _buildSizeCheckbox(size, variant: AppCheckboxVariant.boxed),
                ],
              ),
              const SizedBox(height: SpacingTokens.padding2XL),
              _buildSectionTitle('Checkbox states'),
              Wrap(
                spacing: SpacingTokens.gap2XL,
                runSpacing: SpacingTokens.gapL,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildStateCheckbox(
                    value: _defaultValue,
                    onChanged: (value) => setState(() => _defaultValue = value),
                  ),
                  _buildStateCheckbox(
                    value: _checkedValue,
                    onChanged: (value) => setState(() => _checkedValue = value),
                  ),
                  _buildStateCheckbox(
                    value: _indeterminateValue,
                    onChanged:
                        (value) => setState(() => _indeterminateValue = value),
                  ),
                  const AppCheckbox(
                    value: false,
                    label: 'Checkbox label',
                    isDisabled: true,
                  ),
                  const AppCheckbox(
                    value: true,
                    label: 'Checkbox label',
                    isDisabled: true,
                  ),
                  const AppCheckbox(
                    value: null,
                    label: 'Checkbox label',
                    tristate: true,
                    isDisabled: true,
                  ),
                ],
              ),
              const SizedBox(height: SpacingTokens.padding2XL),
              _buildSectionTitle('Selectbox sizes'),
              Wrap(
                spacing: SpacingTokens.gapL,
                runSpacing: SpacingTokens.gapM,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final size in AppCheckboxSize.values)
                    _buildSizeCheckbox(
                      size,
                      variant: AppCheckboxVariant.selectbox,
                    ),
                ],
              ),
              const SizedBox(height: SpacingTokens.padding2XL),
              _buildSectionTitle('Selectbox states'),
              Wrap(
                spacing: SpacingTokens.gapL,
                runSpacing: SpacingTokens.gapM,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildStateCheckbox(
                    value: false,
                    variant: AppCheckboxVariant.selectbox,
                    onChanged: (_) {},
                  ),
                  _buildStateCheckbox(
                    value: true,
                    variant: AppCheckboxVariant.selectbox,
                    onChanged: (_) {},
                  ),
                  _buildStateCheckbox(
                    value: null,
                    variant: AppCheckboxVariant.selectbox,
                    onChanged: (_) {},
                  ),
                  const AppCheckbox(
                    value: false,
                    label: 'Checkbox label',
                    variant: AppCheckboxVariant.selectbox,
                    isDisabled: true,
                  ),
                  const AppCheckbox(
                    value: true,
                    label: 'Checkbox label',
                    variant: AppCheckboxVariant.selectbox,
                    isDisabled: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

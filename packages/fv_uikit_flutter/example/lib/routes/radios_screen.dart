import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'docs.dart';

class RadiosScreen extends StatefulWidget {
  const RadiosScreen({super.key});

  @override
  State<RadiosScreen> createState() => _RadiosScreenState();
}

class _RadiosScreenState extends State<RadiosScreen> {
  AppRadioSize _selectedSize = AppRadioSize.medium;
  String _selectedState = 'selected';

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

  Widget _buildSizeRadio(AppRadioSize size, {bool boxed = false}) {
    return AppRadio<AppRadioSize>(
      value: size,
      groupValue: _selectedSize,
      size: size,
      variant: boxed ? AppRadioVariant.boxed : AppRadioVariant.standard,
      label: 'Radiobox label',
      onChanged: (value) {
        if (value == null) return;
        setState(() => _selectedSize = value);
      },
    );
  }

  Widget _buildStateRadio(String value, {bool isDisabled = false}) {
    return AppRadio<String>(
      value: value,
      groupValue: _selectedState,
      label: 'Radiobox label',
      isDisabled: isDisabled,
      onChanged: (nextValue) {
        if (nextValue == null) return;
        setState(() => _selectedState = nextValue);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DocsScaffold(
      title: const DocsText(en: 'Radios', vi: 'Radios'),
      description: const DocsText(
        en: 'Single-choice controls for grouped options.',
        vi: 'Điều khiển lựa chọn một giá trị trong một nhóm option.',
      ),
      doc: widgetDocFor('radio'),
      children: [
        ExampleSection(
          title: const DocsText(en: 'Live examples', vi: 'Ví dụ trực tiếp'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Radio sizes'),
              Wrap(
                spacing: SpacingTokens.gap2XL,
                runSpacing: SpacingTokens.gapL,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildSizeRadio(AppRadioSize.xSmall),
                  _buildSizeRadio(AppRadioSize.small),
                  _buildSizeRadio(AppRadioSize.medium),
                  _buildSizeRadio(AppRadioSize.large),
                  _buildSizeRadio(AppRadioSize.xLarge),
                  _buildSizeRadio(AppRadioSize.xSmall, boxed: true),
                  _buildSizeRadio(AppRadioSize.small, boxed: true),
                  _buildSizeRadio(AppRadioSize.medium, boxed: true),
                  _buildSizeRadio(AppRadioSize.large, boxed: true),
                  _buildSizeRadio(AppRadioSize.xLarge, boxed: true),
                ],
              ),
              const SizedBox(height: SpacingTokens.padding2XL),
              _buildSectionTitle('Radio states'),
              Wrap(
                spacing: SpacingTokens.gap2XL,
                runSpacing: SpacingTokens.gapL,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildStateRadio('default'),
                  _buildStateRadio('selected'),
                  _buildStateRadio('disabled'),
                  _buildStateRadio('disabledSelected', isDisabled: true),
                  const AppRadio<String>(
                    value: 'disabledOff',
                    groupValue: 'different',
                    label: 'Radiobox label',
                    isDisabled: true,
                  ),
                  const AppRadio<String>(
                    value: 'disabledOn',
                    groupValue: 'disabledOn',
                    label: 'Radiobox label',
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

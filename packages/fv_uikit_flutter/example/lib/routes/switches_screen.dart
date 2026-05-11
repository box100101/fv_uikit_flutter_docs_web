import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'docs.dart';

class SwitchesScreen extends StatefulWidget {
  const SwitchesScreen({super.key});

  @override
  State<SwitchesScreen> createState() => _SwitchesScreenState();
}

class _SwitchesScreenState extends State<SwitchesScreen> {
  final Map<AppSwitchSize, bool> _sizeValues = {
    AppSwitchSize.xSmall: true,
    AppSwitchSize.small: true,
    AppSwitchSize.medium: true,
    AppSwitchSize.large: true,
    AppSwitchSize.xLarge: true,
  };

  bool _defaultOff = false;
  bool _defaultOn = true;

  void _setSizeValue(AppSwitchSize size, bool value) {
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

  Widget _buildSizeSwitch(AppSwitchSize size, String label) {
    return AppSwitch(
      value: _sizeValues[size] ?? false,
      size: size,
      label: label,
      onChanged: (value) => _setSizeValue(size, value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DocsScaffold(
      title: const DocsText(en: 'Switches', vi: 'Switches'),
      description: const DocsText(
        en: 'Immediate on/off controls for preferences and settings.',
        vi: 'Điều khiển bật/tắt tức thời cho tùy chọn và cài đặt.',
      ),
      doc: widgetDocFor('switch'),
      children: [
        ExampleSection(
          title: const DocsText(en: 'Live examples', vi: 'Ví dụ trực tiếp'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Switch sizes'),
              Wrap(
                spacing: SpacingTokens.gap2XL,
                runSpacing: SpacingTokens.gapL,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildSizeSwitch(AppSwitchSize.xSmall, 'Switch label'),
                  _buildSizeSwitch(AppSwitchSize.small, 'Switch label'),
                  _buildSizeSwitch(AppSwitchSize.medium, 'Switch label'),
                  _buildSizeSwitch(AppSwitchSize.large, 'Switch label'),
                  _buildSizeSwitch(AppSwitchSize.xLarge, 'Switch label'),
                ],
              ),
              const SizedBox(height: SpacingTokens.padding2XL),
              _buildSectionTitle('Switch states'),
              Wrap(
                spacing: SpacingTokens.gap2XL,
                runSpacing: SpacingTokens.gapL,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  AppSwitch(
                    value: _defaultOff,
                    label: 'Switch label',
                    onChanged: (value) => setState(() => _defaultOff = value),
                  ),
                  AppSwitch(
                    value: _defaultOn,
                    label: 'Switch label',
                    onChanged: (value) => setState(() => _defaultOn = value),
                  ),
                  const AppSwitch(
                    value: false,
                    label: 'Switch label',
                    isDisabled: true,
                  ),
                  const AppSwitch(
                    value: true,
                    label: 'Switch label',
                    isDisabled: true,
                  ),
                  const AppSwitch(
                    value: true,
                    label: 'Readonly label',
                    isReadOnly: true,
                    onChanged: null,
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

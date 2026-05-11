import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'docs.dart';

class LabelsScreen extends StatelessWidget {
  const LabelsScreen({super.key});

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

  Widget _buildLabel(AppLabelSize size, {AppLabelRequiredPosition? position}) {
    return AppLabel(
      text: 'Label content',
      size: size,
      isRequired: true,
      requiredPosition: position ?? AppLabelRequiredPosition.both,
      isOptional: true,
      showInfoIcon: true,
      tooltipMessage: 'Label description',
    );
  }

  @override
  Widget build(BuildContext context) {
    return DocsScaffold(
      title: const DocsText(en: 'Labels', vi: 'Labels'),
      description: const DocsText(
        en: 'Form label atom for required, optional, tooltip, and size states.',
        vi: 'Atom nhãn form cho trạng thái bắt buộc, tùy chọn, tooltip và size.',
      ),
      doc: widgetDocFor('label'),
      children: [
        ExampleSection(
          title: const DocsText(en: 'Live examples', vi: 'Ví dụ trực tiếp'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Label sizes'),
              Wrap(
                spacing: 120,
                runSpacing: SpacingTokens.padding2XL,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(AppLabelSize.xSmall),
                      const SizedBox(height: SpacingTokens.paddingL),
                      _buildLabel(AppLabelSize.small),
                      const SizedBox(height: SpacingTokens.paddingL),
                      _buildLabel(AppLabelSize.medium),
                      const SizedBox(height: SpacingTokens.paddingL),
                      _buildLabel(AppLabelSize.large),
                      const SizedBox(height: SpacingTokens.paddingL),
                      _buildLabel(AppLabelSize.xLarge),
                      const SizedBox(height: SpacingTokens.paddingL),
                      _buildLabel(
                        AppLabelSize.medium,
                        position: AppLabelRequiredPosition.leading,
                      ),
                      const SizedBox(height: SpacingTokens.paddingL),
                      _buildLabel(
                        AppLabelSize.medium,
                        position: AppLabelRequiredPosition.trailing,
                      ),
                    ],
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

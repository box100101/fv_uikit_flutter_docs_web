import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'docs.dart';

class DividersScreen extends StatelessWidget {
  const DividersScreen({super.key});

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

  Widget _buildHorizontalDivider(AppDividerVariant variant) {
    return AppDivider(variant: variant, thickness: 2);
  }

  Widget _buildVerticalDivider(AppDividerVariant variant) {
    return AppDivider(
      orientation: AppDividerOrientation.vertical,
      variant: variant,
      thickness: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    const variants = [
      AppDividerVariant.defaultValue,
      AppDividerVariant.info,
      AppDividerVariant.warning,
      AppDividerVariant.danger,
      AppDividerVariant.success,
    ];

    return DocsScaffold(
      title: const DocsText(en: 'Dividers', vi: 'Dividers'),
      description: const DocsText(
        en: 'Separator atom for content structure and status-colored boundaries.',
        vi:
            'Atom phân tách dùng để tạo cấu trúc nội dung và ranh giới theo màu trạng thái.',
      ),
      doc: widgetDocFor('divider'),
      children: [
        ExampleSection(
          title: const DocsText(en: 'Live examples', vi: 'Ví dụ trực tiếp'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Horizontal dividers'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final variant in variants) ...[
                    _buildHorizontalDivider(variant),
                    const SizedBox(height: SpacingTokens.paddingXL),
                  ],
                ],
              ),
              const SizedBox(height: SpacingTokens.padding2XL),
              _buildSectionTitle('Vertical dividers'),
              SizedBox(
                height: 420,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final variant in variants) ...[
                      _buildVerticalDivider(variant),
                      const SizedBox(width: SpacingTokens.padding2XL),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

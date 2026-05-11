import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'docs.dart';

class TextScreen extends StatelessWidget {
  const TextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DocsScaffold(
      title: const DocsText(en: 'Text', vi: 'Text'),
      description: const DocsText(
        en: 'Typography atom for consistent text styles across product screens.',
        vi: 'Typography atom giúp đồng bộ text style trên các màn hình sản phẩm.',
      ),
      doc: widgetDocFor('text'),
      children: const [
        ExampleSection(
          title: DocsText(en: 'Text scale', vi: 'Thang chữ'),
          description: DocsText(
            en: 'Each AppTextSize maps to a TextStyleTokens entry.',
            vi: 'Mỗi AppTextSize map tới một TextStyleTokens.',
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(text: 'BodyXS/Regular', size: AppTextSize.bodyXSRegular),
              AppText(text: 'BodyXS/Medium', size: AppTextSize.bodyXSMedium),
              AppText(text: 'BodyXS/Bold\n', size: AppTextSize.bodyXSBold),

              AppText(text: 'BodyS/Regular', size: AppTextSize.bodySRegular),
              AppText(text: 'BodyS/Medium', size: AppTextSize.bodySMedium),
              AppText(text: 'BodyS/Bold\n', size: AppTextSize.bodySBold),

              AppText(text: 'BodyM/Regular', size: AppTextSize.bodyMRegular),
              AppText(text: 'BodyM/Medium', size: AppTextSize.bodyMMedium),
              AppText(text: 'BodyM/Bold\n', size: AppTextSize.bodyMBold),

              AppText(text: 'BodyL/Regular', size: AppTextSize.bodyLRegular),
              AppText(text: 'BodyL/Medium', size: AppTextSize.bodyLMedium),
              AppText(text: 'BodyL/Bold\n', size: AppTextSize.bodyLBold),

              AppText(text: 'BodyXL/Regular', size: AppTextSize.bodyXLRegular),
              AppText(text: 'BodyXL/Medium', size: AppTextSize.bodyXLMedium),
              AppText(text: 'BodyXL/Bold\n', size: AppTextSize.bodyXLBold),

              AppText(
                text: 'Heading4/Regular',
                size: AppTextSize.heading4Regular,
              ),
              AppText(
                text: 'Heading4/Medium',
                size: AppTextSize.heading4Medium,
              ),
              AppText(text: 'Heading4/Bold\n', size: AppTextSize.heading4Bold),

              AppText(
                text: 'Heading3/Regular',
                size: AppTextSize.heading3Regular,
              ),
              AppText(
                text: 'Heading3/Medium',
                size: AppTextSize.heading3Medium,
              ),
              AppText(text: 'Heading3/Bold\n', size: AppTextSize.heading3Bold),

              AppText(
                text: 'Heading2/Regular',
                size: AppTextSize.heading2Regular,
              ),
              AppText(
                text: 'Heading2/Medium',
                size: AppTextSize.heading2Medium,
              ),
              AppText(text: 'Heading2/Bold\n', size: AppTextSize.heading2Bold),

              AppText(
                text: 'Heading1/Regular',
                size: AppTextSize.heading1Regular,
              ),
              AppText(
                text: 'Heading1/Medium',
                size: AppTextSize.heading1Medium,
              ),
              AppText(text: 'Heading1/Bold\n', size: AppTextSize.heading1Bold),
            ],
          ),
        ),
      ],
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'models.dart';

List<ExampleDocEntry> buildTextExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'Typography scale', vi: 'Thang typography'),
      description: LocalizedText(
        en: 'Use tokenized sizes so headings and body text stay consistent.',
        vi: 'Dùng size theo token để heading và body text luôn nhất quán.',
      ),
      code:
          "Column(\n"
          "  crossAxisAlignment: CrossAxisAlignment.start,\n"
          "  children: const [\n"
          "    AppText(text: 'Heading 4', size: AppTextSize.heading4Bold),\n"
          "    AppText(text: 'Body M', size: AppTextSize.bodyMRegular),\n"
          "    AppText(text: 'Caption', size: AppTextSize.bodyXSRegular),\n"
          "  ],\n"
          ")",
      builder: _buildTextScaleExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(en: 'Color and overflow', vi: 'Màu và overflow'),
      description: LocalizedText(
        en: 'Combine color tokens and maxLines for dense layouts.',
        vi: 'Kết hợp color token và maxLines cho layout dày thông tin.',
      ),
      code:
          "AppText(\n"
          "  text: 'A long product title that must clamp nicely in cards.',\n"
          "  size: AppTextSize.bodyMBold,\n"
          "  color: ColorTokens.primaryDefault,\n"
          "  maxLines: 2,\n"
          "  overflow: TextOverflow.ellipsis,\n"
          ")",
      builder: _buildTextOverflowExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Receipt summary block',
        vi: 'Khối tóm tắt hóa đơn',
      ),
      description: LocalizedText(
        en: 'Combine heading, metadata, and emphasis text to structure transactional content.',
        vi: 'Kết hợp heading, metadata và text nhấn mạnh để tổ chức nội dung giao dịch.',
      ),
      code:
          "Column(\n"
          "  crossAxisAlignment: CrossAxisAlignment.start,\n"
          "  children: const [\n"
          "    AppText(text: 'Order #FV-1024', size: AppTextSize.heading4Bold),\n"
          "    SizedBox(height: 8),\n"
          "    AppText(text: 'Paid via bank transfer', size: AppTextSize.bodySRegular, color: ColorTokens.textDescription),\n"
          "    SizedBox(height: 12),\n"
          "    AppText(text: '2,480,000 VND', size: AppTextSize.bodyXLBold, color: ColorTokens.successDefault),\n"
          "  ],\n"
          ")",
      builder: _buildTextReceiptExample,
    ),
  ];
}

Widget _buildTextScaleExample(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText(text: 'Heading 4', size: AppTextSize.heading4Bold),
      SizedBox(height: SpacingTokens.spaceXS),
      AppText(text: 'Body M', size: AppTextSize.bodyMRegular),
      SizedBox(height: SpacingTokens.spaceXS),
      AppText(text: 'Caption', size: AppTextSize.bodyXSRegular),
    ],
  );
}

Widget _buildTextOverflowExample(BuildContext context) {
  return const SizedBox(
    width: 240,
    child: AppText(
      text: 'A long product title that must clamp nicely in cards and lists.',
      size: AppTextSize.bodyMBold,
      color: ColorTokens.primaryDefault,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget _buildTextReceiptExample(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText(text: 'Order #FV-1024', size: AppTextSize.heading4Bold),
      SizedBox(height: SpacingTokens.spaceS),
      AppText(
        text: 'Paid via bank transfer',
        size: AppTextSize.bodySRegular,
        color: ColorTokens.textDescription,
      ),
      SizedBox(height: SpacingTokens.spaceM),
      AppText(
        text: '2,480,000 VND',
        size: AppTextSize.bodyXLBold,
        color: ColorTokens.successDefault,
      ),
    ],
  );
}

List<ExampleDocEntry> buildLoadingExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'Sizes', vi: 'Các kích thước'),
      description: LocalizedText(
        en: 'Scale the spinner from inline to section-level loading.',
        vi: 'Scale spinner từ inline đến loading cả section.',
      ),
      code:
          "const Row(\n"
          "  children: [\n"
          "    AppLoadingSpinner(size: IconSizeTokens.iconSizeS),\n"
          "    SizedBox(width: 12),\n"
          "    AppLoadingSpinner(size: IconSizeTokens.iconSizeL),\n"
          "    SizedBox(width: 12),\n"
          "    AppLoadingSpinner(size: IconSizeTokens.iconSizeXL),\n"
          "  ],\n"
          ")",
      builder: _buildLoadingSizesExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Determinate progress',
        vi: 'Tiến trình xác định',
      ),
      description: LocalizedText(
        en: 'Set value when the progress percentage is known.',
        vi: 'Đặt value khi bạn biết phần trăm tiến trình.',
      ),
      code:
          "const AppLoadingSpinner(\n"
          "  size: 40,\n"
          "  value: 0.72,\n"
          "  color: ColorTokens.successDefault,\n"
          ")",
      builder: _buildLoadingDeterminateExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Inline async feedback',
        vi: 'Phản hồi async trong dòng',
      ),
      description: LocalizedText(
        en: 'Place the spinner next to copy when the action should not block the entire screen.',
        vi: 'Đặt spinner cạnh nội dung khi action không nên chặn toàn bộ màn hình.',
      ),
      code:
          "const Row(\n"
          "  mainAxisSize: MainAxisSize.min,\n"
          "  children: [\n"
          "    AppLoadingSpinner(size: IconSizeTokens.iconSizeM),\n"
          "    SizedBox(width: 8),\n"
          "    AppText(text: 'Syncing product catalog...', size: AppTextSize.bodyMRegular),\n"
          "  ],\n"
          ")",
      builder: _buildLoadingInlineExample,
    ),
  ];
}

Widget _buildLoadingSizesExample(BuildContext context) {
  return const Row(
    children: [
      AppLoadingSpinner(size: IconSizeTokens.iconSizeS),
      SizedBox(width: 12),
      AppLoadingSpinner(size: IconSizeTokens.iconSizeL),
      SizedBox(width: 12),
      AppLoadingSpinner(size: IconSizeTokens.iconSizeXL),
    ],
  );
}

Widget _buildLoadingDeterminateExample(BuildContext context) {
  return const AppLoadingSpinner(
    size: 40,
    value: 0.72,
    color: ColorTokens.successDefault,
  );
}

Widget _buildLoadingInlineExample(BuildContext context) {
  return const Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      AppLoadingSpinner(size: IconSizeTokens.iconSizeM),
      SizedBox(width: SpacingTokens.spaceS),
      AppText(
        text: 'Syncing product catalog...',
        size: AppTextSize.bodyMRegular,
      ),
    ],
  );
}

List<ExampleDocEntry> buildSkeletonExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'Card placeholder', vi: 'Placeholder cho card'),
      description: LocalizedText(
        en: 'Mirror the final layout while waiting for real content.',
        vi: 'Mô phỏng bố cục cuối trong lúc chờ dữ liệu thật.',
      ),
      code:
          "Column(\n"
          "  crossAxisAlignment: CrossAxisAlignment.start,\n"
          "  children: const [\n"
          "    AppSkeleton(width: 180, height: 20),\n"
          "    SizedBox(height: 8),\n"
          "    AppSkeleton(height: 14),\n"
          "    SizedBox(height: 8),\n"
          "    AppSkeleton(width: 96, height: 14),\n"
          "  ],\n"
          ")",
      builder: _buildSkeletonCardExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Avatar and static mode',
        vi: 'Avatar và chế độ tĩnh',
      ),
      description: LocalizedText(
        en: 'Circle shape works well for avatars and logos.',
        vi: 'Shape tròn phù hợp cho avatar và logo.',
      ),
      code:
          "const Row(\n"
          "  children: [\n"
          "    AppSkeleton(width: 56, height: 56, shape: BoxShape.circle),\n"
          "    SizedBox(width: 12),\n"
          "    AppSkeleton(width: 56, height: 56, shape: BoxShape.circle, isAnimated: false),\n"
          "  ],\n"
          ")",
      builder: _buildSkeletonAvatarExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'List row placeholder',
        vi: 'Placeholder cho dòng danh sách',
      ),
      description: LocalizedText(
        en: 'Compose avatar, title, and trailing metadata placeholders to mimic dense list layouts.',
        vi: 'Ghép avatar, tiêu đề và metadata để mô phỏng các layout danh sách dày thông tin.',
      ),
      code:
          "const Row(\n"
          "  crossAxisAlignment: CrossAxisAlignment.start,\n"
          "  children: [\n"
          "    AppSkeleton(width: 44, height: 44, shape: BoxShape.circle),\n"
          "    SizedBox(width: 12),\n"
          "    Expanded(\n"
          "      child: Column(\n"
          "        crossAxisAlignment: CrossAxisAlignment.start,\n"
          "        children: [\n"
          "          AppSkeleton(width: 160, height: 16),\n"
          "          SizedBox(height: 8),\n"
          "          AppSkeleton(height: 12),\n"
          "        ],\n"
          "      ),\n"
          "    ),\n"
          "  ],\n"
          ")",
      builder: _buildSkeletonListRowExample,
    ),
  ];
}

Widget _buildSkeletonCardExample(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppSkeleton(width: 180, height: 20),
      SizedBox(height: 8),
      AppSkeleton(height: 14),
      SizedBox(height: 8),
      AppSkeleton(width: 96, height: 14),
    ],
  );
}

Widget _buildSkeletonAvatarExample(BuildContext context) {
  return const Row(
    children: [
      AppSkeleton(width: 56, height: 56, shape: BoxShape.circle),
      SizedBox(width: 12),
      AppSkeleton(
        width: 56,
        height: 56,
        shape: BoxShape.circle,
        isAnimated: false,
      ),
    ],
  );
}

Widget _buildSkeletonListRowExample(BuildContext context) {
  return const Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppSkeleton(width: 44, height: 44, shape: BoxShape.circle),
      SizedBox(width: SpacingTokens.spaceM),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSkeleton(width: 160, height: 16),
            SizedBox(height: SpacingTokens.spaceS),
            AppSkeleton(height: 12),
            SizedBox(height: SpacingTokens.spaceS),
            AppSkeleton(width: 96, height: 12),
          ],
        ),
      ),
    ],
  );
}

List<ExampleDocEntry> buildDividerExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Semantic horizontal lines',
        vi: 'Divider ngang theo semantic',
      ),
      description: LocalizedText(
        en: 'Choose a variant to communicate section status.',
        vi: 'Chọn variant để truyền tải trạng thái của section.',
      ),
      code:
          "const Column(\n"
          "  children: [\n"
          "    AppDivider(),\n"
          "    AppDivider(variant: AppDividerVariant.info),\n"
          "    AppDivider(variant: AppDividerVariant.success),\n"
          "  ],\n"
          ")",
      builder: _buildDividerHorizontalExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(en: 'Vertical separator', vi: 'Divider dọc'),
      description: LocalizedText(
        en: 'Use the vertical orientation inside dense toolbars or metadata rows.',
        vi: 'Dùng orientation dọc trong toolbar hoặc hàng metadata dày đặc.',
      ),
      code:
          "const SizedBox(\n"
          "  height: 56,\n"
          "  child: Row(\n"
          "    children: [\n"
          "      AppText(text: 'Left'),\n"
          "      SizedBox(width: 12),\n"
          "      AppDivider(orientation: AppDividerOrientation.vertical, length: 40),\n"
          "      SizedBox(width: 12),\n"
          "      AppText(text: 'Right'),\n"
          "    ],\n"
          "  ),\n"
          ")",
      builder: _buildDividerVerticalExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Sectioned card content',
        vi: 'Nội dung card chia section',
      ),
      description: LocalizedText(
        en: 'Dividers are especially useful when a card contains summary, details, and action areas.',
        vi: 'Divider đặc biệt hữu ích khi một card có phần tóm tắt, chi tiết và action.',
      ),
      code:
          "const Column(\n"
          "  crossAxisAlignment: CrossAxisAlignment.start,\n"
          "  children: [\n"
          "    AppText(text: 'Shipment overview', size: AppTextSize.bodyLBold),\n"
          "    SizedBox(height: 12),\n"
          "    AppDivider(),\n"
          "    SizedBox(height: 12),\n"
          "    AppText(text: '3 packages ready to hand over', size: AppTextSize.bodyMRegular),\n"
          "  ],\n"
          ")",
      builder: _buildDividerSectionExample,
    ),
  ];
}

Widget _buildDividerHorizontalExample(BuildContext context) {
  return const Column(
    children: [
      AppDivider(),
      SizedBox(height: 12),
      AppDivider(variant: AppDividerVariant.info),
      SizedBox(height: 12),
      AppDivider(variant: AppDividerVariant.success),
    ],
  );
}

Widget _buildDividerVerticalExample(BuildContext context) {
  return const SizedBox(
    height: 56,
    child: Row(
      children: [
        AppText(text: 'Left'),
        SizedBox(width: 12),
        AppDivider(orientation: AppDividerOrientation.vertical, length: 40),
        SizedBox(width: 12),
        AppText(text: 'Right'),
      ],
    ),
  );
}

Widget _buildDividerSectionExample(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText(text: 'Shipment overview', size: AppTextSize.bodyLBold),
      SizedBox(height: SpacingTokens.spaceM),
      AppDivider(),
      SizedBox(height: SpacingTokens.spaceM),
      AppText(
        text: '3 packages ready to hand over',
        size: AppTextSize.bodyMRegular,
      ),
      SizedBox(height: SpacingTokens.spaceS),
      AppDivider(variant: AppDividerVariant.info),
      SizedBox(height: SpacingTokens.spaceS),
      AppText(
        text: 'Courier confirmation is still pending.',
        size: AppTextSize.bodySRegular,
        color: ColorTokens.textDescription,
      ),
    ],
  );
}

List<ExampleDocEntry> buildLabelExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Required and optional states',
        vi: 'Trạng thái required và optional',
      ),
      description: LocalizedText(
        en: 'Support forms that need more context than plain text labels.',
        vi: 'Phù hợp cho form cần nhiều ngữ cảnh hơn label text thường.',
      ),
      code:
          "const Column(\n"
          "  crossAxisAlignment: CrossAxisAlignment.start,\n"
          "  children: [\n"
          "    AppLabel(text: 'Email', isRequired: true),\n"
          "    SizedBox(height: 8),\n"
          "    AppLabel(text: 'Company', isOptional: true),\n"
          "  ],\n"
          ")",
      builder: _buildLabelStatesExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(en: 'Info tooltip', vi: 'Tooltip thông tin'),
      description: LocalizedText(
        en: 'Attach helper context without breaking the form layout.',
        vi: 'Gắn thêm ngữ cảnh trợ giúp mà không phá bố cục form.',
      ),
      code:
          "const AppLabel(\n"
          "  text: 'Phone number',\n"
          "  showInfoIcon: true,\n"
          "  tooltipMessage: 'Used for order confirmation calls',\n"
          ")",
      builder: _buildLabelInfoExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(en: 'Form label stack', vi: 'Cụm label cho form'),
      description: LocalizedText(
        en: 'Use a consistent label tone across required, optional, and contextual fields in the same section.',
        vi: 'Dùng cùng một tông label cho các field required, optional và field cần thêm ngữ cảnh trong cùng section.',
      ),
      code:
          "const Column(\n"
          "  crossAxisAlignment: CrossAxisAlignment.start,\n"
          "  children: [\n"
          "    AppLabel(text: 'Store name', isRequired: true),\n"
          "    SizedBox(height: 12),\n"
          "    AppLabel(text: 'Tax code', isOptional: true),\n"
          "    SizedBox(height: 12),\n"
          "    AppLabel(text: 'Support phone', showInfoIcon: true, tooltipMessage: 'Shown on receipts'),\n"
          "  ],\n"
          ")",
      builder: _buildLabelStackExample,
    ),
  ];
}

Widget _buildLabelStatesExample(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppLabel(text: 'Email', isRequired: true),
      SizedBox(height: 8),
      AppLabel(text: 'Company', isOptional: true),
    ],
  );
}

Widget _buildLabelInfoExample(BuildContext context) {
  return const AppLabel(
    text: 'Phone number',
    showInfoIcon: true,
    tooltipMessage: 'Used for order confirmation calls',
  );
}

Widget _buildLabelStackExample(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppLabel(text: 'Store name', isRequired: true),
      SizedBox(height: SpacingTokens.spaceM),
      AppLabel(text: 'Tax code', isOptional: true),
      SizedBox(height: SpacingTokens.spaceM),
      AppLabel(
        text: 'Support phone',
        showInfoIcon: true,
        tooltipMessage: 'Shown on receipts',
      ),
    ],
  );
}

List<ExampleDocEntry> buildButtonExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'Variants and sizes', vi: 'Variant và size'),
      description: LocalizedText(
        en: 'Cover primary, outline, danger, text, and link actions.',
        vi: 'Bao phủ các action primary, outline, danger, text và link.',
      ),
      code:
          "Column(\n"
          "  crossAxisAlignment: CrossAxisAlignment.stretch,\n"
          "  children: [\n"
          "    AppButton(text: 'Primary', variant: AppButtonVariant.primary, onPressed: () {}),\n"
          "    AppButton(text: 'Outline', variant: AppButtonVariant.outline, onPressed: () {}),\n"
          "    AppButton(text: 'Danger', variant: AppButtonVariant.danger, onPressed: () {}),\n"
          "  ],\n"
          ")",
      builder: _buildButtonVariantsExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Interactive states',
        vi: 'Trạng thái tương tác',
      ),
      description: LocalizedText(
        en: 'Test loading, disabled, and live action callbacks.',
        vi: 'Thử loading, disabled và callback hành động thật.',
      ),
      code:
          "AppButton(\n"
          "  text: 'Increase count',\n"
          "  iconLeft: const Icon(Icons.add, color: ColorTokens.white),\n"
          "  onPressed: () {},\n"
          ")",
      builder: _buildButtonCounterExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Toolbar and primary CTA',
        vi: 'Toolbar và CTA chính',
      ),
      description: LocalizedText(
        en: 'Mix light-weight secondary actions with a stronger full-width submit action.',
        vi: 'Kết hợp action phụ gọn nhẹ với một CTA submit nổi bật hơn.',
      ),
      code:
          "Column(\n"
          "  crossAxisAlignment: CrossAxisAlignment.stretch,\n"
          "  children: [\n"
          "    Row(\n"
          "      children: [\n"
          "        Expanded(child: AppButton(text: 'Preview', variant: AppButtonVariant.outline, onPressed: () {})),\n"
          "        SizedBox(width: 12),\n"
          "        Expanded(child: AppButton(text: 'Save draft', variant: AppButtonVariant.text, onPressed: () {})),\n"
          "      ],\n"
          "    ),\n"
          "    SizedBox(height: 12),\n"
          "    AppButton(text: 'Publish product', isFullWidth: true, onPressed: () {}),\n"
          "  ],\n"
          ")",
      builder: _buildButtonToolbarExample,
    ),
  ];
}

Widget _buildButtonVariantsExample(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      AppButton(
        text: 'Primary medium',
        variant: AppButtonVariant.primary,
        onPressed: () {},
      ),
      const SizedBox(height: 12),
      AppButton(
        text: 'Outline small',
        size: AppButtonSize.small,
        variant: AppButtonVariant.outline,
        onPressed: () {},
      ),
      const SizedBox(height: 12),
      AppButton(
        text: 'Danger large',
        size: AppButtonSize.large,
        variant: AppButtonVariant.danger,
        onPressed: () {},
      ),
      const SizedBox(height: 12),
      AppButton(
        text: 'Text action',
        variant: AppButtonVariant.text,
        onPressed: () {},
      ),
      const SizedBox(height: 12),
      AppButton(
        text: 'Link action',
        variant: AppButtonVariant.link,
        onPressed: () {},
      ),
    ],
  );
}

class _ButtonCounterExample extends StatefulWidget {
  const _ButtonCounterExample();

  @override
  State<_ButtonCounterExample> createState() => _ButtonCounterExampleState();
}

Widget _buildButtonCounterExample(BuildContext context) =>
    const _ButtonCounterExample();

class _ButtonCounterExampleState extends State<_ButtonCounterExample> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          text: 'Increase count ($_count)',
          iconLeft: const Icon(Icons.add, color: ColorTokens.white),
          variant: AppButtonVariant.primary,
          onPressed: () => setState(() => _count += 1),
        ),
        const SizedBox(height: 12),
        const AppButton(
          text: 'Loading',
          variant: AppButtonVariant.primary,
          isLoading: true,
        ),
        const SizedBox(height: 12),
        const AppButton(
          text: 'Disabled',
          variant: AppButtonVariant.outline,
          isDisabled: true,
        ),
      ],
    );
  }
}

Widget _buildButtonToolbarExample(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Expanded(
            child: AppButton(
              text: 'Preview',
              variant: AppButtonVariant.outline,
              onPressed: () {},
            ),
          ),
          const SizedBox(width: SpacingTokens.spaceM),
          Expanded(
            child: AppButton(
              text: 'Save draft',
              variant: AppButtonVariant.text,
              onPressed: () {},
            ),
          ),
        ],
      ),
      const SizedBox(height: SpacingTokens.spaceM),
      AppButton(
        text: 'Publish product',
        variant: AppButtonVariant.primary,
        isFullWidth: true,
        onPressed: () {},
      ),
    ],
  );
}

List<ExampleDocEntry> buildCheckboxExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Standard and tristate',
        vi: 'Standard và tristate',
      ),
      description: LocalizedText(
        en: 'Handle boolean and indeterminate selection flows.',
        vi: 'Xử lý flow chọn boolean và trạng thái không xác định.',
      ),
      code:
          "AppCheckbox(\n"
          "  value: selected,\n"
          "  tristate: true,\n"
          "  label: 'Remember this device',\n"
          "  onChanged: (value) {},\n"
          ")",
      builder: _buildCheckboxInteractive,
    ),
    ExampleDocEntry(
      title: LocalizedText(en: 'Boxed and selectbox', vi: 'Boxed và selectbox'),
      description: LocalizedText(
        en: 'Use richer container variants for dense preference groups.',
        vi: 'Dùng container variant đậm hơn cho nhóm tùy chọn dày đặc.',
      ),
      code:
          "const AppCheckbox(\n"
          "  value: true,\n"
          "  variant: AppCheckboxVariant.boxed,\n"
          "  label: 'Apply stock filter',\n"
          ")",
      builder: _buildCheckboxVariantsExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Checklist with summary',
        vi: 'Checklist có tóm tắt',
      ),
      description: LocalizedText(
        en: 'A real checklist becomes clearer when the UI also reports how many tasks are complete.',
        vi: 'Checklist thực tế dễ hiểu hơn khi giao diện cũng báo có bao nhiêu mục đã hoàn tất.',
      ),
      code:
          "Column(\n"
          "  crossAxisAlignment: CrossAxisAlignment.start,\n"
          "  children: [\n"
          "    AppCheckbox(value: selected, label: 'Verify inventory', onChanged: (value) {}),\n"
          "    SizedBox(height: 12),\n"
          "    AppText(text: '2/3 steps completed', size: AppTextSize.bodySRegular),\n"
          "  ],\n"
          ")",
      builder: _buildCheckboxChecklistExample,
    ),
  ];
}

class _CheckboxInteractiveExample extends StatefulWidget {
  const _CheckboxInteractiveExample();

  @override
  State<_CheckboxInteractiveExample> createState() =>
      _CheckboxInteractiveExampleState();
}

Widget _buildCheckboxInteractive(BuildContext context) =>
    const _CheckboxInteractiveExample();

class _CheckboxInteractiveExampleState
    extends State<_CheckboxInteractiveExample> {
  bool? _remember = false;
  bool? _indeterminate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCheckbox(
          value: _remember,
          label: 'Remember this device',
          onChanged: (value) => setState(() => _remember = value),
        ),
        const SizedBox(height: 12),
        AppCheckbox(
          value: _indeterminate,
          tristate: true,
          label: 'Mixed inventory state',
          onChanged: (value) => setState(() => _indeterminate = value),
        ),
      ],
    );
  }
}

Widget _buildCheckboxVariantsExample(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppCheckbox(
        value: true,
        variant: AppCheckboxVariant.boxed,
        label: 'Apply stock filter',
      ),
      SizedBox(height: 12),
      AppCheckbox(
        value: true,
        variant: AppCheckboxVariant.selectbox,
        label: 'Default warehouse',
      ),
    ],
  );
}

class _CheckboxChecklistExample extends StatefulWidget {
  const _CheckboxChecklistExample();

  @override
  State<_CheckboxChecklistExample> createState() =>
      _CheckboxChecklistExampleState();
}

Widget _buildCheckboxChecklistExample(BuildContext context) =>
    const _CheckboxChecklistExample();

class _CheckboxChecklistExampleState extends State<_CheckboxChecklistExample> {
  bool _inventoryChecked = true;
  bool _pricingChecked = false;
  bool _imagesChecked = true;

  @override
  Widget build(BuildContext context) {
    final completed = [
      _inventoryChecked,
      _pricingChecked,
      _imagesChecked,
    ].where((value) => value).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCheckbox(
          value: _inventoryChecked,
          label: 'Verify inventory',
          onChanged: (value) =>
              setState(() => _inventoryChecked = value ?? false),
        ),
        const SizedBox(height: SpacingTokens.spaceM),
        AppCheckbox(
          value: _pricingChecked,
          label: 'Confirm pricing',
          onChanged: (value) =>
              setState(() => _pricingChecked = value ?? false),
        ),
        const SizedBox(height: SpacingTokens.spaceM),
        AppCheckbox(
          value: _imagesChecked,
          label: 'Review product images',
          onChanged: (value) => setState(() => _imagesChecked = value ?? false),
        ),
        const SizedBox(height: SpacingTokens.spaceM),
        AppText(
          text: '$completed/3 publishing checks completed',
          size: AppTextSize.bodySRegular,
          color: ColorTokens.textDescription,
        ),
      ],
    );
  }
}

List<ExampleDocEntry> buildRadioExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Single selection group',
        vi: 'Nhóm chọn một giá trị',
      ),
      description: LocalizedText(
        en: 'Bind multiple radios to the same group value.',
        vi: 'Ràng buộc nhiều radio vào cùng một group value.',
      ),
      code:
          "AppRadio<String>(\n"
          "  value: 'active',\n"
          "  groupValue: status,\n"
          "  label: 'Active',\n"
          "  onChanged: (value) {},\n"
          ")",
      builder: _buildRadioInteractive,
    ),
    ExampleDocEntry(
      title: LocalizedText(en: 'Boxed option card', vi: 'Option card boxed'),
      description: LocalizedText(
        en: 'Use boxed radio options for stronger visual affordance.',
        vi: 'Dùng radio boxed khi cần affordance trực quan mạnh hơn.',
      ),
      code:
          "AppRadio<String>(\n"
          "  value: 'pickup',\n"
          "  groupValue: 'pickup',\n"
          "  variant: AppRadioVariant.boxed,\n"
          "  label: 'Pick up at store',\n"
          ")",
      builder: _buildRadioBoxedExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Delivery method selector',
        vi: 'Bộ chọn phương thức giao hàng',
      ),
      description: LocalizedText(
        en: 'Grouped radios are a good fit when the user must choose exactly one operational path.',
        vi: 'Radio group phù hợp khi người dùng bắt buộc phải chọn đúng một hướng xử lý.',
      ),
      code:
          "Column(\n"
          "  crossAxisAlignment: CrossAxisAlignment.start,\n"
          "  children: [\n"
          "    AppRadio<String>(value: 'pickup', groupValue: method, variant: AppRadioVariant.boxed, label: 'Pick up at store', onChanged: (value) {}),\n"
          "    SizedBox(height: 12),\n"
          "    AppRadio<String>(value: 'delivery', groupValue: method, variant: AppRadioVariant.boxed, label: 'Ship to customer', onChanged: (value) {}),\n"
          "  ],\n"
          ")",
      builder: _buildRadioDeliveryExample,
    ),
  ];
}

class _RadioInteractiveExample extends StatefulWidget {
  const _RadioInteractiveExample();

  @override
  State<_RadioInteractiveExample> createState() =>
      _RadioInteractiveExampleState();
}

Widget _buildRadioInteractive(BuildContext context) =>
    const _RadioInteractiveExample();

class _RadioInteractiveExampleState extends State<_RadioInteractiveExample> {
  String _status = 'active';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppRadio<String>(
          value: 'active',
          groupValue: _status,
          label: 'Active',
          onChanged: (value) => setState(() => _status = value ?? _status),
        ),
        const SizedBox(height: 12),
        AppRadio<String>(
          value: 'paused',
          groupValue: _status,
          label: 'Paused',
          onChanged: (value) => setState(() => _status = value ?? _status),
        ),
      ],
    );
  }
}

Widget _buildRadioBoxedExample(BuildContext context) {
  return AppRadio<String>(
    value: 'pickup',
    groupValue: 'pickup',
    variant: AppRadioVariant.boxed,
    label: 'Pick up at store',
    onChanged: (_) {},
  );
}

class _RadioDeliveryExample extends StatefulWidget {
  const _RadioDeliveryExample();

  @override
  State<_RadioDeliveryExample> createState() => _RadioDeliveryExampleState();
}

Widget _buildRadioDeliveryExample(BuildContext context) =>
    const _RadioDeliveryExample();

class _RadioDeliveryExampleState extends State<_RadioDeliveryExample> {
  String _method = 'pickup';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppRadio<String>(
          value: 'pickup',
          groupValue: _method,
          variant: AppRadioVariant.boxed,
          label: 'Pick up at store',
          onChanged: (value) => setState(() => _method = value ?? _method),
        ),
        const SizedBox(height: SpacingTokens.spaceM),
        AppRadio<String>(
          value: 'delivery',
          groupValue: _method,
          variant: AppRadioVariant.boxed,
          label: 'Ship to customer',
          onChanged: (value) => setState(() => _method = value ?? _method),
        ),
        const SizedBox(height: SpacingTokens.spaceM),
        AppText(
          text: 'Selected method: $_method',
          size: AppTextSize.bodySRegular,
          color: ColorTokens.textDescription,
        ),
      ],
    );
  }
}

List<ExampleDocEntry> buildSwitchExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'Interactive toggle', vi: 'Toggle tương tác'),
      description: LocalizedText(
        en: 'Switch works well for preferences with immediate effect.',
        vi: 'Switch phù hợp cho preference có hiệu lực ngay.',
      ),
      code:
          "AppSwitch(\n"
          "  value: enabled,\n"
          "  label: 'Enable notifications',\n"
          "  onChanged: (value) {},\n"
          ")",
      builder: _buildSwitchInteractive,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Sizes and disabled state',
        vi: 'Size và disabled',
      ),
      description: LocalizedText(
        en: 'Use smaller tracks in tables and denser setting panes.',
        vi: 'Dùng track nhỏ hơn trong bảng và màn hình setting dày hơn.',
      ),
      code:
          "const Column(\n"
          "  children: [\n"
          "    AppSwitch(value: true, size: AppSwitchSize.small),\n"
          "    AppSwitch(value: false, size: AppSwitchSize.large, isDisabled: true),\n"
          "  ],\n"
          ")",
      builder: _buildSwitchVariantsExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Preference panel',
        vi: 'Cụm cài đặt preference',
      ),
      description: LocalizedText(
        en: 'Switches are especially readable when paired with short setting labels and a live summary.',
        vi: 'Switch dễ đọc hơn khi đi cùng label ngắn cho cài đặt và một phần tóm tắt trạng thái hiện tại.',
      ),
      code:
          "Column(\n"
          "  crossAxisAlignment: CrossAxisAlignment.start,\n"
          "  children: [\n"
          "    AppSwitch(value: marketing, label: 'Marketing emails', onChanged: (value) {}),\n"
          "    SizedBox(height: 12),\n"
          "    AppSwitch(value: sms, label: 'SMS alerts', onChanged: (value) {}),\n"
          "  ],\n"
          ")",
      builder: _buildSwitchPreferenceExample,
    ),
  ];
}

class _SwitchInteractiveExample extends StatefulWidget {
  const _SwitchInteractiveExample();

  @override
  State<_SwitchInteractiveExample> createState() =>
      _SwitchInteractiveExampleState();
}

Widget _buildSwitchInteractive(BuildContext context) =>
    const _SwitchInteractiveExample();

class _SwitchInteractiveExampleState extends State<_SwitchInteractiveExample> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return AppSwitch(
      value: _enabled,
      label: 'Enable notifications',
      onChanged: (value) => setState(() => _enabled = value),
    );
  }
}

Widget _buildSwitchVariantsExample(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppSwitch(value: true, size: AppSwitchSize.small, label: 'Compact'),
      SizedBox(height: 12),
      AppSwitch(
        value: false,
        size: AppSwitchSize.large,
        isDisabled: true,
        label: 'Disabled',
      ),
    ],
  );
}

class _SwitchPreferenceExample extends StatefulWidget {
  const _SwitchPreferenceExample();

  @override
  State<_SwitchPreferenceExample> createState() =>
      _SwitchPreferenceExampleState();
}

Widget _buildSwitchPreferenceExample(BuildContext context) =>
    const _SwitchPreferenceExample();

class _SwitchPreferenceExampleState extends State<_SwitchPreferenceExample> {
  bool _marketing = true;
  bool _sms = false;
  bool _push = true;

  @override
  Widget build(BuildContext context) {
    final enabledCount = [
      _marketing,
      _sms,
      _push,
    ].where((value) => value).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSwitch(
          value: _marketing,
          label: 'Marketing emails',
          onChanged: (value) => setState(() => _marketing = value),
        ),
        const SizedBox(height: SpacingTokens.spaceM),
        AppSwitch(
          value: _sms,
          label: 'SMS alerts',
          onChanged: (value) => setState(() => _sms = value),
        ),
        const SizedBox(height: SpacingTokens.spaceM),
        AppSwitch(
          value: _push,
          label: 'Push notifications',
          onChanged: (value) => setState(() => _push = value),
        ),
        const SizedBox(height: SpacingTokens.spaceM),
        AppText(
          text: '$enabledCount/3 notification channels enabled',
          size: AppTextSize.bodySRegular,
          color: ColorTokens.textDescription,
        ),
      ],
    );
  }
}

List<ExampleDocEntry> buildTextFieldExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Variants and adornments',
        vi: 'Variant và adornment',
      ),
      description: LocalizedText(
        en: 'Mix helper text, icons, prefix, suffix, and semantic variants.',
        vi: 'Kết hợp helper text, icon, prefix, suffix và variant semantic.',
      ),
      code:
          "AppTextField(\n"
          "  labelText: 'Customer name',\n"
          "  hintText: 'Enter customer name',\n"
          "  prefixIcon: const Icon(Icons.person_outline),\n"
          "  suffixIcon: const Icon(Icons.info_outline),\n"
          "  helperText: 'Used on printed invoices',\n"
          ")",
      builder: _buildTextFieldVariantsExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(en: 'Validation state', vi: 'Trạng thái validate'),
      description: LocalizedText(
        en: 'Validation errors appear from the validate callback.',
        vi: 'Lỗi validate được hiển thị từ callback validate.',
      ),
      code:
          "AppTextField(\n"
          "  labelText: 'Email',\n"
          "  validate: (value) => value.contains('@') ? null : 'Invalid email',\n"
          ")",
      builder: _buildTextFieldValidation,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Structured form input',
        vi: 'Input form có cấu trúc',
      ),
      description: LocalizedText(
        en: 'Prefix and suffix slots help communicate units, codes, and constrained input formats.',
        vi: 'Các slot prefix và suffix giúp diễn đạt đơn vị tính, mã và định dạng nhập liệu có ràng buộc.',
      ),
      code:
          "const Column(\n"
          "  children: [\n"
          "    AppTextField(\n"
          "      labelText: 'Invoice code',\n"
          "      prefix: AppText(text: '#'),\n"
          "      hintText: 'INV-2026-001',\n"
          "    ),\n"
          "    SizedBox(height: 12),\n"
          "    AppTextField(\n"
          "      labelText: 'Amount',\n"
          "      prefix: AppText(text: 'VND'),\n"
          "      suffix: AppText(text: '.000'),\n"
          "      hintText: '250',\n"
          "    ),\n"
          "  ],\n"
          ")",
      builder: _buildTextFieldStructuredExample,
    ),
  ];
}

Widget _buildTextFieldVariantsExample(BuildContext context) {
  return const Column(
    children: [
      AppTextField(
        labelText: 'Customer name',
        hintText: 'Enter customer name',
        prefixIcon: Icon(Icons.person_outline),
        suffixIcon: Icon(Icons.info_outline),
        helperText: 'Used on printed invoices',
      ),
      SizedBox(height: 12),
      AppTextField(
        labelText: 'Recovery phone',
        hintText: 'Add phone number',
        variant: AppTextFieldVariant.warning,
        prefix: AppText(text: '+84'),
        size: AppTextFieldSize.large,
      ),
    ],
  );
}

class _TextFieldValidationExample extends StatefulWidget {
  const _TextFieldValidationExample();

  @override
  State<_TextFieldValidationExample> createState() =>
      _TextFieldValidationExampleState();
}

Widget _buildTextFieldValidation(BuildContext context) =>
    const _TextFieldValidationExample();

class _TextFieldValidationExampleState
    extends State<_TextFieldValidationExample> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          labelText: 'Email',
          hintText: 'your@company.com',
          onChanged: (value) => setState(() => _value = value),
          validate: (value) =>
              value.contains('@') ? null : 'Invalid email format',
        ),
        const SizedBox(height: 12),
        AppText(
          text: 'Current value: ${_value.isEmpty ? '(empty)' : _value}',
          size: AppTextSize.bodySRegular,
          color: ColorTokens.textDescription,
        ),
      ],
    );
  }
}

Widget _buildTextFieldStructuredExample(BuildContext context) {
  return const Column(
    children: [
      AppTextField(
        labelText: 'Invoice code',
        prefix: AppText(text: '#'),
        hintText: 'INV-2026-001',
      ),
      SizedBox(height: SpacingTokens.spaceM),
      AppTextField(
        labelText: 'Amount',
        prefix: AppText(text: 'VND'),
        suffix: AppText(text: '.000'),
        hintText: '250',
      ),
    ],
  );
}

List<ExampleDocEntry> buildPasswordFieldExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'Visibility toggle', vi: 'Ẩn hiện mật khẩu'),
      description: LocalizedText(
        en: 'AppPasswordField wraps AppTextField with password-specific UX.',
        vi: 'AppPasswordField bọc AppTextField với UX riêng cho mật khẩu.',
      ),
      code:
          "AppPasswordField(\n"
          "  labelText: 'Password',\n"
          "  hintText: 'Enter your password',\n"
          "  helperText: 'At least 8 characters',\n"
          ")",
      builder: _buildPasswordFieldExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(en: 'Validation feedback', vi: 'Phản hồi validate'),
      description: LocalizedText(
        en: 'Keep visibility toggle while still showing validation state.',
        vi: 'Vẫn giữ toggle ẩn hiện trong khi hiển thị validate.',
      ),
      code:
          "AppPasswordField(\n"
          "  labelText: 'New password',\n"
          "  validate: (value) => value.length < 8 ? 'Minimum 8 characters' : null,\n"
          ")",
      builder: _buildPasswordValidationExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Strength guidance',
        vi: 'Gợi ý độ mạnh mật khẩu',
      ),
      description: LocalizedText(
        en: 'A small live summary helps readers understand how to pair the field with adjacent helper logic.',
        vi: 'Một phần tóm tắt nhỏ giúp người đọc hiểu cách ghép field với logic trợ giúp đi kèm.',
      ),
      code:
          "AppPasswordField(\n"
          "  labelText: 'Create password',\n"
          "  helperText: 'Use at least 8 characters',\n"
          "  onChanged: (value) {},\n"
          ")",
      builder: _buildPasswordStrengthExample,
    ),
  ];
}

Widget _buildPasswordFieldExample(BuildContext context) {
  return const AppPasswordField(
    labelText: 'Password',
    hintText: 'Enter your password',
    helperText: 'At least 8 characters',
  );
}

Widget _buildPasswordValidationExample(BuildContext context) {
  return AppPasswordField(
    labelText: 'New password',
    validate: (value) =>
        value.length < 8 ? 'Minimum 8 characters required' : null,
  );
}

class _PasswordStrengthExample extends StatefulWidget {
  const _PasswordStrengthExample();

  @override
  State<_PasswordStrengthExample> createState() =>
      _PasswordStrengthExampleState();
}

Widget _buildPasswordStrengthExample(BuildContext context) =>
    const _PasswordStrengthExample();

class _PasswordStrengthExampleState extends State<_PasswordStrengthExample> {
  String _value = '';

  String get _strengthLabel {
    if (_value.length >= 10) return 'Strong';
    if (_value.length >= 6) return 'Medium';
    return 'Weak';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppPasswordField(
          labelText: 'Create password',
          helperText: 'Use at least 8 characters',
          onChanged: (value) => setState(() => _value = value),
        ),
        const SizedBox(height: SpacingTokens.spaceM),
        AppText(
          text: 'Strength: $_strengthLabel',
          size: AppTextSize.bodySRegular,
          color: ColorTokens.textDescription,
        ),
      ],
    );
  }
}

List<ExampleDocEntry> buildSearchFieldExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Debounced search callback',
        vi: 'Callback search có debounce',
      ),
      description: LocalizedText(
        en: 'Use onSearchChanged to trigger remote queries after a short delay.',
        vi: 'Dùng onSearchChanged để gọi truy vấn remote sau một khoảng delay ngắn.',
      ),
      code:
          "AppSearchField(\n"
          "  hintText: 'Search products',\n"
          "  onSearchChanged: (value) {},\n"
          ")",
      builder: _buildSearchFieldLiveExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Local result filtering',
        vi: 'Lọc kết quả local',
      ),
      description: LocalizedText(
        en: 'This pattern shows how the debounced field can still drive a simple local results list.',
        vi: 'Pattern này cho thấy field có debounce vẫn có thể điều khiển một danh sách kết quả local rất gọn.',
      ),
      code:
          "Column(\n"
          "  crossAxisAlignment: CrossAxisAlignment.start,\n"
          "  children: [\n"
          "    AppSearchField(hintText: 'Search warehouses', onChanged: (value) {}),\n"
          "    SizedBox(height: 12),\n"
          "    AppText(text: 'Filtered results appear below', size: AppTextSize.bodySRegular),\n"
          "  ],\n"
          ")",
      builder: _buildSearchFieldFilterExample,
    ),
  ];
}

class _SearchFieldExample extends StatefulWidget {
  const _SearchFieldExample();

  @override
  State<_SearchFieldExample> createState() => _SearchFieldExampleState();
}

Widget _buildSearchFieldLiveExample(BuildContext context) =>
    const _SearchFieldExample();

class _SearchFieldExampleState extends State<_SearchFieldExample> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSearchField(
          hintText: 'Search products',
          onSearchChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: 12),
        AppText(
          text:
              'Latest debounced query: ${_query.isEmpty ? '(empty)' : _query}',
          size: AppTextSize.bodySRegular,
          color: ColorTokens.textDescription,
        ),
      ],
    );
  }
}

class _SearchFieldFilterExample extends StatefulWidget {
  const _SearchFieldFilterExample();

  @override
  State<_SearchFieldFilterExample> createState() =>
      _SearchFieldFilterExampleState();
}

Widget _buildSearchFieldFilterExample(BuildContext context) =>
    const _SearchFieldFilterExample();

class _SearchFieldFilterExampleState extends State<_SearchFieldFilterExample> {
  static const _allWarehouses = [
    'North Hub',
    'Central Storage',
    'South Dispatch',
    'Returns Room',
  ];

  String _keyword = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _allWarehouses
        .where(
          (item) => item.toLowerCase().contains(_keyword.trim().toLowerCase()),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSearchField(
          hintText: 'Search warehouses',
          onChanged: (value) => setState(() => _keyword = value),
        ),
        const SizedBox(height: SpacingTokens.spaceM),
        for (final item in filtered)
          Padding(
            padding: const EdgeInsets.only(bottom: SpacingTokens.spaceS),
            child: AppText(
              text: item,
              size: AppTextSize.bodySRegular,
              color: ColorTokens.textDefault,
            ),
          ),
        if (filtered.isEmpty)
          const AppText(
            text: 'No local matches',
            size: AppTextSize.bodySRegular,
            color: ColorTokens.textDescription,
          ),
      ],
    );
  }
}

List<ExampleDocEntry> buildOtpExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'OTP entry flow', vi: 'Flow nhập OTP'),
      description: LocalizedText(
        en: 'The widget sanitizes digits and reports completion when full.',
        vi: 'Widget tự lọc digit và báo hoàn tất khi nhập đủ.',
      ),
      code:
          "AppOtpField(\n"
          "  onChanged: (value) {},\n"
          "  onCompleted: (value) {},\n"
          ")",
      builder: _buildOtpFieldLiveExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Custom length and reset',
        vi: 'Độ dài tùy chỉnh và reset',
      ),
      description: LocalizedText(
        en: 'This example helps readers see how to control the OTP value from outside the field.',
        vi: 'Ví dụ này giúp người đọc thấy cách điều khiển giá trị OTP từ bên ngoài field.',
      ),
      code:
          "final controller = TextEditingController();\n"
          "\n"
          "Column(\n"
          "  crossAxisAlignment: CrossAxisAlignment.start,\n"
          "  children: [\n"
          "    AppOtpField(length: 4, controller: controller),\n"
          "    SizedBox(height: 12),\n"
          "    AppButton(text: 'Reset OTP', onPressed: () => controller.clear()),\n"
          "  ],\n"
          ")",
      builder: _buildOtpResetExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Disabled OTP state',
        vi: 'OTP ở trạng thái disabled',
      ),
      description: LocalizedText(
        en: 'Use the disabled state while waiting for a resend timer or external verification step.',
        vi: 'Dùng trạng thái disabled khi đang chờ bộ đếm resend hoặc một bước xác thực bên ngoài.',
      ),
      code: "const AppOtpField(isDisabled: true)",
      builder: _buildOtpDisabledExample,
    ),
  ];
}

class _OtpFieldExample extends StatefulWidget {
  const _OtpFieldExample();

  @override
  State<_OtpFieldExample> createState() => _OtpFieldExampleState();
}

Widget _buildOtpFieldLiveExample(BuildContext context) =>
    const _OtpFieldExample();

class _OtpFieldExampleState extends State<_OtpFieldExample> {
  String _otp = '';
  String _completed = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppOtpField(
          onChanged: (value) => setState(() => _otp = value),
          onCompleted: (value) => setState(() => _completed = value),
        ),
        const SizedBox(height: 12),
        AppText(
          text: 'Current OTP: ${_otp.isEmpty ? '(empty)' : _otp}',
          size: AppTextSize.bodySRegular,
          color: ColorTokens.textDescription,
        ),
        const SizedBox(height: 4),
        AppText(
          text: 'Completed: ${_completed.isEmpty ? 'No' : _completed}',
          size: AppTextSize.bodySRegular,
          color: ColorTokens.textDescription,
        ),
      ],
    );
  }
}

class _OtpResetExample extends StatefulWidget {
  const _OtpResetExample();

  @override
  State<_OtpResetExample> createState() => _OtpResetExampleState();
}

Widget _buildOtpResetExample(BuildContext context) => const _OtpResetExample();

class _OtpResetExampleState extends State<_OtpResetExample> {
  final TextEditingController _controller = TextEditingController(text: '12');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppOtpField(length: 4, controller: _controller),
        const SizedBox(height: SpacingTokens.spaceM),
        AppButton(
          text: 'Reset OTP',
          size: AppButtonSize.small,
          variant: AppButtonVariant.outline,
          onPressed: () => _controller.clear(),
        ),
      ],
    );
  }
}

Widget _buildOtpDisabledExample(BuildContext context) {
  return const AppOtpField(isDisabled: true);
}

List<ExampleDocEntry> buildDateTimeExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'Date selection', vi: 'Chọn ngày'),
      description: LocalizedText(
        en: 'Use the field for form-driven date selection with tokenized styling.',
        vi: 'Dùng field này cho flow chọn ngày trong form với style theo token.',
      ),
      code:
          "AppDateTimeField(\n"
          "  mode: AppDateTimeFieldMode.date,\n"
          "  labelText: 'Delivery date',\n"
          "  hintText: 'Select date',\n"
          "  onChanged: (value) {},\n"
          ")",
      builder: _buildDateFieldLiveExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(en: 'Time selection', vi: 'Chọn giờ'),
      description: LocalizedText(
        en: 'Time-only mode keeps the same visual language as text inputs.',
        vi: 'Mode chọn giờ giữ cùng ngôn ngữ hiển thị với text input.',
      ),
      code:
          "AppDateTimeField(\n"
          "  mode: AppDateTimeFieldMode.time,\n"
          "  labelText: 'Cut-off time',\n"
          "  onTimeChanged: (value) {},\n"
          ")",
      builder: _buildTimeFieldLiveExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Date-time appointment',
        vi: 'Lịch hẹn ngày-giờ',
      ),
      description: LocalizedText(
        en: 'Date-time mode is useful for booking flows where the date and hour belong to the same action.',
        vi: 'Mode ngày-giờ phù hợp cho flow đặt lịch khi ngày và giờ thuộc cùng một hành động.',
      ),
      code:
          "AppDateTimeField(\n"
          "  mode: AppDateTimeFieldMode.dateTime,\n"
          "  labelText: 'Pickup slot',\n"
          "  hintText: 'Choose date and time',\n"
          "  onChanged: (value) {},\n"
          ")",
      builder: _buildDateTimeAppointmentExample,
    ),
  ];
}

class _DateTimeFieldExample extends StatefulWidget {
  const _DateTimeFieldExample();

  @override
  State<_DateTimeFieldExample> createState() => _DateTimeFieldExampleState();
}

Widget _buildDateFieldLiveExample(BuildContext context) =>
    const _DateTimeFieldExample();

class _DateTimeFieldExampleState extends State<_DateTimeFieldExample> {
  DateTime? _date;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDateTimeField(
          mode: AppDateTimeFieldMode.date,
          labelText: 'Delivery date',
          hintText: 'Select date',
          onChanged: (value) => setState(() => _date = value),
        ),
        const SizedBox(height: 12),
        AppText(
          text: _date == null
              ? 'No date selected'
              : 'Selected: ${_date!.toIso8601String().split('T').first}',
          size: AppTextSize.bodySRegular,
          color: ColorTokens.textDescription,
        ),
      ],
    );
  }
}

class _TimeFieldExample extends StatefulWidget {
  const _TimeFieldExample();

  @override
  State<_TimeFieldExample> createState() => _TimeFieldExampleState();
}

Widget _buildTimeFieldLiveExample(BuildContext context) =>
    const _TimeFieldExample();

class _TimeFieldExampleState extends State<_TimeFieldExample> {
  TimeOfDay? _time;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDateTimeField(
          mode: AppDateTimeFieldMode.time,
          labelText: 'Cut-off time',
          onTimeChanged: (value) => setState(() => _time = value),
        ),
        const SizedBox(height: 12),
        AppText(
          text: _time == null
              ? 'No time selected'
              : 'Selected: ${_time!.format(context)}',
          size: AppTextSize.bodySRegular,
          color: ColorTokens.textDescription,
        ),
      ],
    );
  }
}

class _DateTimeAppointmentExample extends StatefulWidget {
  const _DateTimeAppointmentExample();

  @override
  State<_DateTimeAppointmentExample> createState() =>
      _DateTimeAppointmentExampleState();
}

Widget _buildDateTimeAppointmentExample(BuildContext context) =>
    const _DateTimeAppointmentExample();

class _DateTimeAppointmentExampleState
    extends State<_DateTimeAppointmentExample> {
  DateTime? _appointment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDateTimeField(
          mode: AppDateTimeFieldMode.dateTime,
          labelText: 'Pickup slot',
          hintText: 'Choose date and time',
          helperText: 'Useful for pickup, delivery, or appointment flows.',
          onChanged: (value) => setState(() => _appointment = value),
        ),
        const SizedBox(height: SpacingTokens.spaceM),
        AppText(
          text: _appointment == null
              ? 'No appointment selected'
              : 'Selected: ${_appointment!.toLocal()}',
          size: AppTextSize.bodySRegular,
          color: ColorTokens.textDescription,
        ),
      ],
    );
  }
}

List<ExampleDocEntry> buildDropdownExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'Local filter', vi: 'Lọc local'),
      description: LocalizedText(
        en: 'Search directly inside a small local list.',
        vi: 'Tìm kiếm trực tiếp trong danh sách local nhỏ.',
      ),
      code:
          "AppDropdown<String>(\n"
          "  items: statuses,\n"
          "  value: selected,\n"
          "  hintText: 'Choose status',\n"
          "  itemAsString: (item) => item,\n"
          "  onChanged: (value) {},\n"
          "  isSearchable: true,\n"
          ")",
      builder: _buildDropdownLocalExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(en: 'Async states', vi: 'Các trạng thái async'),
      description: LocalizedText(
        en: 'Simulate remote search, loading, and pagination states.',
        vi: 'Mô phỏng search remote, loading và phân trang.',
      ),
      code:
          "AppDropdown<String>(\n"
          "  items: remoteItems,\n"
          "  value: selected,\n"
          "  hintText: 'Choose warehouse',\n"
          "  itemAsString: (item) => item,\n"
          "  onChanged: (value) {},\n"
          "  isSearchable: true,\n"
          "  enableLocalFilter: false,\n"
          "  onSearchChanged: (value) {},\n"
          ")",
      builder: _buildDropdownAsyncExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Object mapping example',
        vi: 'Ví dụ map dữ liệu object',
      ),
      description: LocalizedText(
        en: 'Readers often need to bind dropdowns to models, not raw strings, so this example keeps the selected object intact.',
        vi: 'Người đọc thường phải bind dropdown với model thay vì string thuần, nên ví dụ này giữ nguyên object đã chọn.',
      ),
      code:
          "AppDropdown<_DropdownUser>(\n"
          "  items: users,\n"
          "  value: selectedUser,\n"
          "  hintText: 'Assign approver',\n"
          "  itemAsString: (item) => item.name,\n"
          "  onChanged: (value) {},\n"
          ")",
      builder: _buildDropdownObjectExample,
    ),
  ];
}

class _DropdownLocalExample extends StatefulWidget {
  const _DropdownLocalExample();

  @override
  State<_DropdownLocalExample> createState() => _DropdownLocalExampleState();
}

Widget _buildDropdownLocalExample(BuildContext context) =>
    const _DropdownLocalExample();

class _DropdownLocalExampleState extends State<_DropdownLocalExample> {
  final List<String> _statuses = const [
    'Pending',
    'Packing',
    'Ready to ship',
    'Delivered',
    'Returned',
  ];
  String? _selected = 'Pending';

  @override
  Widget build(BuildContext context) {
    return AppDropdown<String>(
      items: _statuses,
      value: _selected,
      hintText: 'Choose status',
      itemAsString: (item) => item,
      onChanged: (value) => setState(() => _selected = value),
      isSearchable: true,
    );
  }
}

class _DropdownAsyncExample extends StatefulWidget {
  const _DropdownAsyncExample();

  @override
  State<_DropdownAsyncExample> createState() => _DropdownAsyncExampleState();
}

Widget _buildDropdownAsyncExample(BuildContext context) =>
    const _DropdownAsyncExample();

class _DropdownAsyncExampleState extends State<_DropdownAsyncExample> {
  List<String> _items = const ['Ha Noi', 'Ho Chi Minh City', 'Da Nang'];
  String? _selected;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _lastKeyword;

  Future<void> _simulateSearch(String keyword) async {
    setState(() {
      _isLoading = true;
      _lastKeyword = keyword;
    });
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    setState(() {
      _items = [
        'Warehouse ${keyword.isEmpty ? 'North' : keyword} A',
        'Warehouse ${keyword.isEmpty ? 'Central' : keyword} B',
        'Warehouse ${keyword.isEmpty ? 'South' : keyword} C',
      ];
      _isLoading = false;
    });
  }

  Future<void> _simulateLoadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    setState(() {
      _items = [..._items, 'Warehouse Extension 1', 'Warehouse Extension 2'];
      _isLoadingMore = false;
      _hasMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDropdown<String>(
          items: _items,
          value: _selected,
          hintText: 'Choose warehouse',
          itemAsString: (item) => item,
          onChanged: (value) => setState(() => _selected = value),
          isSearchable: true,
          enableLocalFilter: false,
          isLoading: _isLoading,
          isLoadingMore: _isLoadingMore,
          hasMore: _hasMore,
          onLoadMore: _simulateLoadMore,
          onSearchChanged: _simulateSearch,
        ),
        const SizedBox(height: 12),
        AppText(
          text:
              'Last remote keyword: ${_lastKeyword == null || _lastKeyword!.isEmpty ? '(empty)' : _lastKeyword}',
          size: AppTextSize.bodySRegular,
          color: ColorTokens.textDescription,
        ),
      ],
    );
  }
}

class _DropdownUser {
  final int id;
  final String name;
  final String role;

  const _DropdownUser({
    required this.id,
    required this.name,
    required this.role,
  });

  @override
  bool operator ==(Object other) {
    return other is _DropdownUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class _DropdownObjectExample extends StatefulWidget {
  const _DropdownObjectExample();

  @override
  State<_DropdownObjectExample> createState() => _DropdownObjectExampleState();
}

Widget _buildDropdownObjectExample(BuildContext context) =>
    const _DropdownObjectExample();

class _DropdownObjectExampleState extends State<_DropdownObjectExample> {
  final List<_DropdownUser> _users = const [
    _DropdownUser(id: 1, name: 'Lan Anh', role: 'Store manager'),
    _DropdownUser(id: 2, name: 'Minh Quan', role: 'Area supervisor'),
    _DropdownUser(id: 3, name: 'Thao Vy', role: 'Finance reviewer'),
  ];

  _DropdownUser? _selectedUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDropdown<_DropdownUser>(
          items: _users,
          value: _selectedUser,
          hintText: 'Assign approver',
          labelText: 'Approver',
          itemAsString: (item) => '${item.name} - ${item.role}',
          onChanged: (value) => setState(() => _selectedUser = value),
          isSearchable: true,
        ),
        const SizedBox(height: SpacingTokens.spaceM),
        AppText(
          text: _selectedUser == null
              ? 'No approver selected'
              : 'Selected approver: ${_selectedUser!.name}',
          size: AppTextSize.bodySRegular,
          color: ColorTokens.textDescription,
        ),
      ],
    );
  }
}

List<ExampleDocEntry> buildBottomSheetSelectExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Single choice field',
        vi: 'Field chọn một giá trị',
      ),
      description: LocalizedText(
        en: 'Keep the compact field trigger while opening choices in a bottom sheet.',
        vi: 'Giữ trigger gọn dạng field nhưng mở danh sách chọn trong bottom sheet.',
      ),
      code:
          "AppBottomSheetSelect<String>.single(\n"
          "  labelText: 'Tax method',\n"
          "  hintText: 'Choose tax method',\n"
          "  items: methods,\n"
          "  value: selectedMethod,\n"
          "  itemAsString: (item) => item,\n"
          "  onChanged: (next) {},\n"
          "  isSearchable: true,\n"
          ")",
      builder: _buildBottomSheetSelectSingleExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Multi choice and remote states',
        vi: 'Multi choice và trạng thái remote',
      ),
      description: LocalizedText(
        en: 'Combine multi-select summaries with remote search and incremental loading.',
        vi: 'Kết hợp tóm tắt multi-select với remote search và nạp thêm dữ liệu.',
      ),
      code:
          "AppBottomSheetSelect<String>.multi(\n"
          "  labelText: 'Labels',\n"
          "  hintText: 'Choose labels',\n"
          "  items: labels,\n"
          "  values: selectedLabels,\n"
          "  itemAsString: (item) => item,\n"
          "  onChanged: (values) {},\n"
          ")",
      builder: _buildBottomSheetSelectAdvancedExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Custom selection summary',
        vi: 'Tóm tắt lựa chọn tùy chỉnh',
      ),
      description: LocalizedText(
        en: 'The selectedItemsTextBuilder callback is useful when the trigger should stay compact after many selections.',
        vi: 'Callback selectedItemsTextBuilder hữu ích khi trigger cần gọn dù người dùng chọn nhiều giá trị.',
      ),
      code:
          "AppBottomSheetSelect<String>.multi(\n"
          "  labelText: 'Audience tags',\n"
          "  hintText: 'Choose tags',\n"
          "  items: tags,\n"
          "  values: selectedTags,\n"
          "  itemAsString: (item) => item,\n"
          "  selectedItemsTextBuilder: (values) => '\${values.length} tags selected',\n"
          "  onChanged: (values) {},\n"
          ")",
      builder: _buildBottomSheetSelectSummaryExample,
    ),
  ];
}

class _BottomSheetSelectSingleExample extends StatefulWidget {
  const _BottomSheetSelectSingleExample();

  @override
  State<_BottomSheetSelectSingleExample> createState() =>
      _BottomSheetSelectSingleExampleState();
}

Widget _buildBottomSheetSelectSingleExample(BuildContext context) =>
    const _BottomSheetSelectSingleExample();

class _BottomSheetSelectSingleExampleState
    extends State<_BottomSheetSelectSingleExample> {
  final List<String> _methods = const ['Direct', 'Deduction', 'Mixed'];
  String? _selectedMethod = 'Direct';

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetSelect<String>.single(
      labelText: 'Tax method',
      hintText: 'Choose tax method',
      helperText: 'Useful when options need more room than a dropdown menu.',
      items: _methods,
      value: _selectedMethod,
      itemAsString: (item) => item,
      onChanged: (next) => setState(() => _selectedMethod = next),
      isSearchable: true,
      sheetTitle: 'Tax method',
      sheetDescription: 'Choose how the document calculates tax.',
    );
  }
}

class _BottomSheetSelectAdvancedExample extends StatefulWidget {
  const _BottomSheetSelectAdvancedExample();

  @override
  State<_BottomSheetSelectAdvancedExample> createState() =>
      _BottomSheetSelectAdvancedExampleState();
}

Widget _buildBottomSheetSelectAdvancedExample(BuildContext context) =>
    const _BottomSheetSelectAdvancedExample();

class _BottomSheetSelectAdvancedExampleState
    extends State<_BottomSheetSelectAdvancedExample> {
  static const _pageSize = 8;

  final List<String> _labels = const ['Urgent', 'VIP', 'Wholesale', 'Online'];
  final List<_RemoteWarehouse> _allWarehouses = List.generate(
    24,
    (index) => _RemoteWarehouse(
      id: index + 1,
      title: 'Warehouse ${index + 1}',
      description: 'Service area ${index % 4 + 1}',
    ),
  );

  List<String> _selectedLabels = const ['VIP'];
  _RemoteWarehouse? _selectedWarehouse;
  List<_RemoteWarehouse> _visibleWarehouses = <_RemoteWarehouse>[];
  bool _isLoadingWarehouses = false;
  bool _isLoadingMoreWarehouses = false;
  bool _hasMoreWarehouses = true;
  String _lastKeyword = '';

  @override
  void initState() {
    super.initState();
    _searchWarehouses('');
  }

  Future<void> _searchWarehouses(
    String keyword, {
    bool loadMore = false,
  }) async {
    final normalizedKeyword = keyword.trim().toLowerCase();

    setState(() {
      _lastKeyword = keyword;
      if (loadMore) {
        _isLoadingMoreWarehouses = true;
      } else {
        _isLoadingWarehouses = true;
      }
    });

    await Future<void>.delayed(const Duration(milliseconds: 350));

    final filtered = _allWarehouses.where((warehouse) {
      return warehouse.title.toLowerCase().contains(normalizedKeyword) ||
          warehouse.description.toLowerCase().contains(normalizedKeyword);
    }).toList();

    final nextCount = loadMore
        ? (_visibleWarehouses.length + _pageSize).clamp(0, filtered.length)
        : _pageSize.clamp(0, filtered.length);

    if (!mounted) return;

    setState(() {
      _visibleWarehouses = filtered.take(nextCount).toList();
      _isLoadingWarehouses = false;
      _isLoadingMoreWarehouses = false;
      _hasMoreWarehouses = nextCount < filtered.length;
    });
  }

  String _selectedLabelsText(List<String> values) {
    if (values.isEmpty) return '';
    if (values.length <= 2) return values.join(', ');
    return '${values.length} labels selected';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBottomSheetSelect<String>.multi(
          labelText: 'Labels',
          hintText: 'Choose labels',
          items: _labels,
          values: _selectedLabels,
          itemAsString: (item) => item,
          selectedItemsTextBuilder: _selectedLabelsText,
          onChanged: (values) => setState(() => _selectedLabels = values),
          sheetTitle: 'Labels',
        ),
        const SizedBox(height: 12),
        AppBottomSheetSelect<_RemoteWarehouse>.single(
          labelText: 'Warehouse',
          hintText: 'Search warehouse',
          items: _visibleWarehouses,
          value: _selectedWarehouse,
          itemAsString: (item) => item.title,
          itemDescriptionAsString: (item) => item.description,
          onChanged: (value) => setState(() => _selectedWarehouse = value),
          isSearchable: true,
          enableLocalFilter: false,
          isLoading: _isLoadingWarehouses,
          isLoadingMore: _isLoadingMoreWarehouses,
          hasMore: _hasMoreWarehouses,
          onSearchChanged: (value) => _searchWarehouses(value),
          onLoadMore: () => _searchWarehouses(_lastKeyword, loadMore: true),
          onRetry: () => _searchWarehouses(_lastKeyword),
          sheetTitle: 'Warehouse',
          sheetDescription: 'Remote search and paginated results.',
        ),
      ],
    );
  }
}

class _BottomSheetSelectSummaryExample extends StatefulWidget {
  const _BottomSheetSelectSummaryExample();

  @override
  State<_BottomSheetSelectSummaryExample> createState() =>
      _BottomSheetSelectSummaryExampleState();
}

Widget _buildBottomSheetSelectSummaryExample(BuildContext context) =>
    const _BottomSheetSelectSummaryExample();

class _BottomSheetSelectSummaryExampleState
    extends State<_BottomSheetSelectSummaryExample> {
  final List<String> _tags = const ['Retail', 'VIP', 'Wholesale', 'New user'];
  List<String> _selectedTags = const ['Retail', 'VIP'];

  String _summary(List<String> values) {
    if (values.isEmpty) return '';
    return '${values.length} tags selected';
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetSelect<String>.multi(
      labelText: 'Audience tags',
      hintText: 'Choose tags',
      helperText:
          'Compact summary works well when many values can be selected.',
      items: _tags,
      values: _selectedTags,
      itemAsString: (item) => item,
      selectedItemsTextBuilder: _summary,
      onChanged: (values) => setState(() => _selectedTags = values),
      sheetTitle: 'Audience tags',
    );
  }
}

class _RemoteWarehouse {
  final int id;
  final String title;
  final String description;

  const _RemoteWarehouse({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  bool operator ==(Object other) {
    return other is _RemoteWarehouse && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

List<ExampleDocEntry> buildAlertExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'Inline alert', vi: 'Alert inline'),
      description: LocalizedText(
        en: 'Inline alerts keep feedback within the current layout context.',
        vi: 'Alert inline giữ phản hồi ngay trong layout hiện tại.',
      ),
      code:
          "const AppAlert(\n"
          "  type: AppAlertType.warning,\n"
          "  title: 'Stock running low',\n"
          "  description: 'Only 4 items remain in this warehouse.',\n"
          ")",
      builder: _buildInlineAlertExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(en: 'Overlay alert', vi: 'Alert overlay'),
      description: LocalizedText(
        en: 'Use the static show API for toast-like transient feedback.',
        vi: 'Dùng API show tĩnh cho feedback thoáng qua kiểu toast.',
      ),
      code:
          "AppAlert.show(\n"
          "  context: context,\n"
          "  type: AppAlertType.success,\n"
          "  title: 'Saved',\n"
          "  description: 'Changes were published successfully.',\n"
          "  autoCloseDuration: const Duration(seconds: 3),\n"
          ");",
      builder: _buildAlertOverlayExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Inline alert with actions',
        vi: 'Alert inline có action',
      ),
      description: LocalizedText(
        en: 'Actions make inline alerts more useful when users can immediately respond to the message.',
        vi: 'Action giúp alert inline hữu ích hơn khi người dùng có thể phản hồi ngay với thông điệp đó.',
      ),
      code:
          "AppAlert(\n"
          "  type: AppAlertType.info,\n"
          "  title: 'Pending approval',\n"
          "  description: 'This payout is waiting for finance confirmation.',\n"
          "  actions: [AppAlertAction(text: 'View details')],\n"
          ")",
      builder: _buildAlertInlineActionExample,
    ),
  ];
}

Widget _buildInlineAlertExample(BuildContext context) {
  return const AppAlert(
    type: AppAlertType.warning,
    title: 'Stock running low',
    description: 'Only 4 items remain in this warehouse.',
  );
}

class _AlertOverlayExample extends StatelessWidget {
  const _AlertOverlayExample();

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: 'Show success alert',
      variant: AppButtonVariant.primary,
      onPressed: () {
        AppAlert.show(
          context: context,
          type: AppAlertType.success,
          title: 'Saved',
          description: 'Changes were published successfully.',
          autoCloseDuration: const Duration(seconds: 3),
        );
      },
    );
  }
}

Widget _buildAlertOverlayExample(BuildContext context) =>
    const _AlertOverlayExample();

Widget _buildAlertInlineActionExample(BuildContext context) {
  return AppAlert(
    type: AppAlertType.info,
    title: 'Pending approval',
    description: 'This payout is waiting for finance confirmation.',
    actions: const [AppAlertAction(text: 'View details')],
  );
}

List<ExampleDocEntry> buildBottomSheetExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'Contextual sheet', vi: 'Sheet theo ngữ cảnh'),
      description: LocalizedText(
        en: 'Bottom sheets work well for filters, small forms, and grouped actions.',
        vi: 'Bottom sheet phù hợp cho bộ lọc, form ngắn và nhóm action.',
      ),
      code:
          "AppBottomSheet.show<void>(\n"
          "  context: context,\n"
          "  builder: (sheetContext) => AppBottomSheet(\n"
          "    title: 'Filter products',\n"
          "    description: 'Choose the conditions to apply.',\n"
          "    titlePrimaryAction: 'Apply',\n"
          "    onPrimaryAction: () => AppBottomSheet.close(sheetContext),\n"
          "    child: const AppText(text: 'Sheet content'),\n"
          "  ),\n"
          ");",
      builder: _buildBottomSheetLiveExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Scrollable sheet content',
        vi: 'Bottom sheet có nội dung cuộn',
      ),
      description: LocalizedText(
        en: 'A scrollable body is helpful for choice lists, previews, and stacked form content.',
        vi: 'Phần thân cuộn phù hợp cho danh sách lựa chọn, preview hoặc form có nhiều khối nội dung.',
      ),
      code:
          "AppBottomSheet.show<void>(\n"
          "  context: context,\n"
          "  builder: (sheetContext) => AppBottomSheet(\n"
          "    title: 'Batch summary',\n"
          "    size: AppBottomSheetSize.large,\n"
          "    child: Column(children: [...]),\n"
          "  ),\n"
          ");",
      builder: _buildBottomSheetScrollableExample,
    ),
  ];
}

class _BottomSheetExample extends StatelessWidget {
  const _BottomSheetExample();

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: 'Open filter sheet',
      variant: AppButtonVariant.primary,
      onPressed: () {
        AppBottomSheet.show<void>(
          context: context,
          builder: (sheetContext) => AppBottomSheet(
            title: 'Filter products',
            description: 'Choose the conditions to apply.',
            titlePrimaryAction: 'Apply',
            titleSecondaryAction: 'Reset',
            titleCancelAction: 'Cancel',
            onPrimaryAction: () => AppBottomSheet.close(sheetContext),
            onSecondaryAction: () {},
            onCancelAction: () => AppBottomSheet.close(sheetContext),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppCheckbox(value: true, label: 'Only low stock'),
                SizedBox(height: 12),
                AppCheckbox(value: false, label: 'Only active products'),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _buildBottomSheetLiveExample(BuildContext context) =>
    const _BottomSheetExample();

class _BottomSheetScrollableExample extends StatelessWidget {
  const _BottomSheetScrollableExample();

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: 'Open batch summary',
      variant: AppButtonVariant.outline,
      onPressed: () {
        AppBottomSheet.show<void>(
          context: context,
          builder: (sheetContext) => AppBottomSheet(
            title: 'Batch summary',
            description: 'Review each item before submitting.',
            size: AppBottomSheetSize.large,
            titlePrimaryAction: 'Continue',
            onPrimaryAction: () => AppBottomSheet.close(sheetContext),
            titleCancelAction: 'Cancel',
            onCancelAction: () => AppBottomSheet.close(sheetContext),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                8,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: SpacingTokens.spaceM),
                  child: AppText(
                    text: 'Batch row ${index + 1}',
                    size: AppTextSize.bodyMRegular,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _buildBottomSheetScrollableExample(BuildContext context) =>
    const _BottomSheetScrollableExample();

List<ExampleDocEntry> buildModalExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'Confirmation modal', vi: 'Modal xác nhận'),
      description: LocalizedText(
        en: 'Use a modal when the user must explicitly confirm a risky action.',
        vi: 'Dùng modal khi người dùng cần xác nhận rõ một hành động rủi ro.',
      ),
      code:
          "AppModal.show<bool>(\n"
          "  context: context,\n"
          "  builder: (dialogContext) => AppModal(\n"
          "    modalType: AppModalType.danger,\n"
          "    title: 'Delete item?',\n"
          "    description: 'This action cannot be undone.',\n"
          "    titleCancelAction: 'Cancel',\n"
          "    onCancelAction: () => AppModal.close(dialogContext, false),\n"
          "    titlePrimaryAction: 'Delete',\n"
          "    onPrimaryAction: () => AppModal.close(dialogContext, true),\n"
          "    child: const SizedBox.shrink(),\n"
          "  ),\n"
          ");",
      builder: _buildModalLiveExample,
    ),
    ExampleDocEntry(
      title: LocalizedText(
        en: 'Review modal with body content',
        vi: 'Modal review có body content',
      ),
      description: LocalizedText(
        en: 'Use the child slot when the modal must summarize data before the user confirms.',
        vi: 'Dùng child khi modal cần tóm tắt dữ liệu trước khi người dùng xác nhận.',
      ),
      code:
          "AppModal.show<void>(\n"
          "  context: context,\n"
          "  builder: (dialogContext) => AppModal(\n"
          "    title: 'Review payout',\n"
          "    description: 'Please check the details below.',\n"
          "    titlePrimaryAction: 'Confirm',\n"
          "    child: Column(children: [...]),\n"
          "  ),\n"
          ");",
      builder: _buildModalReviewExample,
    ),
  ];
}

class _ModalExample extends StatelessWidget {
  const _ModalExample();

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: 'Open confirmation modal',
      variant: AppButtonVariant.danger,
      onPressed: () async {
        final result = await AppModal.show<bool>(
          context: context,
          builder: (dialogContext) => AppModal(
            modalType: AppModalType.danger,
            title: 'Delete item?',
            description: 'This action cannot be undone.',
            titleCancelAction: 'Cancel',
            onCancelAction: () => AppModal.close(dialogContext, false),
            titlePrimaryAction: 'Delete',
            onPrimaryAction: () => AppModal.close(dialogContext, true),
            child: const SizedBox.shrink(),
          ),
        );

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Result: ${result == true ? 'confirmed' : 'cancelled'}',
            ),
          ),
        );
      },
    );
  }
}

Widget _buildModalLiveExample(BuildContext context) => const _ModalExample();

class _ModalReviewExample extends StatelessWidget {
  const _ModalReviewExample();

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: 'Open review modal',
      variant: AppButtonVariant.outline,
      onPressed: () {
        AppModal.show<void>(
          context: context,
          builder: (dialogContext) => AppModal(
            title: 'Review payout',
            description: 'Please check the details below.',
            size: AppModalSize.large,
            titleCancelAction: 'Cancel',
            onCancelAction: () => AppModal.close(dialogContext),
            titlePrimaryAction: 'Confirm',
            onPrimaryAction: () => AppModal.close(dialogContext),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  text: 'Beneficiary: FV Supplier A',
                  size: AppTextSize.bodyMRegular,
                ),
                SizedBox(height: SpacingTokens.spaceS),
                AppText(
                  text: 'Amount: 12,000,000 VND',
                  size: AppTextSize.bodyMRegular,
                ),
                SizedBox(height: SpacingTokens.spaceS),
                AppText(
                  text: 'Expected payout date: 2026-05-14',
                  size: AppTextSize.bodyMRegular,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _buildModalReviewExample(BuildContext context) =>
    const _ModalReviewExample();

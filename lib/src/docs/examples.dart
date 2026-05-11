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
      title: LocalizedText(en: 'Determinate progress', vi: 'Tiến trình xác định'),
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
      title: LocalizedText(en: 'Avatar and static mode', vi: 'Avatar và chế độ tĩnh'),
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
      AppSkeleton(width: 56, height: 56, shape: BoxShape.circle, isAnimated: false),
    ],
  );
}

List<ExampleDocEntry> buildDividerExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'Semantic horizontal lines', vi: 'Divider ngang theo semantic'),
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
        AppDivider(
          orientation: AppDividerOrientation.vertical,
          length: 40,
        ),
        SizedBox(width: 12),
        AppText(text: 'Right'),
      ],
    ),
  );
}

List<ExampleDocEntry> buildLabelExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'Required and optional states', vi: 'Trạng thái required và optional'),
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
      title: LocalizedText(en: 'Interactive states', vi: 'Trạng thái tương tác'),
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

List<ExampleDocEntry> buildCheckboxExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'Standard and tristate', vi: 'Standard và tristate'),
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

class _CheckboxInteractiveExampleState extends State<_CheckboxInteractiveExample> {
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

List<ExampleDocEntry> buildRadioExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'Single selection group', vi: 'Nhóm chọn một giá trị'),
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
  ];
}

class _RadioInteractiveExample extends StatefulWidget {
  const _RadioInteractiveExample();

  @override
  State<_RadioInteractiveExample> createState() => _RadioInteractiveExampleState();
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
      title: LocalizedText(en: 'Sizes and disabled state', vi: 'Size và disabled'),
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
  ];
}

class _SwitchInteractiveExample extends StatefulWidget {
  const _SwitchInteractiveExample();

  @override
  State<_SwitchInteractiveExample> createState() => _SwitchInteractiveExampleState();
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

List<ExampleDocEntry> buildTextFieldExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'Variants and adornments', vi: 'Variant và adornment'),
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

class _TextFieldValidationExampleState extends State<_TextFieldValidationExample> {
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
          validate:
              (value) =>
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
    validate:
        (value) => value.length < 8 ? 'Minimum 8 characters required' : null,
  );
}

List<ExampleDocEntry> buildSearchFieldExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'Debounced search callback', vi: 'Callback search có debounce'),
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
          text: 'Latest debounced query: ${_query.isEmpty ? '(empty)' : _query}',
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
          text: _date == null ? 'No date selected' : 'Selected: ${_date!.toIso8601String().split('T').first}',
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
          text: _time == null ? 'No time selected' : 'Selected: ${_time!.format(context)}',
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

List<ExampleDocEntry> buildBottomSheetSelectExamples() {
  return const [
    ExampleDocEntry(
      title: LocalizedText(en: 'Single choice field', vi: 'Field chọn một giá trị'),
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
      title: LocalizedText(en: 'Multi choice and remote states', vi: 'Multi choice và trạng thái remote'),
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

  Future<void> _searchWarehouses(String keyword, {bool loadMore = false}) async {
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
          builder:
              (sheetContext) => AppBottomSheet(
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
          builder:
              (dialogContext) => AppModal(
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
          SnackBar(content: Text('Result: ${result == true ? 'confirmed' : 'cancelled'}')),
        );
      },
    );
  }
}

Widget _buildModalLiveExample(BuildContext context) => const _ModalExample();

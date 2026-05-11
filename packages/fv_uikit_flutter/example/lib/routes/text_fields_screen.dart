import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'docs.dart';

class TextFieldsScreen extends StatelessWidget {
  TextFieldsScreen({super.key});

  final List<Widget> inputs = [
    AppTextField(
      hintText: 'Text field xSmal',
      prefix: AppText(text: 'Prefix'),
      suffix: AppText(text: 'Suffix'),
      prefixIcon: Icon(Icons.person_outline),
      suffixIcon: Icon(Icons.info_outline),
      size: AppTextFieldSize.xSmall,
      maxLength: 40,
    ),
    AppTextField(
      hintText: 'Text field small',
      prefix: AppText(text: 'Prefix'),
      suffix: AppText(text: 'Suffix'),
      prefixIcon: Icon(Icons.person_outline),
      suffixIcon: Icon(Icons.info_outline),
      size: AppTextFieldSize.small,
      maxLength: 40,
    ),
    AppTextField(
      hintText: 'Text field medium',
      prefix: AppText(text: 'Prefix'),
      suffix: AppText(text: 'Suffix'),
      prefixIcon: Icon(Icons.person_outline),
      suffixIcon: Icon(Icons.info_outline),
      size: AppTextFieldSize.medium,
      maxLength: 40,
    ),
    AppTextField(
      hintText: 'Text field large',
      prefix: AppText(text: 'Prefix'),
      suffix: AppText(text: 'Suffix'),
      prefixIcon: Icon(Icons.person_outline),
      suffixIcon: Icon(Icons.info_outline),
      size: AppTextFieldSize.large,
      maxLength: 40,
    ),
    AppTextField(
      hintText: 'Text field xSmal',
      prefix: AppText(text: 'Prefix'),
      suffix: AppText(text: 'Suffix'),
      prefixIcon: Icon(Icons.person_outline),
      suffixIcon: Icon(Icons.info_outline),
      size: AppTextFieldSize.xLarge,
      maxLength: 40,
    ),
    AppTextField(
      hintText: 'Text field rounded',
      prefix: AppText(text: 'Prefix'),
      suffix: AppText(text: 'Suffix'),
      prefixIcon: Icon(Icons.person_outline),
      suffixIcon: Icon(Icons.info_outline),
      isRounded: true,
      size: AppTextFieldSize.medium,
      maxLength: 40,
    ),
    AppTextField(
      hintText: 'Text field danger',
      prefix: AppText(text: 'Prefix'),
      suffix: AppText(text: 'Suffix'),
      prefixIcon: Icon(Icons.person_outline),
      suffixIcon: Icon(Icons.info_outline),
      size: AppTextFieldSize.medium,
      variant: AppTextFieldVariant.danger,
      maxLength: 40,
    ),
    AppTextField(
      hintText: 'Text field warning',
      prefix: AppText(text: 'Prefix'),
      suffix: AppText(text: 'Suffix'),
      prefixIcon: Icon(Icons.person_outline),
      suffixIcon: Icon(Icons.info_outline),
      size: AppTextFieldSize.medium,
      variant: AppTextFieldVariant.warning,
      maxLength: 40,
    ),
    AppTextField(
      hintText: 'Text field success',
      prefix: AppText(text: 'Prefix'),
      suffix: AppText(text: 'Suffix'),
      prefixIcon: Icon(Icons.person_outline),
      suffixIcon: Icon(Icons.info_outline),
      size: AppTextFieldSize.medium,
      variant: AppTextFieldVariant.success,
      maxLength: 40,
    ),
    AppTextField(
      hintText: 'Text field primary',
      prefix: AppText(text: 'Prefix'),
      suffix: AppText(text: 'Suffix'),
      prefixIcon: Icon(Icons.person_outline),
      suffixIcon: Icon(Icons.info_outline),
      size: AppTextFieldSize.medium,
      variant: AppTextFieldVariant.primary,
      maxLength: 40,
    ),
    AppTextField(
      hintText: 'Text field error',
      prefix: AppText(text: 'Prefix'),
      suffix: AppText(text: 'Suffix'),
      prefixIcon: Icon(Icons.person_outline),
      suffixIcon: Icon(Icons.info_outline),
      size: AppTextFieldSize.medium,
      maxLength: 40,
      validate: (String? val) {
        if (val == null) return null;
        if (val.isEmpty) return '* Không được để trống';
        return null;
      },
    ),
    AppTextField(
      hintText: 'Text field disabled',
      prefix: AppText(text: 'Prefix'),
      suffix: AppText(text: 'Suffix'),
      prefixIcon: Icon(Icons.person_outline),
      suffixIcon: Icon(Icons.info_outline),
      size: AppTextFieldSize.medium,
      isDisabled: true,
      maxLength: 40,
    ),
    AppPasswordField(
      labelText: 'Password',
      hintText: 'Enter your password',
      helperText: 'Must be at least 8 characters',
      maxLength: 40,
      validate: (value) {
        if (value.isEmpty) return 'Password is required';
        if (value.length < 8) return 'Password must be at least 8 characters';
        return null;
      },
    ),
    AppSearchField(
      hintText: 'Search',
      onSearchChanged: (value) {
        debugPrint('value ---> $value');
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DocsScaffold(
      title: const DocsText(en: 'Text Fields', vi: 'Text Fields'),
      description: const DocsText(
        en:
            'Input controls for text entry, password entry, validation, search, and prefix/suffix composition.',
        vi:
            'Điều khiển nhập liệu cho text, password, validate, search và ghép prefix/suffix.',
      ),
      doc: widgetDocFor('textField'),
      children: [
        ExampleSection(
          title: const DocsText(en: 'Live examples', vi: 'Ví dụ trực tiếp'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < inputs.length; index++) ...[
                inputs[index],
                if (index != inputs.length - 1)
                  const SizedBox(height: SpacingTokens.paddingM),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

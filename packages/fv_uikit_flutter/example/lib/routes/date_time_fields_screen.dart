import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'docs.dart';

class DateTimeFieldsScreen extends StatelessWidget {
  const DateTimeFieldsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const sizes = AppTextFieldSize.values;

    return DocsScaffold(
      title: const DocsText(en: 'Date Time Fields', vi: 'Date Time Fields'),
      description: const DocsText(
        en: 'Picker-backed input for date, time, and date-time selection.',
        vi: 'Ô nhập liệu có picker cho ngày, giờ và ngày-giờ.',
      ),
      doc: widgetDocFor('dateTimeField'),
      children: [
        ExampleSection(
          title: const DocsText(en: 'Live examples', vi: 'Ví dụ trực tiếp'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FieldSection(
                title: 'Date',
                children: [
                  for (final size in sizes) ...[
                    AppDateTimeField(
                      mode: AppDateTimeFieldMode.date,
                      size: size,
                      hintText: 'Select date DD/MM/YYYY',
                    ),
                    AppDateTimeField(
                      mode: AppDateTimeFieldMode.date,
                      size: size,
                      isRounded: true,
                      hintText: 'Select date DD/MM/YYYY',
                    ),
                  ],
                ],
              ),
              const SizedBox(height: SpacingTokens.spaceXL),
              _FieldSection(
                title: 'Time',
                children: [
                  for (final size in sizes) ...[
                    AppDateTimeField(
                      mode: AppDateTimeFieldMode.time,
                      size: size,
                      hintText: 'Select time HH:MM',
                    ),
                    AppDateTimeField(
                      mode: AppDateTimeFieldMode.time,
                      size: size,
                      isRounded: true,
                      hintText: 'Select time HH:MM',
                    ),
                  ],
                ],
              ),
              const SizedBox(height: SpacingTokens.spaceXL),
              _FieldSection(
                title: 'Date Time',
                children: [
                  for (final size in sizes) ...[
                    AppDateTimeField(
                      mode: AppDateTimeFieldMode.dateTime,
                      size: size,
                      hintText: 'Select date DD/MM/YYYY HH:MM',
                    ),
                    AppDateTimeField(
                      mode: AppDateTimeFieldMode.dateTime,
                      size: size,
                      isRounded: true,
                      hintText: 'Select date DD/MM/YYYY HH:MM',
                    ),
                  ],
                ],
              ),
              const SizedBox(height: SpacingTokens.spaceXL),
              _FieldSection(
                title: 'Custom Picker',
                children: const [
                  AppDateTimeField(
                    mode: AppDateTimeFieldMode.date,
                    hintText: 'Select date DD/MM/YYYY',
                    pickerStyle: AppDateTimePickerStyle(
                      dateTitleText: 'Chọn ngày',
                      cancelText: 'Huỷ',
                      confirmText: 'Xong',
                      selectedColor: ColorTokens.primaryDefault,
                      selectedTextColor: ColorTokens.white,
                      titleColor: ColorTokens.textDefault,
                      headerBackgroundColor: ColorTokens.primaryDefault,
                      headerForegroundColor: ColorTokens.white,
                      headerTitleTextStyle: TextStyle(
                        color: ColorTokens.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      headerHeadlineTextStyle: TextStyle(
                        color: ColorTokens.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w500,
                      ),
                      entryModeIconColor: ColorTokens.white,
                      dialogBorderRadius: BorderRadius.all(Radius.circular(28)),
                      actionTextColor: ColorTokens.primaryDefault,
                    ),
                  ),
                  AppDateTimeField(
                    mode: AppDateTimeFieldMode.time,
                    hintText: 'Select time HH:MM',
                    isRounded: true,
                    pickerStyle: AppDateTimePickerStyle(
                      timeTitleText: 'Chọn giờ',
                      cancelText: 'Đóng',
                      confirmText: 'Áp dụng',
                      selectedColor: ColorTokens.successDefault,
                      selectedTextColor: ColorTokens.white,
                      titleColor: ColorTokens.textDefault,
                      actionTextColor: ColorTokens.successDefault,
                    ),
                  ),
                  AppDateTimeField(
                    mode: AppDateTimeFieldMode.date,
                    hintText: 'Select date DD/MM/YYYY',
                    pickerPresentation:
                        AppDateTimePickerPresentation.bottomSheet,
                    pickerStyle: AppDateTimePickerStyle(
                      dateTitleText: 'Select delivery date',
                      cancelText: 'Cancel',
                      confirmText: 'Apply',
                    ),
                  ),
                  AppDateTimeField(
                    mode: AppDateTimeFieldMode.time,
                    hintText: 'Select time HH:MM',
                    pickerPresentation:
                        AppDateTimePickerPresentation.bottomSheet,
                    pickerStyle: AppDateTimePickerStyle(
                      timeTitleText: 'Select pickup time',
                      cancelText: 'Cancel',
                      confirmText: 'Apply',
                    ),
                  ),
                  AppDateTimeField(
                    mode: AppDateTimeFieldMode.dateTime,
                    hintText: 'Select date DD/MM/YYYY HH:MM',
                    pickerPresentation:
                        AppDateTimePickerPresentation.bottomSheet,
                    pickerStyle: AppDateTimePickerStyle(
                      dateTimeTitleText: 'Schedule appointment',
                      cancelText: 'Cancel',
                      confirmText: 'Apply',
                    ),
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

class _FieldSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _FieldSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: title,
          color: ColorTokens.textDefault,
          size: AppTextSize.heading4Bold,
        ),
        const SizedBox(height: SpacingTokens.spaceM),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 720;

            return Wrap(
              spacing: SpacingTokens.spaceXL,
              runSpacing: SpacingTokens.spaceL,
              children:
                  children
                      .map(
                        (child) => SizedBox(
                          width:
                              isWide
                                  ? (constraints.maxWidth -
                                          SpacingTokens.spaceXL) /
                                      2
                                  : constraints.maxWidth,
                          child: child,
                        ),
                      )
                      .toList(),
            );
          },
        ),
      ],
    );
  }
}

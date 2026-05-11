import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'docs.dart';

class BottomSheetsScreen extends StatelessWidget {
  const BottomSheetsScreen({super.key});

  void _showSheet(
    BuildContext context, {
    required String title,
    String? description,
    AppBottomSheetSize size = AppBottomSheetSize.medium,
    AppBottomSheetActionOrientation actionOrientation =
        AppBottomSheetActionOrientation.vertical,
    bool showDragHandle = true,
    bool showCloseIcon = true,
    bool scrollable = false,
    Color? titleColor,
    TextStyle? titleStyle,
    Color? closeIconColor,
    double? closeIconSize,
    double? closeButtonSize,
    Widget? closeIcon,
    Color? dragHandleColor,
    double? dragHandleBottomGap,
    BorderRadiusGeometry? topBorderRadius,
    AppButtonVariant? primaryActionVariant,
    AppButtonVariant? secondaryActionVariant,
    AppButtonVariant? cancelActionVariant,
    double? actionSpacing,
    TextStyle? actionTextStyle,
    Color? primaryActionTextColor,
    List<Widget>? buttons,
  }) {
    AppBottomSheet.show<void>(
      context: context,
      builder:
          (bottomSheetContext) => AppBottomSheet(
            title: title,
            description: description,
            size: size,
            actionOrientation: actionOrientation,
            showDragHandle: showDragHandle,
            showCloseIcon: showCloseIcon,
            titleColor: titleColor,
            titleStyle: titleStyle,
            closeIconColor: closeIconColor,
            closeIconSize: closeIconSize,
            closeButtonSize: closeButtonSize,
            closeIcon: closeIcon,
            dragHandleColor: dragHandleColor,
            dragHandleBottomGap: dragHandleBottomGap,
            topBorderRadius: topBorderRadius,
            primaryActionVariant: primaryActionVariant,
            secondaryActionVariant: secondaryActionVariant,
            cancelActionVariant: cancelActionVariant,
            actionSpacing: actionSpacing,
            actionTextStyle: actionTextStyle,
            primaryActionTextColor: primaryActionTextColor,
            buttons: buttons,
            titleCancelAction: buttons == null ? 'Cancel' : null,
            onCancelAction: () => AppBottomSheet.close(bottomSheetContext),
            titleSecondaryAction: buttons == null ? 'Later' : null,
            onSecondaryAction: () => AppBottomSheet.close(bottomSheetContext),
            titlePrimaryAction: buttons == null ? 'Confirm' : null,
            onPrimaryAction: () => AppBottomSheet.close(bottomSheetContext),
            child:
                scrollable
                    ? _buildScrollableContent()
                    : const AppText(
                      text:
                          'This area can contain any widget, including form controls, lists, or action content.',
                      size: AppTextSize.bodyMRegular,
                      color: ColorTokens.textDefault,
                    ),
          ),
    );
  }

  Widget _buildScrollableContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 1; index <= 18; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: SpacingTokens.paddingS),
            child: AppText(
              text: 'Bottom sheet item $index',
              size: AppTextSize.bodyMRegular,
              color: ColorTokens.textDefault,
            ),
          ),
      ],
    );
  }

  void _showCustomButtonsSheet(BuildContext context) {
    AppBottomSheet.show<void>(
      context: context,
      builder:
          (bottomSheetContext) => AppBottomSheet(
            title: 'Custom buttons',
            buttons: [
              AppButton(
                text: 'Dismiss',
                variant: AppButtonVariant.text,
                isFullWidth: true,
                onPressed: () => AppBottomSheet.close(bottomSheetContext),
              ),
              AppButton(
                text: 'Primary custom',
                variant: AppButtonVariant.primary,
                isFullWidth: true,
                onPressed: () => AppBottomSheet.close(bottomSheetContext),
              ),
            ],
            child: const AppText(
              text:
                  'Pass a custom buttons list when default actions are not enough.',
              size: AppTextSize.bodyMRegular,
              color: ColorTokens.textDefault,
            ),
          ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        top: SpacingTokens.paddingL,
        bottom: SpacingTokens.paddingS,
      ),
      child: AppText(
        text: text,
        size: AppTextSize.bodyLBold,
        color: ColorTokens.textDefault,
      ),
    );
  }

  Widget _buildOpenButton({
    required String text,
    required VoidCallback onPressed,
    AppButtonVariant variant = AppButtonVariant.primary,
  }) {
    return AppButton(text: text, variant: variant, onPressed: onPressed);
  }

  @override
  Widget build(BuildContext context) {
    return DocsScaffold(
      title: const DocsText(en: 'Bottom Sheets', vi: 'Bottom Sheets'),
      description: const DocsText(
        en:
            'Bottom-anchored overlays for contextual actions, short forms, and secondary tasks.',
        vi: 'Overlay neo dưới cho action theo ngữ cảnh, form ngắn và tác vụ phụ.',
      ),
      doc: widgetDocFor('bottomSheet'),
      children: [
        ExampleSection(
          title: const DocsText(en: 'Live examples', vi: 'Ví dụ trực tiếp'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('Default'),
              _buildOpenButton(
                text: 'Default bottom sheet',
                onPressed:
                    () => _showSheet(
                      context,
                      title: 'Bottom sheet title',
                      description:
                          'Use bottom sheets for contextual actions or forms.',
                    ),
              ),
              const SizedBox(height: SpacingTokens.paddingM),
              _buildOpenButton(
                text: 'Scrollable bottom sheet',
                variant: AppButtonVariant.outline,
                onPressed:
                    () => _showSheet(
                      context,
                      title: 'Scrollable content',
                      size: AppBottomSheetSize.large,
                      scrollable: true,
                    ),
              ),
              _buildSectionTitle('Sizes'),
              Wrap(
                spacing: SpacingTokens.gapS,
                runSpacing: SpacingTokens.gapS,
                children: [
                  for (final size in AppBottomSheetSize.values)
                    _buildOpenButton(
                      text: size.name,
                      variant: AppButtonVariant.outline,
                      onPressed:
                          () => _showSheet(
                            context,
                            title: 'Size ${size.name}',
                            size: size,
                          ),
                    ),
                ],
              ),
              _buildSectionTitle('Chrome'),
              _buildOpenButton(
                text: 'No drag handle',
                variant: AppButtonVariant.outline,
                onPressed:
                    () => _showSheet(
                      context,
                      title: 'No drag handle',
                      showDragHandle: false,
                    ),
              ),
              const SizedBox(height: SpacingTokens.paddingM),
              _buildOpenButton(
                text: 'No close icon',
                variant: AppButtonVariant.outline,
                onPressed:
                    () => _showSheet(
                      context,
                      title: 'No close icon',
                      showCloseIcon: false,
                    ),
              ),
              const SizedBox(height: SpacingTokens.paddingM),
              _buildOpenButton(
                text: 'Tight drag spacing',
                variant: AppButtonVariant.outline,
                onPressed:
                    () => _showSheet(
                      context,
                      title: 'Tight drag spacing',
                      dragHandleBottomGap: 0,
                      dragHandleColor: ColorTokens.primary,
                    ),
              ),
              _buildSectionTitle('Actions'),
              _buildOpenButton(
                text: 'Horizontal actions',
                variant: AppButtonVariant.outline,
                onPressed:
                    () => _showSheet(
                      context,
                      title: 'Horizontal actions',
                      actionOrientation:
                          AppBottomSheetActionOrientation.horizontal,
                      actionSpacing: SpacingTokens.gapS,
                    ),
              ),
              const SizedBox(height: SpacingTokens.paddingM),
              _buildOpenButton(
                text: 'Custom action styles',
                variant: AppButtonVariant.outline,
                onPressed:
                    () => _showSheet(
                      context,
                      title: 'Custom action styles',
                      actionTextStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                      primaryActionVariant: AppButtonVariant.warning,
                      secondaryActionVariant: AppButtonVariant.dash,
                      cancelActionVariant: AppButtonVariant.text,
                    ),
              ),
              _buildSectionTitle('Styling'),
              _buildOpenButton(
                text: 'Custom title and close icon',
                variant: AppButtonVariant.outline,
                onPressed:
                    () => _showSheet(
                      context,
                      title: 'Custom title',
                      titleColor: ColorTokens.primary,
                      titleStyle: const TextStyle(fontSize: 28),
                      closeIconColor: ColorTokens.danger,
                      closeIconSize: 28,
                      closeButtonSize: 44,
                      closeIcon: const Icon(Icons.cancel_outlined),
                    ),
              ),
              const SizedBox(height: SpacingTokens.paddingM),
              _buildOpenButton(
                text: 'Custom top radius',
                variant: AppButtonVariant.outline,
                onPressed:
                    () => _showSheet(
                      context,
                      title: 'Custom top radius',
                      topBorderRadius: const BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
              ),
              const SizedBox(height: SpacingTokens.paddingM),
              _buildOpenButton(
                text: 'Custom buttons',
                variant: AppButtonVariant.outline,
                onPressed: () => _showCustomButtonsSheet(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

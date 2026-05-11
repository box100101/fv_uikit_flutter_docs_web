import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'docs.dart';

class ModalsScreen extends StatelessWidget {
  const ModalsScreen({super.key});

  Future<void> _showInfoModal(BuildContext context) async {
    await AppModal.show<void>(
      context: context,
      builder: (dialogContext) {
        return AppModal(
          modalType: AppModalType.info,
          size: AppModalSize.medium,
          title: 'Update completed',
          description:
              'Your product information has been updated successfully.',
          titlePrimaryAction: 'OK',
          onPrimaryAction: () {
            AppModal.close(dialogContext);
          },
          onClose: () {
            AppModal.close(dialogContext);
          },
          child: const SizedBox.shrink(),
        );
      },
    );
  }

  Future<void> _showDeleteModal(BuildContext context) async {
    final confirmed = await AppModal.show<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AppModal(
          modalType: AppModalType.danger,
          size: AppModalSize.medium,
          title: 'Delete product?',
          description: 'This action cannot be undone.',
          titleCancelAction: 'Cancel',
          onCancelAction: () {
            AppModal.close(dialogContext, false);
          },
          titlePrimaryAction: 'Delete',
          onPrimaryAction: () {
            AppModal.close(dialogContext, true);
          },
          onClose: () {
            AppModal.close(dialogContext, false);
          },
          child: const SizedBox.shrink(),
        );
      },
    );

    if (!context.mounted) return;
    _showResultSnackBar(
      context,
      confirmed == true ? 'User confirmed delete' : 'User cancelled',
    );
  }

  Future<void> _showCustomBodyModal(BuildContext context) async {
    await AppModal.show<void>(
      context: context,
      builder: (dialogContext) {
        return AppModal(
          title: 'Review information',
          description: 'Please review the values below before continuing.',
          size: AppModalSize.large,

          titleCancelAction: 'Cancel',
          onCancelAction: () {
            AppModal.close(dialogContext);
          },
          titlePrimaryAction: 'Continue',
          onPrimaryAction: () {
            AppModal.close(dialogContext);
          },
          onClose: () {
            AppModal.close(dialogContext);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Divider(),
              SizedBox(height: 8),
              AppText(text: 'Name: ECO Mart', size: AppTextSize.bodyMRegular),
              SizedBox(height: 8),
              AppText(
                text: 'Email: eco@example.com',
                size: AppTextSize.bodyMRegular,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showReviewModal(BuildContext context) async {
    final result = await AppModal.show<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AppModal(
          size: AppModalSize.large,
          title: 'Review order',
          description: 'Please review the information below before submitting.',
          titleBackAction: 'Back',
          onBackAction: () {
            AppModal.close(dialogContext, 'back');
          },
          titleCancelAction: 'Cancel',
          onCancelAction: () {
            AppModal.close(dialogContext, 'cancel');
          },
          titleSecondaryAction: 'Action',
          onSecondaryAction: () {
            AppModal.close(dialogContext, 'draft');
          },
          titlePrimaryAction: 'Action',
          onPrimaryAction: () {
            AppModal.close(dialogContext, 'submit');
          },
          onClose: () {
            AppModal.close(dialogContext, 'close');
          },
          child: const SizedBox.shrink(),
        );
      },
    );

    if (!context.mounted) return;
    _showResultSnackBar(context, 'Result: ${result ?? 'dismissed'}');
  }

  Future<void> _showWarningModal(BuildContext context) async {
    await AppModal.show<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AppModal(
          modalType: AppModalType.warning,
          size: AppModalSize.medium,
          title: 'Unsaved changes',
          description:
              'You have unsaved changes. Are you sure you want to leave this page?',
          titleCancelAction: 'Stay',
          onCancelAction: () {
            AppModal.close(dialogContext);
          },
          titlePrimaryAction: 'Leave',
          onPrimaryAction: () {
            AppModal.close(dialogContext);
          },
          onClose: () {
            AppModal.close(dialogContext);
          },
          child: const SizedBox.shrink(),
        );
      },
    );
  }

  Future<void> _showSuccessModal(BuildContext context) async {
    await AppModal.show<void>(
      context: context,
      builder: (dialogContext) {
        return AppModal(
          modalType: AppModalType.success,
          size: AppModalSize.medium,
          title: 'Order submitted',
          description: 'Your order has been submitted successfully.',
          titlePrimaryAction: 'Done',
          onPrimaryAction: () {
            AppModal.close(dialogContext);
          },
          onClose: () {
            AppModal.close(dialogContext);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              20,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppText(
                  text: 'Row ${index + 1}: example content',
                  size: AppTextSize.bodyMRegular,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showResultSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppText(
        text: title,
        size: AppTextSize.bodyLBold,
        color: ColorTokens.textDefault,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DocsScaffold(
      title: const DocsText(en: 'Modals', vi: 'Modals'),
      description: const DocsText(
        en:
            'Focused dialogs for confirmation, status, decisions, and custom task content.',
        vi:
            'Dialog tập trung cho xác nhận, trạng thái, quyết định và nội dung tác vụ tùy biến.',
      ),
      doc: widgetDocFor('modal'),
      children: [
        ExampleSection(
          title: const DocsText(en: 'Live examples', vi: 'Ví dụ trực tiếp'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('Basic Status Modals'),
              AppButton(
                text: 'Open info modal',
                onPressed: () => _showInfoModal(context),
              ),
              const SizedBox(height: 12),
              AppButton(
                text: 'Open warning modal',
                variant: AppButtonVariant.warning,
                onPressed: () => _showWarningModal(context),
              ),
              const SizedBox(height: 12),
              AppButton(
                text: 'Open success modal',
                onPressed: () => _showSuccessModal(context),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Result-Based Modals'),
              AppButton(
                text: 'Open delete modal',
                variant: AppButtonVariant.danger,
                onPressed: () => _showDeleteModal(context),
              ),
              const SizedBox(height: 12),
              AppButton(
                text: 'Open review modal',
                onPressed: () => _showReviewModal(context),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Custom Body Modal'),
              AppButton(
                text: 'Open custom body modal',
                onPressed: () => _showCustomBodyModal(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

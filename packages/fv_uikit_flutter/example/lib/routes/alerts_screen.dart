import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'docs.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  AppAlertController? _alertController;

  void _showAlert(
    AppAlertType type, {
    AppAlertSize size = AppAlertSize.medium,
    AppAlertPlacement placement = AppAlertPlacement.top,
    Offset offset = Offset.zero,
    Duration? autoCloseDuration,
  }) {
    _alertController?.close();
    late final AppAlertController controller;
    controller = AppAlert.show(
      context: context,
      type: type,
      size: size,
      title: _titleFor(type),
      description: 'Description',
      placement: placement,
      offset: offset,
      autoCloseDuration: autoCloseDuration,
      actions: [
        AppAlertAction(
          text: 'Action 1',
          onPressed: () => _alertController?.close(),
        ),
        const AppAlertAction(text: 'Action 2'),
      ],
      onClosed: () {
        if (!mounted) return;
        if (_alertController != controller) return;

        setState(() {
          _alertController = null;
        });
      },
    );
    _alertController = controller;
    setState(() {});
  }

  void _showAutoCloseAlert() {
    _showAlert(
      AppAlertType.success,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  void _showBottomAlert() {
    _showAlert(AppAlertType.info, placement: AppAlertPlacement.bottom);
  }

  void _showOffsetAlert() {
    _showAlert(
      AppAlertType.warning,
      placement: AppAlertPlacement.topRight,
      offset: const Offset(-24, 48),
    );
  }

  void _showSizeAlert(AppAlertSize size) {
    _showAlert(AppAlertType.info, size: size);
  }

  void _closeCurrentAlert() {
    AppAlert.close(_alertController!);
  }

  String _titleFor(AppAlertType type) {
    switch (type) {
      case AppAlertType.fallback:
        return 'Default alert';
      case AppAlertType.info:
        return 'Info alert';
      case AppAlertType.warning:
        return 'Warning alert';
      case AppAlertType.danger:
        return 'Danger alert';
      case AppAlertType.success:
        return 'Success alert';
    }
  }

  Widget _buildShowButton(AppAlertType type) {
    return AppButton(
      text: 'Show ${type.name}',
      variant: _buttonVariantFor(type),
      onPressed: () => _showAlert(type),
    );
  }

  AppButtonVariant _buttonVariantFor(AppAlertType type) {
    switch (type) {
      case AppAlertType.fallback:
        return AppButtonVariant.fallback;
      case AppAlertType.info:
        return AppButtonVariant.primary;
      case AppAlertType.warning:
        return AppButtonVariant.warning;
      case AppAlertType.danger:
        return AppButtonVariant.danger;
      case AppAlertType.success:
        return AppButtonVariant.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final canClose = _alertController?.isOpen ?? false;

    return DocsScaffold(
      title: const DocsText(en: 'Alerts', vi: 'Alerts'),
      description: const DocsText(
        en:
            'Inline and overlay feedback for success, information, warning, danger, and fallback states.',
        vi:
            'Phản hồi inline và overlay cho success, information, warning, danger và fallback.',
      ),
      doc: widgetDocFor('alert'),
      children: [
        ExampleSection(
          title: const DocsText(en: 'Live examples', vi: 'Ví dụ trực tiếp'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: SpacingTokens.gapS,
                runSpacing: SpacingTokens.gapS,
                children: [
                  _buildShowButton(AppAlertType.fallback),
                  _buildShowButton(AppAlertType.info),
                  _buildShowButton(AppAlertType.warning),
                  _buildShowButton(AppAlertType.danger),
                  _buildShowButton(AppAlertType.success),
                  AppButton(
                    text: 'Auto close',
                    variant: AppButtonVariant.outline,
                    onPressed: _showAutoCloseAlert,
                  ),
                  AppButton(
                    text: 'Bottom',
                    variant: AppButtonVariant.outline,
                    onPressed: _showBottomAlert,
                  ),
                  AppButton(
                    text: 'Top right + offset',
                    variant: AppButtonVariant.outline,
                    onPressed: _showOffsetAlert,
                  ),
                  AppButton(
                    text: 'Close current',
                    variant: AppButtonVariant.fallback,
                    isDisabled: !canClose,
                    onPressed: canClose ? _closeCurrentAlert : null,
                  ),
                ],
              ),
              const SizedBox(height: SpacingTokens.gapXL),
              Wrap(
                spacing: SpacingTokens.gapS,
                runSpacing: SpacingTokens.gapS,
                children: [
                  AppButton(
                    text: 'Size XS',
                    size: AppButtonSize.small,
                    onPressed: () => _showSizeAlert(AppAlertSize.xSmall),
                  ),
                  AppButton(
                    text: 'Size S',
                    size: AppButtonSize.small,
                    onPressed: () => _showSizeAlert(AppAlertSize.small),
                  ),
                  AppButton(
                    text: 'Size M',
                    size: AppButtonSize.small,
                    onPressed: () => _showSizeAlert(AppAlertSize.medium),
                  ),
                  AppButton(
                    text: 'Size L',
                    size: AppButtonSize.small,
                    onPressed: () => _showSizeAlert(AppAlertSize.large),
                  ),
                  AppButton(
                    text: 'Size XL',
                    size: AppButtonSize.small,
                    onPressed: () => _showSizeAlert(AppAlertSize.xLarge),
                  ),
                ],
              ),
              const SizedBox(height: SpacingTokens.gapXL),
              const AppText(
                text: 'Inline size examples',
                size: AppTextSize.bodyLBold,
                color: ColorTokens.textDefault,
              ),
              const SizedBox(height: SpacingTokens.gapS),
              const Column(
                children: [
                  AppAlert(
                    type: AppAlertType.fallback,
                    size: AppAlertSize.medium,
                    title: 'Default alert',
                    description: 'Description',
                    showCloseIcon: false,
                  ),
                  SizedBox(height: SpacingTokens.gapS),
                  AppAlert(
                    type: AppAlertType.info,
                    size: AppAlertSize.xSmall,
                    title: 'XSmall alert',
                    description: 'Description',
                    showCloseIcon: false,
                  ),
                  SizedBox(height: SpacingTokens.gapS),
                  AppAlert(
                    type: AppAlertType.info,
                    size: AppAlertSize.small,
                    title: 'Small alert',
                    description: 'Description',
                    showCloseIcon: false,
                  ),
                  SizedBox(height: SpacingTokens.gapS),
                  AppAlert(
                    type: AppAlertType.info,
                    size: AppAlertSize.medium,
                    title: 'Medium alert',
                    description: 'Description',
                    showCloseIcon: false,
                  ),
                  SizedBox(height: SpacingTokens.gapS),
                  AppAlert(
                    type: AppAlertType.info,
                    size: AppAlertSize.large,
                    title: 'Large alert',
                    description: 'Description',
                    showCloseIcon: false,
                  ),
                  SizedBox(height: SpacingTokens.gapS),
                  AppAlert(
                    type: AppAlertType.info,
                    size: AppAlertSize.xLarge,
                    title: 'XLarge alert',
                    description: 'Description',
                    showCloseIcon: false,
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

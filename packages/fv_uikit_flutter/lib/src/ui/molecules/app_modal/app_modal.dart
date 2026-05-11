import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';
import 'package:fv_uikit_flutter/src/ui/molecules/app_modal/app_modal_config.dart';

class AppModal extends StatelessWidget {
  final Widget child;
  final String title;
  final String? description;
  final Widget? headerIcon;
  final List<Widget>? buttons;
  final AppModalType modalType;
  final AppModalSize size;
  final bool showCloseIcon;
  final Color? closeIconColor;
  final VoidCallback? onClose;
  final String? titleBackAction;
  final VoidCallback? onBackAction;
  final String? titlePrimaryAction;
  final VoidCallback? onPrimaryAction;
  final String? titleSecondaryAction;
  final VoidCallback? onSecondaryAction;
  final String? titleCancelAction;
  final VoidCallback? onCancelAction;

  const AppModal({
    super.key,
    required this.child,
    required this.title,
    this.description,
    this.headerIcon,
    this.buttons,
    this.modalType = AppModalType.normal,
    this.size = AppModalSize.small,
    this.showCloseIcon = true,
    this.closeIconColor,
    this.onClose,
    this.titleBackAction,
    this.onBackAction,
    this.titlePrimaryAction,
    this.onPrimaryAction,
    this.titleSecondaryAction,
    this.onSecondaryAction,
    this.titleCancelAction,
    this.onCancelAction,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required AppModal Function(BuildContext dialogContext) builder,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    bool useSafeArea = true,
    Color? barrierColor,
    EdgeInsets insetPadding = const EdgeInsets.all(24),
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? ColorTokens.bgMask,
      useRootNavigator: useRootNavigator,
      useSafeArea: useSafeArea,
      builder: (dialogContext) {
        final viewInsets = MediaQuery.viewInsetsOf(dialogContext);

        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: insetPadding + viewInsets,
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: builder(dialogContext),
          ),
        );
      },
    );
  }

  static void close<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }

  bool get _hasDescription =>
      description != null && description!.trim().isNotEmpty;

  bool get _hasBodyChild {
    if (child is SizedBox) {
      final sizedBox = child as SizedBox;
      final hasSize = (sizedBox.width ?? 0) > 0 || (sizedBox.height ?? 0) > 0;
      return hasSize || sizedBox.child != null;
    }

    return true;
  }

  List<Widget> _buildFooterButtons(
    AppModalTypesConfig typeConfig,
    AppModalMetrics metrics,
  ) {
    if (buttons != null && buttons!.isNotEmpty) {
      return buttons!;
    }

    final footerButtons = <Widget>[];

    if (titleCancelAction != null) {
      footerButtons.add(
        AppButton(
          text: titleCancelAction!,
          variant: AppButtonVariant.fallback,
          size: metrics.buttonSize,
          onPressed: onCancelAction,
        ),
      );
    }

    if (titleSecondaryAction != null) {
      footerButtons.add(
        AppButton(
          text: titleSecondaryAction!,
          variant:
              typeConfig.secondaryButtonVariant ?? AppButtonVariant.outline,
          size: metrics.buttonSize,
          onPressed: onSecondaryAction,
        ),
      );
    }

    if (titlePrimaryAction != null) {
      footerButtons.add(
        AppButton(
          text: titlePrimaryAction!,
          variant: typeConfig.primaryButtonVariant,
          size: metrics.buttonSize,
          onPressed: onPrimaryAction,
        ),
      );
    }

    return footerButtons;
  }

  bool _isCenteredHeader(AppModalTypesConfig typeConfig) {
    final headerAlignment = typeConfig.headerAlignment;
    return headerAlignment == Alignment.center ||
        headerAlignment == Alignment.topCenter;
  }

  Widget _buildHeader(AppModalMetrics metrics, AppModalTypesConfig typeConfig) {
    if (_isCenteredHeader(typeConfig)) {
      return Stack(
        children: [
          if (showCloseIcon)
            Align(
              alignment: Alignment.topRight,
              child: _buildCloseButton(metrics),
            ),
          Align(
            alignment: typeConfig.headerAlignment ?? Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (typeConfig.headerIcon != null) ...[
                  typeConfig.headerIcon!,
                  SizedBox(height: metrics.headerGap),
                ],
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: showCloseIcon ? metrics.closeButtonSize : 0,
                  ),
                  child: AppText(
                    text: title,
                    size: metrics.titleTextSize,
                    color: ColorTokens.textDefault,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AppText(
            text: title,
            size: metrics.titleTextSize,
            color: ColorTokens.textDefault,
          ),
        ),
        if (showCloseIcon) ...[
          SizedBox(width: metrics.headerGap),
          _buildCloseButton(metrics),
        ],
      ],
    );
  }

  Widget? _buildBackButton(AppModalMetrics metrics) {
    if (titleBackAction == null) return null;

    return AppButton(
      text: titleBackAction!,
      variant: AppButtonVariant.link,
      size: metrics.buttonSize,
      iconLeft: Icon(
        Icons.keyboard_return,
        color: ColorTokens.primary,
        size: metrics.iconBackSize,
      ),
      onPressed: onBackAction,
    );
  }

  Widget _buildFooterActions({
    required AppModalMetrics metrics,
    required AppModalTypesConfig typeConfig,
    required List<Widget> footerButtons,
    bool forceRightAligned = false,
  }) {
    final shouldCenterActions =
        !forceRightAligned && _isCenteredHeader(typeConfig);

    final actionWrap = Wrap(
      alignment: shouldCenterActions ? WrapAlignment.center : WrapAlignment.end,
      spacing: metrics.footerGap / 2,
      runSpacing: metrics.footerGap / 2,
      children: footerButtons
          .map((button) => IntrinsicWidth(child: button))
          .toList(growable: false),
    );

    if (shouldCenterActions) {
      return Center(child: actionWrap);
    }

    return Align(alignment: Alignment.centerRight, child: actionWrap);
  }

  Widget? _buildFooter({
    required AppModalMetrics metrics,
    required AppModalTypesConfig typeConfig,
    required Widget? backButton,
    required List<Widget> footerButtons,
  }) {
    if (backButton == null && footerButtons.isEmpty) {
      return null;
    }

    if (backButton != null && footerButtons.isEmpty) {
      return backButton;
    }

    if (backButton == null) {
      return _buildFooterActions(
        metrics: metrics,
        typeConfig: typeConfig,
        footerButtons: footerButtons,
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        backButton,
        SizedBox(width: metrics.footerGap),
        Expanded(
          child: _buildFooterActions(
            metrics: metrics,
            typeConfig: typeConfig,
            footerButtons: footerButtons,
            forceRightAligned: true,
          ),
        ),
      ],
    );
  }

  Widget _buildCloseButton(AppModalMetrics metrics) {
    return SizedBox.square(
      dimension: metrics.closeButtonSize,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClose,
          customBorder: const CircleBorder(),
          child: Center(
            child: Icon(
              Icons.close,
              size: metrics.closeIconSize,
              color: closeIconColor ?? ColorTokens.iconDefault,
            ),
          ),
        ),
      ),
    );
  }

  AppModalTypesConfig _resolveTypeConfig(AppModalMetrics metrics) {
    switch (modalType) {
      case AppModalType.info:
        return AppModalTypesConfig(
          headerIcon:
              headerIcon ??
              Icon(
                Icons.info_rounded,
                color: ColorTokens.primary,
                size: metrics.headerIconSize,
              ),
          primaryButtonVariant: AppButtonVariant.primary,
          secondaryButtonVariant: AppButtonVariant.outline,
          headerAlignment: Alignment.center,
        );
      case AppModalType.warning:
        return AppModalTypesConfig(
          headerIcon:
              headerIcon ??
              Icon(
                Icons.warning,
                size: metrics.headerIconSize,
                color: ColorTokens.warning,
              ),
          primaryButtonVariant: AppButtonVariant.warning,
          secondaryButtonVariant: AppButtonVariant.outline,
          headerAlignment: Alignment.center,
        );
      case AppModalType.danger:
        return AppModalTypesConfig(
          headerIcon:
              headerIcon ??
              Icon(
                Icons.error,
                size: metrics.headerIconSize,
                color: ColorTokens.danger,
              ),
          primaryButtonVariant: AppButtonVariant.danger,
          secondaryButtonVariant: AppButtonVariant.outline,
          headerAlignment: Alignment.center,
        );
      case AppModalType.success:
        return AppModalTypesConfig(
          headerIcon:
              headerIcon ??
              Icon(
                Icons.check_circle_rounded,
                size: metrics.headerIconSize,
                color: ColorTokens.success,
              ),
          primaryButtonVariant: AppButtonVariant.primary,
          secondaryButtonVariant: AppButtonVariant.outline,
          headerAlignment: Alignment.center,
        );
      case AppModalType.normal:
        return const AppModalTypesConfig(
          primaryButtonVariant: AppButtonVariant.primary,
          secondaryButtonVariant: AppButtonVariant.outline,
          headerAlignment: Alignment.centerLeft,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final metrics = AppModalMetrics.fromSize(size);
    final typeConfig = _resolveTypeConfig(metrics);
    final backButton = _buildBackButton(metrics);
    final footerButtons = _buildFooterButtons(typeConfig, metrics);
    final header = _buildHeader(metrics, typeConfig);
    final footer = _buildFooter(
      metrics: metrics,
      typeConfig: typeConfig,
      backButton: backButton,
      footerButtons: footerButtons,
    );
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: metrics.maxWidth),
      child: Container(
        decoration: BoxDecoration(
          color: ColorTokens.bgElevated,
          borderRadius: RadiusTokens.radiusLgBorderRadius,
          boxShadow: BoxShadowTokens.boxShadowTertiary,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Padding(
            padding: EdgeInsets.all(metrics.padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                header,
                if (_hasDescription) ...[
                  SizedBox(height: metrics.bodyGap),
                  AppText(
                    text: description!,
                    size: metrics.descriptionTextSize,
                    color: ColorTokens.textDefault,
                  ),
                ],
                if (_hasBodyChild) ...[
                  SizedBox(height: metrics.bodyGap),
                  Flexible(
                    fit: FlexFit.loose,
                    child: ClipRect(child: SingleChildScrollView(child: child)),
                  ),
                ],
                if (footer != null) ...[
                  SizedBox(height: metrics.sectionGap),
                  footer,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

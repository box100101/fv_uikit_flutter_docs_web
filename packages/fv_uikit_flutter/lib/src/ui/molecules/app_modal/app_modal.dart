import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';
import 'package:fv_uikit_flutter/src/ui/molecules/app_modal/app_modal_config.dart';

class AppModal extends StatelessWidget {
  final Widget child;
  final String title;
  final EdgeInsetsGeometry? padding;
  final String? description;
  final Widget? headerIcon;
  final List<Widget>? buttons;
  final AppModalType modalType;
  final AppModalSize size;
  final double? maxWidth;
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
    this.padding,
    this.description,
    this.headerIcon,
    this.buttons,
    this.modalType = AppModalType.normal,
    this.size = AppModalSize.small,
    this.maxWidth,
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
    required Widget Function(BuildContext dialogContext) builder,
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
      builder:
          (dialogContext) => _KeyboardAwareDialogFrame(
            insetPadding: insetPadding,
            builder: builder,
          ),
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
      constraints: BoxConstraints(maxWidth: maxWidth ?? metrics.maxWidth),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: ColorTokens.bgElevated,
            borderRadius: RadiusTokens.radiusLgBorderRadius,
            boxShadow: BoxShadowTokens.boxShadowTertiary,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Padding(
              padding: padding ?? EdgeInsets.all(metrics.padding),
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
                      child: ClipRect(
                        child: SingleChildScrollView(child: child),
                      ),
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
      ),
    );
  }
}

class _KeyboardAwareDialogFrame extends StatefulWidget {
  final EdgeInsets insetPadding;
  final Widget Function(BuildContext dialogContext) builder;

  const _KeyboardAwareDialogFrame({
    required this.insetPadding,
    required this.builder,
  });

  @override
  State<_KeyboardAwareDialogFrame> createState() =>
      _KeyboardAwareDialogFrameState();
}

class _KeyboardAwareDialogFrameState extends State<_KeyboardAwareDialogFrame>
    with WidgetsBindingObserver {
  static const _animationDuration = Duration(milliseconds: 200);
  static const _focusVisibilityGap = 16.0;
  static const _minimumFocusTargetExtent = 24.0;

  final GlobalKey _dialogKey = GlobalKey();
  double _dialogOffset = 0;
  Size? _baseViewportSize;
  double _lastKeyboardInset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FocusManager.instance.addListener(_handleFocusChange);
    _scheduleKeyboardUpdate();
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_handleFocusChange);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    _scheduleKeyboardUpdate();
  }

  void _handleFocusChange() {
    _scheduleKeyboardUpdate();
  }

  void _scheduleKeyboardUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _updateKeyboardAvoidance();
    });
  }

  Future<void> _updateKeyboardAvoidance() async {
    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery == null) return;
    _syncBaseViewportSize(mediaQuery);

    final focusContext = FocusManager.instance.primaryFocus?.context;
    final keyboardInset = mediaQuery.viewInsets.bottom;

    if (focusContext == null || keyboardInset <= 0) {
      _updateDialogOffset(0);
      return;
    }

    final targetContext = _resolveFocusTargetContext(focusContext);
    final dialogBox = _dialogKey.currentContext?.findRenderObject();
    final focusedBox = targetContext.findRenderObject();

    if (dialogBox is! RenderBox ||
        focusedBox is! RenderBox ||
        !dialogBox.attached ||
        !focusedBox.attached) {
      return;
    }

    final dialogRect = _globalRect(dialogBox);
    final focusedRect = _globalRect(focusedBox);
    final viewportHeight = _baseViewportSize?.height ?? mediaQuery.size.height;
    final keyboardTop = viewportHeight - keyboardInset;
    final requiredShift = math.max(
      0.0,
      focusedRect.bottom + _focusVisibilityGap - keyboardTop,
    );
    final topBoundary = mediaQuery.padding.top + widget.insetPadding.top;
    final maxShift = math.max(0.0, dialogRect.top - topBoundary);
    final nextOffset = math.min(requiredShift, maxShift);

    _updateDialogOffset(nextOffset);
    await _ensureFocusedWidgetVisible(targetContext);
  }

  Rect _globalRect(RenderBox renderBox) {
    final origin = renderBox.localToGlobal(Offset.zero);
    return origin & renderBox.size;
  }

  void _syncBaseViewportSize(MediaQueryData mediaQuery) {
    if (_baseViewportSize == null || mediaQuery.viewInsets.bottom <= 0) {
      _baseViewportSize = mediaQuery.size;
    }
  }

  BuildContext _resolveFocusTargetContext(BuildContext focusContext) {
    final renderBox = focusContext.findRenderObject();
    if (_isVisibleFocusTarget(renderBox)) {
      return focusContext;
    }

    BuildContext resolvedContext = focusContext;
    focusContext.visitAncestorElements((Element element) {
      if (_isVisibleFocusTarget(element.renderObject)) {
        resolvedContext = element;
        return false;
      }

      return true;
    });

    return resolvedContext;
  }

  bool _isVisibleFocusTarget(RenderObject? renderObject) {
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize) {
      return false;
    }

    return renderObject.size.width >= _minimumFocusTargetExtent &&
        renderObject.size.height >= _minimumFocusTargetExtent;
  }

  void _updateDialogOffset(double nextOffset) {
    if ((_dialogOffset - nextOffset).abs() < 0.5) {
      return;
    }

    setState(() {
      _dialogOffset = nextOffset;
    });
  }

  Future<void> _ensureFocusedWidgetVisible(BuildContext focusContext) async {
    try {
      await Scrollable.ensureVisible(
        focusContext,
        duration: _animationDuration,
        curve: Curves.easeOut,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      );
    } on FlutterError {
      // No scrollable ancestor is available for this focused widget.
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardInset = mediaQuery.viewInsets.bottom;
    if ((keyboardInset - _lastKeyboardInset).abs() >= 0.5) {
      _lastKeyboardInset = keyboardInset;
      _scheduleKeyboardUpdate();
    }
    _syncBaseViewportSize(mediaQuery);
    final childMediaQuery = mediaQuery
        .removeViewInsets(
          removeLeft: true,
          removeTop: true,
          removeRight: true,
          removeBottom: true,
        )
        .copyWith(size: _baseViewportSize ?? mediaQuery.size);

    return Padding(
      padding: widget.insetPadding,
      child: AnimatedContainer(
        duration: _animationDuration,
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, -_dialogOffset, 0),
        child: Semantics(
          child: Align(
            alignment: Alignment.center,
            child: KeyedSubtree(
              key: _dialogKey,
              child: MediaQuery(
                data: childMediaQuery,
                child: Builder(
                  builder: (dialogContext) => widget.builder(dialogContext),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

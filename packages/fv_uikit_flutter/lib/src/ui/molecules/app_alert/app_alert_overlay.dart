part of 'app_alert.dart';

class _AppAlertOverlay extends StatefulWidget {
  final AppAlertController controller;
  final VoidCallback onRemove;
  final AppAlertType type;
  final AppAlertSize size;
  final String title;
  final String? description;
  final List<AppAlertAction> actions;
  final bool dismissible;
  final bool showIcon;
  final bool showCloseIcon;
  final VoidCallback? onClose;
  final VoidCallback? onClosed;
  final Widget? icon;
  final Widget? closeIcon;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? titleColor;
  final Color? descriptionColor;
  final Color? actionColor;
  final double width;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Duration animationDuration;
  final Curve animationCurve;
  final Offset? transitionOffset;
  final Duration? autoCloseDuration;
  final AppAlertPlacement placement;
  final AlignmentGeometry? alignment;
  final Offset offset;
  final EdgeInsetsGeometry margin;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;

  const _AppAlertOverlay({
    required this.controller,
    required this.onRemove,
    required this.type,
    required this.size,
    required this.title,
    required this.description,
    required this.actions,
    required this.dismissible,
    required this.showIcon,
    required this.showCloseIcon,
    required this.onClose,
    required this.onClosed,
    required this.icon,
    required this.closeIcon,
    required this.backgroundColor,
    required this.iconColor,
    required this.titleColor,
    required this.descriptionColor,
    required this.actionColor,
    required this.width,
    required this.padding,
    required this.borderRadius,
    required this.animationDuration,
    required this.animationCurve,
    required this.transitionOffset,
    required this.autoCloseDuration,
    required this.placement,
    required this.alignment,
    required this.offset,
    required this.margin,
    required this.top,
    required this.right,
    required this.bottom,
    required this.left,
  });

  @override
  State<_AppAlertOverlay> createState() => _AppAlertOverlayState();
}

class _AppAlertOverlayState extends State<_AppAlertOverlay> {
  Timer? _autoCloseTimer;
  bool _isVisible = false;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    widget.controller._close = _closeFromController;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isClosing) return;

      setState(() {
        _isVisible = true;
      });
    });

    final autoCloseDuration = widget.autoCloseDuration;
    if (autoCloseDuration != null) {
      _autoCloseTimer = Timer(autoCloseDuration, _closeFromController);
    }
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    if (widget.controller._close == _closeFromController) {
      widget.controller._close = null;
    }
    super.dispose();
  }

  void _requestClose() {
    widget.onClose?.call();

    if (!widget.dismissible) return;

    _close();
  }

  void _closeFromController() {
    _close();
  }

  void _close() {
    if (_isClosing) return;

    _autoCloseTimer?.cancel();
    _isClosing = true;

    if (mounted) {
      setState(() {
        _isVisible = false;
      });
    }

    Future<void>.delayed(widget.animationDuration, () {
      widget.onRemove();
      widget.onClosed?.call();
    });
  }

  bool get _hasAbsolutePosition =>
      widget.top != null ||
      widget.right != null ||
      widget.bottom != null ||
      widget.left != null;

  AlignmentGeometry get _resolvedAlignment {
    if (widget.alignment != null) return widget.alignment!;

    switch (widget.placement) {
      case AppAlertPlacement.top:
        return Alignment.topCenter;
      case AppAlertPlacement.topLeft:
        return Alignment.topLeft;
      case AppAlertPlacement.topRight:
        return Alignment.topRight;
      case AppAlertPlacement.center:
        return Alignment.center;
      case AppAlertPlacement.bottom:
        return Alignment.bottomCenter;
      case AppAlertPlacement.bottomLeft:
        return Alignment.bottomLeft;
      case AppAlertPlacement.bottomRight:
        return Alignment.bottomRight;
    }
  }

  Offset get _resolvedTransitionOffset {
    if (widget.transitionOffset != null) return widget.transitionOffset!;

    switch (widget.placement) {
      case AppAlertPlacement.bottom:
      case AppAlertPlacement.bottomLeft:
      case AppAlertPlacement.bottomRight:
        return const Offset(0, 0.08);
      case AppAlertPlacement.center:
        return const Offset(0, 0.04);
      case AppAlertPlacement.top:
      case AppAlertPlacement.topLeft:
      case AppAlertPlacement.topRight:
        return const Offset(0, -0.08);
    }
  }

  Widget _buildAlert() {
    return Material(
      color: ColorTokens.transparent,
      child: AppAlert(
        type: widget.type,
        size: widget.size,
        title: widget.title,
        description: widget.description,
        actions: widget.actions,
        visible: true,
        dismissible: false,
        showIcon: widget.showIcon,
        showCloseIcon: widget.showCloseIcon,
        onClose: _requestClose,
        icon: widget.icon,
        closeIcon: widget.closeIcon,
        backgroundColor: widget.backgroundColor,
        iconColor: widget.iconColor,
        titleColor: widget.titleColor,
        descriptionColor: widget.descriptionColor,
        actionColor: widget.actionColor,
        width: widget.width,
        padding: widget.padding,
        borderRadius: widget.borderRadius,
        animationDuration: Duration.zero,
      ),
    );
  }

  Widget _buildAnimatedAlert() {
    final transitionOffset = _resolvedTransitionOffset;

    return AnimatedOpacity(
      duration: widget.animationDuration,
      curve: widget.animationCurve,
      opacity: _isVisible ? 1 : 0,
      child: AnimatedSlide(
        duration: widget.animationDuration,
        curve: widget.animationCurve,
        offset: _isVisible ? Offset.zero : transitionOffset,
        child: Transform.translate(offset: widget.offset, child: _buildAlert()),
      ),
    );
  }

  Widget _buildAlignedAlert() {
    return SafeArea(
      child: Align(
        alignment: _resolvedAlignment,
        child: Padding(padding: widget.margin, child: _buildAnimatedAlert()),
      ),
    );
  }

  Widget _buildPositionedAlert() {
    return Positioned(
      top: widget.top,
      right: widget.right,
      bottom: widget.bottom,
      left: widget.left,
      child: _buildAnimatedAlert(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (_hasAbsolutePosition)
            _buildPositionedAlert()
          else
            _buildAlignedAlert(),
        ],
      ),
    );
  }
}

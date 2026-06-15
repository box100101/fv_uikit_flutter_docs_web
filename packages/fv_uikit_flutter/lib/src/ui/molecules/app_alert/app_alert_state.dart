part of 'app_alert.dart';

class _AppAlertState extends State<AppAlert> {
  late bool _isVisible;
  bool _closeRequested = false;

  @override
  void initState() {
    super.initState();
    _isVisible = widget.visible;
  }

  @override
  void didUpdateWidget(covariant AppAlert oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.visible != widget.visible) {
      _isVisible = widget.visible;
      if (_isVisible) _closeRequested = false;
    }
  }

  bool get _hasDescription =>
      widget.description != null && widget.description!.trim().isNotEmpty;

  bool get _hasActions => widget.actions.isNotEmpty;

  IconData get _defaultIcon {
    switch (widget.type) {
      case AppAlertType.fallback:
        return Icons.info;
      case AppAlertType.info:
        return Icons.info;
      case AppAlertType.warning:
        return Icons.error;
      case AppAlertType.danger:
        return Icons.cancel;
      case AppAlertType.success:
        return Icons.check_circle;
    }
  }

  Color get _defaultIconColor {
    switch (widget.type) {
      case AppAlertType.fallback:
        return _AppAlertColorTokens.fallbackIcon;
      case AppAlertType.info:
        return ColorTokens.primary;
      case AppAlertType.warning:
        return ColorTokens.warning;
      case AppAlertType.danger:
        return ColorTokens.danger;
      case AppAlertType.success:
        return ColorTokens.successDefault;
    }
  }

  Color get _defaultBackgroundColor {
    switch (widget.type) {
      case AppAlertType.fallback:
        return _AppAlertColorTokens.fallbackBackground;
      case AppAlertType.info:
        return _AppAlertColorTokens.infoBackground;
      case AppAlertType.warning:
        return _AppAlertColorTokens.warningBackground;
      case AppAlertType.danger:
        return _AppAlertColorTokens.dangerBackground;
      case AppAlertType.success:
        return _AppAlertColorTokens.successBackground;
    }
  }

  TextStyle _textStyleFor(AppTextSize size) {
    switch (size) {
      case AppTextSize.bodyXSMedium:
        return TextStyleTokens.bodyXSMedium;
      case AppTextSize.bodySMedium:
        return TextStyleTokens.bodySMedium;
      case AppTextSize.bodyMMedium:
        return TextStyleTokens.bodyMMedium;
      case AppTextSize.bodyLMedium:
        return TextStyleTokens.bodyLMedium;
      case AppTextSize.bodyXLMedium:
        return TextStyleTokens.bodyXLMedium;
      case AppTextSize.heading4Medium:
        return TextStyleTokens.heading4Medium;
      default:
        return TextStyleTokens.bodyMMedium;
    }
  }

  Widget _buildIcon(_AppAlertMetrics metrics) {
    return SizedBox(
      height: metrics.lineHeight,
      child: Align(
        alignment: Alignment.center,
        child: IconTheme(
          data: IconThemeData(
            color: widget.iconColor ?? _defaultIconColor,
            size: metrics.iconSize,
          ),
          child: widget.icon ?? Icon(_defaultIcon),
        ),
      ),
    );
  }

  Widget _buildCloseButton(_AppAlertMetrics metrics) {
    return SizedBox(
      height: metrics.lineHeight,
      child: IconButton(
        onPressed: _handleClose,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(
          width: metrics.closeButtonSize,
          height: metrics.lineHeight,
        ),
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: _AppAlertColorTokens.closeIcon,
          disabledForegroundColor: _AppAlertColorTokens.closeIcon,
        ),
        iconSize: metrics.closeIconSize,
        icon: widget.closeIcon ?? const Icon(Icons.close),
      ),
    );
  }

  Widget _buildAction(AppAlertAction action, _AppAlertMetrics metrics) {
    return TextButton(
      onPressed: action.onPressed,
      style: TextButton.styleFrom(
        foregroundColor: widget.actionColor ?? _AppAlertColorTokens.actionText,
        disabledForegroundColor: (widget.actionColor ??
                _AppAlertColorTokens.actionText)
            .withValues(alpha: 0.5),
        minimumSize: Size(0, metrics.actionMinHeight),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        textStyle: _textStyleFor(metrics.actionTextSize),
      ),
      child: AppText(
        text: action.text,
        size: metrics.actionTextSize,
        color: widget.actionColor ?? _AppAlertColorTokens.actionText,
      ),
    );
  }

  Widget _buildActions(_AppAlertMetrics metrics) {
    return Wrap(
      spacing: metrics.actionGap,
      runSpacing: 0,
      children: widget.actions
          .map((action) => _buildAction(action, metrics))
          .toList(growable: false),
    );
  }

  Widget _buildContent(_AppAlertMetrics metrics) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            text: widget.title,
            size: metrics.titleTextSize,
            color: widget.titleColor ?? ColorTokens.textDefault,
          ),
          if (_hasDescription) ...[
            SizedBox(height: metrics.contentGap),
            AppText(
              text: widget.description!,
              size: metrics.descriptionTextSize,
              color: widget.descriptionColor ?? ColorTokens.textDescription,
            ),
          ],
          if (_hasActions) ...[
            SizedBox(height: metrics.contentGap),
            _buildActions(metrics),
          ],
        ],
      ),
    );
  }

  String get _semanticLabel {
    final parts = <String>[
      '${widget.type.name} alert',
      widget.title,
      if (_hasDescription) widget.description!,
    ];

    return parts.join(', ');
  }

  void _handleClose() {
    widget.onClose?.call();

    if (!widget.dismissible || !_isVisible) return;

    setState(() {
      _closeRequested = true;
      _isVisible = false;
    });

    Future<void>.delayed(widget.animationDuration, () {
      if (!mounted || _isVisible || !_closeRequested) return;

      _closeRequested = false;
      widget.onClosed?.call();
    });
  }

  Widget _buildAlert(_AppAlertMetrics metrics) {
    return Semantics(
      container: true,
      liveRegion: true,
      label: _semanticLabel,
      child: Container(
        width: widget.width,
        padding: widget.padding ?? metrics.padding,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? _defaultBackgroundColor,
          borderRadius:
              widget.borderRadius ?? RadiusTokens.radiusXsBorderRadius,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showIcon) ...[
              _buildIcon(metrics),
              SizedBox(width: metrics.gap),
            ],
            _buildContent(metrics),
            if (widget.showCloseIcon) ...[
              SizedBox(width: metrics.gap),
              _buildCloseButton(metrics),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _AppAlertMetrics.fromSize(widget.size);

    return AnimatedSwitcher(
      duration: widget.animationDuration,
      switchInCurve: widget.animationCurve,
      switchOutCurve: widget.animationCurve,
      child:
          _isVisible
              ? KeyedSubtree(
                key: const ValueKey('app-alert-visible'),
                child: _buildAlert(metrics),
              )
              : const SizedBox.shrink(key: ValueKey('app-alert-hidden')),
    );
  }
}

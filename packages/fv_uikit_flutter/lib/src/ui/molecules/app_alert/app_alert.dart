import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

part 'app_alert_action.dart';
part 'app_alert_controller.dart';
part 'app_alert_metrics.dart';
part 'app_alert_overlay.dart';
part 'app_alert_state.dart';

class AppAlert extends StatefulWidget {
  final AppAlertType type;
  final AppAlertSize size;
  final String title;
  final String? description;
  final List<AppAlertAction> actions;
  final bool visible;
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
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Duration animationDuration;
  final Curve animationCurve;

  const AppAlert({
    super.key,
    this.type = AppAlertType.info,
    this.size = AppAlertSize.medium,
    required this.title,
    this.description,
    this.actions = const [],
    this.visible = true,
    this.dismissible = true,
    this.showIcon = true,
    this.showCloseIcon = true,
    this.onClose,
    this.onClosed,
    this.icon,
    this.closeIcon,
    this.backgroundColor,
    this.iconColor,
    this.titleColor,
    this.descriptionColor,
    this.actionColor,
    this.width,
    this.padding,
    this.animationDuration = const Duration(milliseconds: 180),
    this.animationCurve = Curves.easeOut,
  });

  static AppAlertController show({
    required BuildContext context,
    required String title,
    AppAlertType type = AppAlertType.info,
    AppAlertSize size = AppAlertSize.medium,
    String? description,
    List<AppAlertAction> actions = const [],
    bool dismissible = true,
    bool showIcon = true,
    bool showCloseIcon = true,
    VoidCallback? onClose,
    VoidCallback? onClosed,
    Widget? icon,
    Widget? closeIcon,
    Color? backgroundColor,
    Color? iconColor,
    Color? titleColor,
    Color? descriptionColor,
    Color? actionColor,
    double width = 340,
    EdgeInsetsGeometry? padding,
    Duration animationDuration = const Duration(milliseconds: 180),
    Curve animationCurve = Curves.easeOut,
    Offset? transitionOffset,
    Duration? autoCloseDuration,
    AppAlertPlacement placement = AppAlertPlacement.top,
    AlignmentGeometry? alignment,
    Offset offset = Offset.zero,
    EdgeInsetsGeometry margin = const EdgeInsets.fromLTRB(16, 16, 16, 0),
    double? top,
    double? right,
    double? bottom,
    double? left,
    bool useRootOverlay = true,
  }) {
    final overlay =
        useRootOverlay
            ? Navigator.maybeOf(context, rootNavigator: true)?.overlay ??
                Overlay.of(context, rootOverlay: true)
            : Overlay.of(context);
    final controller = AppAlertController._();
    late final OverlayEntry entry;

    void removeEntry() {
      if (!controller._isOpen) return;

      controller._isOpen = false;
      entry.remove();
    }

    entry = OverlayEntry(
      builder:
          (overlayContext) => _AppAlertOverlay(
            controller: controller,
            onRemove: removeEntry,
            title: title,
            type: type,
            size: size,
            description: description,
            actions: actions,
            dismissible: dismissible,
            showIcon: showIcon,
            showCloseIcon: showCloseIcon,
            onClose: onClose,
            onClosed: onClosed,
            icon: icon,
            closeIcon: closeIcon,
            backgroundColor: backgroundColor,
            iconColor: iconColor,
            titleColor: titleColor,
            descriptionColor: descriptionColor,
            actionColor: actionColor,
            width: width,
            padding: padding,
            animationDuration: animationDuration,
            animationCurve: animationCurve,
            transitionOffset: transitionOffset,
            autoCloseDuration: autoCloseDuration,
            placement: placement,
            alignment: alignment,
            offset: offset,
            margin: margin,
            top: top,
            right: right,
            bottom: bottom,
            left: left,
          ),
    );

    controller._isOpen = true;
    overlay.insert(entry);

    return controller;
  }

  static void close(AppAlertController controller) {
    controller.close();
  }

  @override
  State<AppAlert> createState() => _AppAlertState();
}

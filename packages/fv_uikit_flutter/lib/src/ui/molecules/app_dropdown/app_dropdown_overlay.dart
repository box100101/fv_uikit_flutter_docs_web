import 'package:flutter/material.dart';

class AppDropdownOverlay extends StatelessWidget {
  final LayerLink layerLink;
  final double width;
  final bool opensAbove;
  final VoidCallback onDismiss;
  final Widget child;

  const AppDropdownOverlay({
    super.key,
    required this.layerLink,
    required this.width,
    required this.opensAbove,
    required this.onDismiss,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onDismiss,
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          width: width,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            targetAnchor: opensAbove ? Alignment.topLeft : Alignment.bottomLeft,
            followerAnchor:
                opensAbove ? Alignment.bottomLeft : Alignment.topLeft,
            child: Material(color: Colors.transparent, child: child),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

class AppSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final BoxShape shape;
  final BorderRadiusGeometry? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;
  final bool isAnimated;

  const AppSkeleton({
    super.key,
    this.width,
    this.height,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1200),
    this.isAnimated = true,
  });

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void initState() {
    super.initState();
    _syncAnimationState();
  }

  @override
  void didUpdateWidget(covariant AppSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    _syncAnimationState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncAnimationState() {
    if (widget.isAnimated) {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
      return;
    }

    _controller.stop();
    _controller.value = 0;
  }

  BoxDecoration _buildDecoration(double shimmerValue) {
    final baseColor = widget.baseColor ?? ColorTokens.borderSecondary;
    final highlightColor = widget.highlightColor ?? ColorTokens.bgWarm;

    return BoxDecoration(
      shape: widget.shape,
      borderRadius:
          widget.shape == BoxShape.circle
              ? null
              : (widget.borderRadius ??
                  const BorderRadius.all(
                    Radius.circular(RadiusTokens.radiusL),
                  )),
      color: widget.isAnimated ? null : baseColor,
      gradient:
          widget.isAnimated
              ? LinearGradient(
                begin: Alignment(-1.6 + (2.8 * shimmerValue), -0.35),
                end: Alignment(-0.6 + (2.8 * shimmerValue), 0.35),
                colors: [baseColor, highlightColor, baseColor],
                stops: const [0.15, 0.35, 0.55],
              )
              : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedHeight =
        widget.shape == BoxShape.circle
            ? (widget.height ?? widget.width ?? 16)
            : (widget.height ?? 16);
    final resolvedWidth =
        widget.shape == BoxShape.circle
            ? (widget.width ?? resolvedHeight)
            : widget.width;

    if (!widget.isAnimated) {
      return SizedBox(
        width: resolvedWidth,
        height: resolvedHeight,
        child: DecoratedBox(decoration: _buildDecoration(0)),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SizedBox(
          width: resolvedWidth,
          height: resolvedHeight,
          child: DecoratedBox(decoration: _buildDecoration(_controller.value)),
        );
      },
    );
  }
}

@Deprecated(
  'Use AppLoadingSpinner instead. This compatibility wrapper will be removed in a future release.',
)
class Loading extends StatelessWidget {
  final double size;
  final bool isAnimated;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final double? value;
  final EdgeInsetsGeometry padding;
  final String? semanticsLabel;
  final String? semanticsValue;

  const Loading({
    super.key,
    this.size = IconSizeTokens.iconSizeL,
    this.isAnimated = true,
    this.strokeWidth = 2,
    this.color,
    this.backgroundColor,
    this.value,
    this.padding = EdgeInsets.zero,
    this.semanticsLabel,
    this.semanticsValue,
  });

  @override
  Widget build(BuildContext context) {
    return TickerMode(
      enabled: isAnimated,
      child: AppLoadingSpinner(
        size: size,
        strokeWidth: strokeWidth,
        color: color,
        backgroundColor: backgroundColor,
        value: value,
        padding: padding,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
      ),
    );
  }
}

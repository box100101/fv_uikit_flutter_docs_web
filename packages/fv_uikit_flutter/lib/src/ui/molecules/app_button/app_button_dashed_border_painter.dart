part of 'app_button.dart';

class _DashedRoundedRectPainter extends CustomPainter {
  static const double _dashLength = 6;
  static const double _gapLength = 4;

  final Color color;
  final double strokeWidth;
  final BorderRadius borderRadius;

  const _DashedRoundedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

    final path =
        Path()..addRRect(
          borderRadius.toRRect((Offset.zero & size).deflate(strokeWidth / 2)),
        );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;

      while (distance < metric.length) {
        final nextDistance =
            distance + _dashLength < metric.length
                ? distance + _dashLength
                : metric.length;

        canvas.drawPath(metric.extractPath(distance, nextDistance), paint);
        distance = nextDistance + _gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRoundedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius;
  }
}

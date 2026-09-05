import 'package:flutter/material.dart';

@immutable
class DashBorder {
  final Color? color;
  final double? strokeWidth;
  final double? dashLength;
  final double? gapLength;

  const DashBorder({
    this.color,
    this.strokeWidth,
    this.dashLength,
    this.gapLength,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashBorder &&
          other.color == color &&
          other.strokeWidth == strokeWidth &&
          other.dashLength == dashLength &&
          other.gapLength == gapLength;

  @override
  int get hashCode => Object.hash(color, strokeWidth, dashLength, gapLength);
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final BorderRadius borderRadius;

  const DashedBorderPainter({
    this.color = Colors.black,
    this.strokeWidth = 2,
    this.dashLength = 5,
    this.gapLength = 3,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    // A non-positive stride would never advance `distance`, hanging the raster
    // thread in the loop below.
    final double stride = dashLength + gapLength;
    if (dashLength <= 0 || stride <= 0 || !stride.isFinite) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    // Draw dashed path
    final path = Path()..addRRect(rrect);
    final dashPath = Path();

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double end = (distance + dashLength).clamp(0.0, metric.length);
        dashPath.addPath(metric.extractPath(distance, end), Offset.zero);
        distance += stride;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.dashLength != dashLength ||
      oldDelegate.gapLength != gapLength ||
      oldDelegate.borderRadius != borderRadius;
}

class CustomDashedBorder extends StatelessWidget {
  final double? strokeWidth;
  final double? dashLength;
  final double? gapLength;
  final BorderRadius radius;
  final Color? color;

  final Widget? child;

  const CustomDashedBorder({
    super.key,
    this.strokeWidth = 2,
    this.dashLength = 6,
    this.gapLength = 3,
    this.radius = BorderRadius.zero,
    this.color,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(
        color: color ?? Colors.grey,
        strokeWidth: strokeWidth ?? 2,
        dashLength: dashLength ?? 6,
        gapLength: gapLength ?? 3,
        borderRadius: radius,
      ),
      child: child,
    );
  }
}

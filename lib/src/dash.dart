import 'package:flutter/material.dart';

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
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final BorderRadius borderRadius;

  DashedBorderPainter({
    this.color = Colors.black,
    this.strokeWidth = 2,
    this.dashLength = 5,
    this.gapLength = 3,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  void paint(Canvas canvas, Size size) {
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

    double distance = 0.0;
    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      while (distance < metric.length) {
        final len = dashLength;
        dashPath.addPath(
            metric.extractPath(distance, distance + len), Offset.zero);
        distance += dashLength + gapLength;
      }
      distance = 0.0; // reset for next segment
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CustomDashedBorder extends StatelessWidget {
  final double width;
  final double height;
  final double? strokeWidth;
  final double? dashLength;
  final double? gapLength;
  final BorderRadius radius;
  final Color? color;

  final Widget? child;

  const CustomDashedBorder({
    super.key,
    this.width = 200,
    this.height = 100,
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

import 'dart:math';

import 'package:flutter/material.dart';

import '../../config/app_colors.dart';

class HalfTransparentBorderPainter extends CustomPainter {
  final Color? transparentColor;
  HalfTransparentBorderPainter({this.transparentColor});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint orangePaint = Paint()
      ..color = AppColors.mainColor
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final Paint transparentPaint = Paint()
      ..color = transparentColor ?? const Color(0xffFBE6E2)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;

    // Draw the full circle with an orange border
    canvas.drawCircle(Offset(radius, radius), radius, orangePaint);

    // Draw a semi-circle with a transparent border
    final Rect rect =
        Rect.fromCircle(center: Offset(radius, radius), radius: radius);
    const double startAngle = pi / 1.5;
    const double sweepAngle = (2 * pi * 0.58) - (pi / 3);
    canvas.drawArc(rect, startAngle, sweepAngle, false, transparentPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

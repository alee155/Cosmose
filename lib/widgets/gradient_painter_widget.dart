import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class WavyGradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(size.width, size.height),
        [Color(0xFF28BE7B), Colors.yellow, Color(0xFF0E6655)],
        [0.0, 0.5, 1.0],
      );

    Path path = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.2,
          size.width * 0.5, size.height * 0.3)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * 0.4, size.width, size.height * 0.3)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

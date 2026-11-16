import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  void drawSquare(
      Canvas canvas, Size size, Paint paint, double valueW, double valueH) {
    paint.color = Colors.purpleAccent.shade400;

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(size.width * valueW, size.height * valueH),
              width: 300,
              height: 300,
            ),
            Radius.circular(20)),
        paint);
  }

  void drawAbstractShapes(Canvas canvas, Size size, Paint paint) {
    Path path = Path();
    //  final paint = Paint();
    path.moveTo(size.width * 4, size.height * 0.2);
    path.quadraticBezierTo(
        size.width * 1.2, 350, size.width * 0.4, size.height * 0.4);
    path.quadraticBezierTo(
        size.width * 0, size.height * 1, -100, size.height * 1.4);
    path.lineTo(-50, -50);
    path.close();
    canvas.drawPath(
        path,
        paint
          ..color = Colors.purple.shade400
          ..style = PaintingStyle.fill);
  }

  void drawEllipse(Canvas canvas, Size size, Paint paint) {
    Path path = Path();
    paint.color = Colors.purpleAccent.shade400;
    canvas.drawPath(path, paint);
    paint.style = PaintingStyle.fill;
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 1.16, size.height * 5.5),
            width: 450,
            height: 250),
        paint);
  }

  void drawTriangle(
      Canvas canvas, Size size, Paint paint, double valueW, double valueH) {
    paint.color = Colors.purpleAccent.shade400;
    final offset = Offset(size.width * valueW, size.height * valueH);
    canvas.drawPath(
        Path()
          ..moveTo(offset.dx, offset.dy)
          ..lineTo(offset.dx + 350, offset.dy + 200)
          ..lineTo(offset.dx - 200, offset.dy + 500)
          ..close(),
        paint);
  }

  void drawCircle(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.blueAccent.shade400;
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 1.7), 150, paint);
  }

  void drawContrastingBlobs(Canvas canvas, Size size, Paint paint) {
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 30);
    paint.blendMode = BlendMode.overlay;
    drawCircle(canvas, size, paint);
    drawTriangle(canvas, size, paint, 1.5, 1);
    drawEllipse(canvas, size, paint);
    drawAbstractShapes(canvas, size, paint);
    drawSquare(canvas, size, paint, 2.2, 4.2);
    drawSquare(canvas, size, paint, 0.1, 3.8);
    // drawAbstractShapes(canvas, size, paint, 0, 7);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    final paint = Paint();
    drawContrastingBlobs(canvas, size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:journal_app/widgets/background_painter.dart';

class UltraBackground extends StatelessWidget {
  final Widget child;
  const UltraBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 48, 0, 90),
                const Color.fromARGB(255, 5, 0, 57),
                Color.fromARGB(255, 27, 0, 51),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          top: 100,
          left: 50,
          child: paintBackground(
            size: 150,
          ),
        ),
        child,
      ],
    );
  }

  /* Widget _gradientCircle({required double size, required List<Color> colors}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }*/

  Widget paintBackground({required double size}) {
    return CustomPaint(
      size: Size(size, size),
      painter: BackgroundPainter(),
    );
  }
}

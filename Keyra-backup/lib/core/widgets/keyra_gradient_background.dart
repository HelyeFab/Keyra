import 'package:flutter/material.dart';

class CurvedPainter extends CustomPainter {
  final Color color;

  CurvedPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          const Color(0xFFD586EE).withOpacity(0.2), // #d586ee
          const Color(0xFFB389F4).withOpacity(0.2), // #b389f4
          const Color(0xFF8D8CF5).withOpacity(0.2), // #8d8cf5
          const Color(0xFF608DF2).withOpacity(0.2), // #608df2
          const Color(0xFF128DEB).withOpacity(0.2), // #128deb
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.15));

    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height * 0.1);

    // Create a smooth drop shape with a single curve
    path.quadraticBezierTo(
      size.width * 0.5, // Control point x at center
      size.height * 0.15, // Control point y for deep drop
      size.width, // End point x
      size.height * 0.1, // End point y
    );

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class KeyraGradientBackground extends StatelessWidget {
  final Widget child;
  final Color? gradientColor;

  const KeyraGradientBackground({
    super.key,
    required this.child,
    this.gradientColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = gradientColor ?? Theme.of(context).colorScheme.primary;

    return Stack(
      children: [
        CustomPaint(
          painter: CurvedPainter(color: color),
          size: Size.infinite,
        ),
        child,
      ],
    );
  }
}

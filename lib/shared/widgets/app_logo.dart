import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// The Armour & Prayer mark: a gold-rimmed shield with a subtle cross,
/// composed from clean shapes — no cartoonish artwork.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Armour & Prayer emblem',
      child: SizedBox(
        width: size,
        height: size * 1.12,
        child: CustomPaint(painter: _ShieldPainter()),
      ),
    );
  }
}

class _ShieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final shieldPath = Path()
      ..moveTo(w * 0.5, 0)
      ..cubicTo(w * 0.68, h * 0.07, w * 0.88, h * 0.10, w, h * 0.10)
      ..lineTo(w, h * 0.52)
      ..cubicTo(w, h * 0.78, w * 0.72, h * 0.94, w * 0.5, h)
      ..cubicTo(w * 0.28, h * 0.94, 0, h * 0.78, 0, h * 0.52)
      ..lineTo(0, h * 0.10)
      ..cubicTo(w * 0.12, h * 0.10, w * 0.32, h * 0.07, w * 0.5, 0)
      ..close();

    final fill = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.forestGreen, AppColors.deepOlive],
      ).createShader(Offset.zero & size);
    canvas.drawPath(shieldPath, fill);

    final rim = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.045
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.softGold, AppColors.warmGold],
      ).createShader(Offset.zero & size);
    canvas.drawPath(shieldPath, rim);

    // Rays of light behind the cross.
    final ray = Paint()
      ..color = AppColors.softGold.withValues(alpha: 0.18)
      ..strokeWidth = w * 0.02
      ..strokeCap = StrokeCap.round;
    final center = Offset(w * 0.5, h * 0.40);
    for (final angle in [-0.9, -0.45, 0.0, 0.45, 0.9]) {
      final dir = Offset(
        center.dx + w * 0.34 * -angle.clamp(-1, 1),
        center.dy - h * 0.26 * (1 - angle.abs() * 0.4),
      );
      canvas.drawLine(center, dir, ray);
    }

    // The cross.
    final cross = Paint()
      ..color = AppColors.softGold
      ..strokeWidth = w * 0.085
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.5, h * 0.22), Offset(w * 0.5, h * 0.66), cross);
    canvas.drawLine(Offset(w * 0.34, h * 0.37), Offset(w * 0.66, h * 0.37), cross);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

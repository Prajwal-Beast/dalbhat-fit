import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class PulsePeakMark extends StatelessWidget {
  final Color strokeColor;
  final Color dotColor;
  final double size;

  const PulsePeakMark({
    super.key,
    this.strokeColor = AppColors.green,
    this.dotColor = AppColors.saffron,
    this.size = 64,
  });

  const PulsePeakMark.onGreen({super.key, this.size = 64})
      : strokeColor = Colors.white,
        dotColor = AppColors.saffron;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _PulsePeakPainter(strokeColor: strokeColor, dotColor: dotColor),
    );
  }
}

class _PulsePeakPainter extends CustomPainter {
  final Color strokeColor;
  final Color dotColor;

  const _PulsePeakPainter({required this.strokeColor, required this.dotColor});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 64;

    final linePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = 5 * s
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // M4 42 H16 L21 34 L26 42 L32 8 L38 42 L43 34 L48 42 H60
    final path = Path()
      ..moveTo(4 * s, 42 * s)
      ..lineTo(16 * s, 42 * s)
      ..lineTo(21 * s, 34 * s)
      ..lineTo(26 * s, 42 * s)
      ..lineTo(32 * s, 8 * s)
      ..lineTo(38 * s, 42 * s)
      ..lineTo(43 * s, 34 * s)
      ..lineTo(48 * s, 42 * s)
      ..lineTo(60 * s, 42 * s);

    canvas.drawPath(path, linePaint);

    canvas.drawCircle(
      Offset(32 * s, 8 * s),
      3.6 * s,
      Paint()..color = dotColor,
    );
  }

  @override
  bool shouldRepaint(_PulsePeakPainter old) =>
      old.strokeColor != strokeColor || old.dotColor != dotColor;
}

// App icon version — green rounded square with white mark
class PulsePeakAppIcon extends StatelessWidget {
  final double size;

  const PulsePeakAppIcon({super.key, this.size = 104});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(size * 0.23),
        boxShadow: AppColors.shadowGreen,
      ),
      child: Center(
        child: PulsePeakMark.onGreen(size: size * 0.62),
      ),
    );
  }
}

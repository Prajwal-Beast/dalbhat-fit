import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class CalorieRing extends StatefulWidget {
  final int consumed;
  final int target;

  const CalorieRing({super.key, required this.consumed, required this.target});

  @override
  State<CalorieRing> createState() => _CalorieRingState();
}

class _CalorieRingState extends State<CalorieRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    final ratio = widget.target > 0
        ? (widget.consumed / widget.target).clamp(0.0, 1.0)
        : 0.0;
    _progress = Tween<double>(begin: 0, end: ratio).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = widget.target - widget.consumed;
    final isOver = remaining < 0;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context2, child) {
        return SizedBox(
          width: 196,
          height: 196,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(196, 196),
                painter: _RingPainter(
                  progress: _progress.value,
                  isOver: isOver,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _fmt(widget.consumed),
                    style: GoogleFonts.poppins(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.0,
                      color: AppColors.ink,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'of ${_fmt(widget.target)} kcal',
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      color: AppColors.ink3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isOver
                          ? AppColors.errorSoft
                          : AppColors.successSoft,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      isOver
                          ? '${_fmt(remaining.abs())} over'
                          : '${_fmt(remaining)} left',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isOver ? AppColors.error : AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _fmt(int n) => n.abs().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
}

class _RingPainter extends CustomPainter {
  final double progress;
  final bool isOver;

  const _RingPainter({required this.progress, required this.isOver});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const r = 92.0;
    const strokeW = 17.0;
    const startAngle = -math.pi / 2;

    final trackPaint = Paint()
      ..color = const Color(0xFFEAF1ED)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(cx, cy), r, trackPaint);

    if (progress > 0) {
      final fillPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.round
        ..shader = isOver
            ? null
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.success, AppColors.green],
              ).createShader(
                Rect.fromCircle(center: Offset(cx, cy), radius: r),
              );

      if (isOver) fillPaint.color = AppColors.error;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        startAngle,
        2 * math.pi * progress,
        false,
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.isOver != isOver;
}

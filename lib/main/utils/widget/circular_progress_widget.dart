import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:flutter/material.dart';

class CircularProgressCustom extends StatelessWidget {
  final double usedGB;
  final double totalGB;

  const CircularProgressCustom({
    super.key,
    required this.usedGB,
    required this.totalGB,
  });

  @override
  Widget build(BuildContext context) {
    double progress = usedGB / totalGB;

    return SizedBox(
      width: 112,
      height: 112,
      child: CustomPaint(
        painter: _CircularProgressPainter(progress),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${usedGB.toStringAsFixed(2)} GB",
                style: AppTextFonts.poppinsMedium.copyWith(
                  fontSize: 12,
                  color: AppColors.color_1818,
                ),
              ),
              Text(
                "used",
                style: AppTextFonts.poppinsMedium.copyWith(
                  fontSize: 12,
                  color: AppColors.color_1818,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;

  _CircularProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 12.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final foregroundPaint = Paint()
      ..color = AppColors.color_E11B
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    double sweepAngle = 2 * 3.141592653589793 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      -sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget commonButton({
  required String text,
  required VoidCallback? onPressed,
  Color color = Colors.red,
  Color textColor = Colors.white,
  bool isLoading = false,
  double borderRadius = 30.0,
  double fontSize = 18.0,
  double height = 50.0,
  double? width, // Nếu null → full width
  Widget? child, // Để linh hoạt truyền child tùy chỉnh
}) {
  return SizedBox(
    width: width ?? double.infinity,
    height: height,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0,
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? CircularProgressIndicator(color: textColor, strokeWidth: 2.5)
          : child ??
                Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
    ),
  );
}

Widget viewAllHeader({
  required String title,
  required VoidCallback onViewAll,
  required BuildContext context,
  String? textAll,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: Text(
            textAll ?? AppLocalizations.of(context)!.viewAll,
            style: TextStyle(
              fontSize: 14,
              color: Colors.red,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget supportIcon(String icon, String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.pink[50],
          ),
          child: SvgPicture.asset(icon, width: 24, height: 24),
        ),
        const SizedBox(height: 8),
        Container(
          width: 90,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppStyles.poppins12Regular.copyWith(fontSize: 16),
          ),
        ),
      ],
    ),
  );
}

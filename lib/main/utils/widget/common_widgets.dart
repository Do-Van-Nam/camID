import 'package:flutter/material.dart';

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

Widget viewAllHeader({required String title, required VoidCallback onViewAll}) {
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
          child: const Text(
            "View All",
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

import 'package:cam_id/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: BottomNavPainter(),
            ),
          ),

          Positioned.fill(
            child: Row(
              children: [
                Expanded(child: _buildNavItem(0, Icons.home, AppLocalizations.of(context)!.home)),
                Expanded(child: _buildNavItem(1, Icons.card_giftcard, AppLocalizations.of(context)!.reward)),
                Expanded(child: _buildCenterItem(context)),
                Expanded(child: _buildNavItem(3, Icons.games, AppLocalizations.of(context)!.entertainment)),
                Expanded(child: _buildNavItem(4, Icons.support_agent, AppLocalizations.of(context)!.help_center)),
              ],
            ),
          ),

          Positioned(
            top: -25,
            left: MediaQuery.of(context).size.width / 2 - 25,
            child: GestureDetector(
              onTap: () => onTabSelected(2),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      spreadRadius: 2,
                      color: Colors.black26,
                    )
                  ],
                ),
                child: const Icon(Icons.wifi, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterItem(context) {
    final bool isSelected = currentIndex == 2;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTabSelected(2),
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 26),
            Text(
              AppLocalizations.of(context)!.metfone,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.red : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = index == currentIndex;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTabSelected(index),
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.red : Colors.grey),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.red : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    double width = size.width;
    double dipHeight = 25;   // nông hơn (từ 20 → 12)
    double leftDip = 0.34;   // mở rộng vết lõm
    double rightDip = 0.70;  // mở rộng vết lõm

    path.moveTo(0, 0);
    path.lineTo(width * leftDip, 0);

    // cong xuống (nông)
    path.quadraticBezierTo(
      width * 0.40,
      0,
      width * 0.45,
      dipHeight,
    );

    // phần vòng cung lớn (rộng)
    path.arcToPoint(
      Offset(width * 0.55, dipHeight),
      radius: const Radius.circular(30),  // rộng & bo mềm hơn
      clockwise: false,
    );

    // cong lên lại
    path.quadraticBezierTo(
      width * 0.60,
      0,
      width * rightDip,
      0,
    );

    path.lineTo(width, 0);
    path.lineTo(width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}



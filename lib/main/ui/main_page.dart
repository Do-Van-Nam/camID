import 'package:cam_id/main/ui/entertainment/entertainment_page.dart';
import 'package:cam_id/main/ui/help_center/help_center_page.dart';
import 'package:cam_id/main/ui/home/home_page.dart';
import 'package:cam_id/main/ui/loyalty/loyalty_page.dart';
import 'package:cam_id/main/ui/metfone/metfone_page.dart';
import 'package:cam_id/main/utils/custom_bottom_nav.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0; // Vị trí hiện tại của Bottom Navigation
  final PageController _pageController =
  PageController(); // Điều khiển PageView

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.bounceOut, // Hiệu ứng chuyển trang mượt mà
      );
    });
    _pageController.jumpToPage(index);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomePage(),
          LoyaltyPage(),
          MetFonePage(),
          EntertainmentPage(),
          HelpCenterPage(),
        ],
      ),

      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}

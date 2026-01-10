import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/entertainment/entertainment_page.dart';
import 'package:cam_id/main/ui/help_center/help_center_page.dart';
import 'package:cam_id/main/ui/home/home_page.dart';
import 'package:cam_id/main/ui/loyalty/loyalty_page.dart';
import 'package:cam_id/main/ui/metfone/metfone_page.dart';
import 'package:cam_id/main/utils/app_check.dart';
import 'package:cam_id/main/utils/app_config.dart';
import 'package:cam_id/main/utils/custom_bottom_nav.dart';
import 'package:cam_id/main/utils/widget/drawer_widget.dart';
import 'package:cam_id/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final PageController _pageController =
  PageController();

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.bounceOut,
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
      drawer: const AppDrawer(),
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
        onTabSelected: (index) async {
          if (index == 2 && await AppCheck.checkLogin(context) == false) {
            _onLogin();
            return;
          }

          setState(() => _currentIndex = index);
          _onItemTapped(index);
        },
      ),
    );
  }

  Future<void> _onLogin() async {
    // await SharePreferenceUtil.setBool(ShareKey.KEY_FIRST_OPEN_APP, false);
    await SharePreferenceUtil.setBool(ShareKey.KEY_CHANGE_OPEN_APP, true);
    if (!mounted) return;
    context.push(PATH_LOGIN);
  }
}


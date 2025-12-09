import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // cần khi dùng AutomaticKeepAliveClientMixin
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.colorMain, // Màu thanh status bar
        statusBarIconBrightness: Brightness.light, // icon trắng
        statusBarBrightness: Brightness.dark, //// icon cho hợp màu nền
      ),
      child: Scaffold(
        body: Column(
          children: [
            // Header màu vàng
            Container(
              width: double.infinity,
              height: 100,
              color: AppColors.colorMain,
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  context.push(PATH_LOGIN);
                },
                child: const Text(
                  "Home",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
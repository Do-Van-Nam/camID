import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/utils/logger.dart';
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
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final model = await SharePreferenceUtil.getUser();
    AppLogger().logInfo("Home-123 $model");
  }


  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: kToolbarHeight + MediaQuery.of(context).padding.top,
          color: AppColors.colorMain,
          alignment: Alignment.bottomLeft,
          child: IconButton(
            icon: const Icon(Icons.menu_sharp, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ],
    );
  }
}

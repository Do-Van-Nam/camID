import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/utils/widget/loading_widget.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cam_id/main/utils/utility_fuctions.dart';
import '../../../router.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          IconButton(
            icon: const Icon(Icons.help_center, color: Colors.black),
            onPressed: () {
              context.push(PATH_FEEDBACK);
            },
          ),
          // Nút mở Telegram Bot
          ElevatedButton.icon(
            icon: Icon(Icons.telegram, color: Colors.white),
            label: Text(AppLocalizations.of(context)!.telegram),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () => launchApp('https://t.me/MetfoneAdmin_bot'),
          ),

          SizedBox(height: 20),
          ElevatedButton.icon(
            icon: Icon(Icons.message, color: Colors.white),
            label: Text(AppLocalizations.of(context)!.messenger),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () => launchApp('https://m.me/210301035798660'),
          ),
        ],
      ),
    );
  }
}

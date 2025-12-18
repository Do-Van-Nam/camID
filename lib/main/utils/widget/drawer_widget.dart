import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn =
        UserInfoModel.instance.username.isNotEmpty;

    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.title_drawer,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                if (isLoggedIn)
                  Text(
                    UserInfoModel.instance.username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context)!.language),
            onTap: () {
              Navigator.of(context).pop();
              context.push(PATH_LANGUAGE);
            },
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.setting),
            onTap: () {
              Navigator.of(context).pop();
              // context.push(PATH_SETTING);
            },
          ),

          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.logout),
              onTap: () async {
                Navigator.of(context).pop();
                await SharePreferenceUtil.removeKey(ShareKey.KEY_USER_INFO);
                await SharePreferenceUtil.removeKey(ShareKey.KEY_ACCESS_TOKEN);
                await SharePreferenceUtil.removeKey(ShareKey.KEY_REFRESH_TOKEN);
                UserInfoModel.instance.clear();
                if (!context.mounted) return;
                context.go(PATH_LOGIN);
              },
            ),
        ],
      ),
    );
  }
}



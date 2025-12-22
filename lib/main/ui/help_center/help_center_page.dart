import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/utils/device_utils.dart';
import 'package:cam_id/main/utils/ipcc_channel/ipcc_channel.dart';
import 'package:cam_id/main/utils/widget/loading_widget.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../router.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage>
    with AutomaticKeepAliveClientMixin {

  bool isLoading = true;
  String camid = "";

  @override
  void initState() {
    super.initState();
    _onInitIPCC();
  }

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
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            color: AppColors.colorMain,
            alignment: Alignment.centerLeft,
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
          IconButton(
            icon: const Icon(Icons.help_center, color: Colors.black),
            onPressed: () async {
              _onShowCall();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onInitIPCC() async {
    await IpccChannel.initSdk();
  }

  Future<void> _onShowCall() async {
    String userName = UserInfoModel.instance.username;
    final camId =
    userName.isEmpty ? DeviceUtils.getDeviceName() : userName;
    await IpccChannel.showCall(camId);
  }
}

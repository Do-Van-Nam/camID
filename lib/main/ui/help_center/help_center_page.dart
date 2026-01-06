import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/utils/device_utils.dart';
import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/utils/utility_fuctions.dart';
import 'package:cam_id/main/utils/widget/common_widgets.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ipcc_plugin/ipcc_plugin.dart';
import 'package:speed_test_plugin/speed_test_plugin.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Image.asset(
          AppImages.chatbotBG,
          fit: BoxFit.cover,
          alignment: Alignment.topLeft,
        ),
        leading: GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            width: 32,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(AppImages.icDrawerMenu),
            ),
          ),
        ),

        title: Center(
          child: Column(
            children: [
              SvgPicture.asset(AppImages.icCamIDLogo, width: 24, height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Click here to login",
                    style: AppStyles.poppins12Regular.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SvgPicture.asset(
                    AppImages.icWhiteRightArrow,
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(AppImages.icSearch, width: 24, height: 24),
            onPressed: () {
              // Xử lý khi nhấn vào biểu tượng thông báo
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              AppImages.icNotification,
              width: 24,
              height: 24,
            ),
            onPressed: () {
              // Xử lý khi nhấn vào biểu tượng thông báo
            },
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(AppImages.chatbotBG, fit: BoxFit.fitWidth),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              margin: const EdgeInsets.only(top: 120),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 16),
                      child: Text(l10n.connectWithUs, style: AppStyles.header),
                    ),
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        spacing: 16,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              supportIcon(
                                AppImages.icVoiceCall,
                                l10n.voice_call,
                                () async {
                                  _onShowCall();
                                },
                              ),
                              supportIcon(
                                AppImages.icVideoCall,
                                l10n.video_call,
                                () {},
                              ),
                              supportIcon(
                                AppImages.icMessenger,
                                l10n.messenger,
                                () => launchApp('https://m.me/210301035798660'),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              supportIcon(
                                AppImages.icTele,
                                l10n.telegram,
                                () =>
                                    launchApp('https://t.me/MetfoneAdmin_bot'),
                              ),
                              supportIcon(
                                AppImages.icFeedBack,
                                l10n.feedbackTitleLabel,
                                () {
                                  context.push(PATH_HELPCENTER_FEEDBACK);
                                },
                              ),
                              supportIcon(
                                AppImages.icChatBotRed,
                                l10n.chatbotTitle,
                                () {
                                  context.push(PATH_CHATBOT_INTRO);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(l10n.support, style: AppStyles.header),
                    ),
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        spacing: 16,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              supportIcon(
                                AppImages.icFindStore,
                                l10n.find_stores,
                                () {
                                  context.push(PATH_FIND_STORES);
                                },
                              ),
                              supportIcon(
                                AppImages.icWifi,
                                l10n.network_test,
                                () async {
                                  _onShowSpeedTest();
                                },
                              ),
                              SizedBox(width: 64),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onInitIPCC() async {
    await IpccPlugin.initSdk();
  }

  Future<void> _onShowCall() async {
    String userName = UserInfoModel.instance.username;
    final camId = userName.isEmpty ? DeviceUtils.getDeviceId() : userName;
    await IpccPlugin.showCall(camId);
  }

  Future<void> _onShowSpeedTest() async {
    String phone = await SharePreferenceUtil.getString(
      ShareKey.KEY_PHONE_NUMBER,
    );
    String deviceId = DeviceUtils.getDeviceId();
    String userId = UserInfoModel.instance.userId.toString();
    String language = await SharePreferenceUtil.getLanguageCode();
    await SpeedTestPlugin.navigateSpeedTest(phone, deviceId, userId, language);
  }
}

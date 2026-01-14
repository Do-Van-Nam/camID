import 'dart:math';

import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/acount_ftth_model.dart';
import 'package:cam_id/main/data/model/banner_model.dart';
import 'package:cam_id/main/data/model/drop_down_model.dart';
import 'package:cam_id/main/data/model/ftth_package_model.dart';
import 'package:cam_id/main/data/model/tv_subscriber_model.dart';
import 'package:cam_id/main/data/repository/all_app_repository.dart';
import 'package:cam_id/main/ui/internet_wifi/internet_wifi_bloc.dart';
import 'package:cam_id/main/ui/internet_wifi/internet_wifi_event.dart';
import 'package:cam_id/main/ui/internet_wifi/internet_wifi_state.dart';
import 'package:cam_id/main/utils/widget/auto_marquee_text.widget.dart';
import 'package:cam_id/main/utils/widget/drop_down_widget.dart';
import 'package:cam_id/main/utils/widget/image_widget.dart';
import 'package:cam_id/main/utils/widget/loading_widget.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class InternetWifiPage extends StatefulWidget {
  const InternetWifiPage({super.key});
  @override
  State<InternetWifiPage> createState() => _InternetWifiPagePageState();
}

class _InternetWifiPagePageState extends State<InternetWifiPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  late final InternetWifiBloc _bloc;
  LoadingWidgetState viewState = LoadingWidgetState.success;
  DropdownModel? selectedValue;
  final phoneNumberController = TextEditingController();
  String? selectedHint;
  FTTHAccountModel? ftthAcount;
  final fakeFtthAccount = FTTHAccountModel()
    ..phoneNumber = '0987654321'
    ..customerName = 'Nguyen Van A'
    ..debit = '150000'
    ..blockDate = '2026-02-01'
    ..contractIdInfor = 'CT12345678'
    ..address = '123 Đường ABC, Quận 1, TP.HCM'
    ..contractServiceTypes = 'FTTH+TV'
    ..ftthName = 'Fiber'
    ..contractPoint = 'POINT001'
    ..level = 'Normal'
    ..packageMonth = '12'
    ..transferCurrency = 'VND'
    ..monthlyPrice = '250'
    ..ftthNameCamID = 'CAM-ID'
    ..tvSubscriber = (TvSubscriberModel()
      ..actStatus = 'ACTIVE'
      ..isdn = '0123456789'
      ..telMobile = '0901234567'
      ..productCode = 'TVPRO'
      ..contractId = 123456789
      ..subIdFtth = 987654321);
  late final List<DropdownModel> items;
  late final List<(String, String)> itemsFunc;
  List<PackageFtthModel>? listPackageFTTH = [];
  List<AdsModel>? listBannerFooter = [];
  int bannerIndex = 0;
  @override
  void initState() {
    super.initState();
    _bloc = InternetWifiBloc(AppRepository());
    _bloc.add(GetFTTHAccountEvent());
    _bloc.add(GetFTTHPackageAppsEvent());
    _bloc.add(GetAllAppsEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedValue = DropdownModel(
      l10n.internet_wifi_account,
      AppImages.icWifiFTTH,
    );
    selectedHint ??= AppLocalizations.of(
      context,
    )!.enter_your_internet_wifi_account;
    items = [
      DropdownModel(l10n.internet_wifi_account, AppImages.icWifiFTTH),
      DropdownModel(l10n.phone_number, AppImages.icPhoneFTTH),
    ];
    itemsFunc = [
      (AppImages.icFuncReferFriend, l10n.refer_friend),
      (AppImages.icFuncSpeedTest, l10n.speed_test),
      (AppImages.icFuncSupport, l10n.support),
      (AppImages.icFuncPayment, l10n.payment),
      (AppImages.icFuncFeedback, l10n.feedback),
      (AppImages.icFuncMyOrder, l10n.my_order),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<InternetWifiBloc, InternetWifiState>(
        listener: (context, state) {
          if(state is InternetWifiLoading){
            setState(() {
              viewState = LoadingWidgetState.loading;
            });
          }
          if(state is GetFTTHAccountSuccess){
            setState(() {
              viewState = LoadingWidgetState.success;
              ftthAcount = state.ftthAccount;
            });
          }

          if(state is GetFTTHAccountFailure){
            setState(() {
              viewState = LoadingWidgetState.success;
            });
          }
          if(state is GetFTTHPackagesSuccess){
            setState(() {
              listPackageFTTH = state.listPackageFTTH;
            });
          }

          if(state is GetFTTHPackagesFailure){

          }
          if (state is GetAllAppSuccess) {
            setState(() {
              listBannerFooter = state.listBanner;
            });
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.color_F7F7,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: AppColors.color_FFFF,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            centerTitle: true,
            title: Text(
              l10n.internet_wifi,
              style: AppStyles.headerBlack,
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.color_1618,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.color_F7F7,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: LoadingWidget(
                    state: viewState,
                    child: _buildBody(items),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(List<DropdownModel> items) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
          padding: EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColors.color_FFFF,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          // child: _buildNoLoginFTTH(items),
          child: ftthAcount != null ? _buildLoginFTTH() : _buildNoLoginFTTH(items),
        ),
        SizedBox(height: 16),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: Text(
            l10n.service,
            style: AppTextFonts.poppinsSemiBold.copyWith(
              fontSize: 16,
              color: AppColors.color_1618,
            ),
          ),
        ),
        SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(
            color: AppColors.color_FFFF,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            children: [
              Row(
                children: itemsFunc
                    .take(3)
                    .map((e) => buildItem(e.$1, e.$2))
                    .toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: itemsFunc
                    .skip(3)
                    .take(3)
                    .map((e) => buildItem(e.$1, e.$2))
                    .toList(),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                l10n.recommend_for_you,
                style: AppTextFonts.poppinsSemiBold.copyWith(
                  fontSize: 16,
                  color: AppColors.color_1618,
                ),
              ),
              Spacer(),
              Text(
                l10n.viewAll,
                style: AppTextFonts.poppinsMedium.copyWith(
                  fontSize: 12,
                  color: AppColors.color_E11B,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        _buildItemFTTHPackage(),
        SizedBox(height: 16),
        _buildBannerFooterSection(context, l10n),
        SizedBox(height: 40),
      ],
    );
  }

  Widget _buildNoLoginFTTH(List<DropdownModel> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.choose_an_option,
          style: AppTextFonts.poppinsSemiBold.copyWith(
            fontSize: 16,
            color: AppColors.color_1618,
          ),
        ),
        SizedBox(height: 6),
        CustomDropdownButton2<DropdownModel>(
          hint: AppLocalizations.of(context)!.select,
          value: selectedValue,
          dropdownItems: items,
          onChanged: (model) {
            setState(() {
              selectedValue = model;
              selectedHint = model?.title == l10n.internet_wifi_account
                  ? l10n.enter_your_internet_wifi_account
                  : l10n.enter_your_phone_number;
            });
          },
          buttonHeight: 50,
          buttonWidth: double.infinity,
          buttonDecoration: BoxDecoration(
            color: AppColors.color_E11B_10,
            borderRadius: BorderRadius.circular(12),
          ),
          icon: AppImages.icArrowDown,
          iconSize: 24,
          dropdownWidth: MediaQuery.of(context).size.width - 64,
          valueColor: AppColors.color_E11B,
          iconColor: AppColors.color_E11B,
          isFtth: true,
          valueTextStyle: AppTextFonts.poppinsMedium,
          itemTitle: (item) => item.title,
          itemIcon: (item) => item.icon,
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.color_F7F7,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: phoneNumberController,
            keyboardType: TextInputType.phone,
            style: AppTextFonts.poppinsMedium.copyWith(
              color: AppColors.color_1618,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: selectedHint,
              hintStyle: AppTextFonts.poppinsMedium.copyWith(
                color: AppColors.color_8588,
                fontSize: 14,
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.color_E11B,
            minimumSize: const Size.fromHeight(48),
          ),
          child: Text(
            l10n.login,
            style: AppTextFonts.poppinsSemiBold.copyWith(
              fontSize: 16,
              color: AppColors.color_FFFF,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginFTTH() {
    ftthAcount = fakeFtthAccount;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      ftthAcount?.customerName ?? "",
                      style: AppTextFonts.poppinsRegular.copyWith(
                        fontSize: 12,
                        color: AppColors.color_1618,
                      ),
                    ),
                    SvgPicture.asset(
                      AppImages.icArrowRight,
                      height: 16,
                      width: 16,
                      colorFilter: const ColorFilter.mode(
                        AppColors.color_8588,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
                Text(
                  ftthAcount?.phoneNumber ?? "",
                  style: AppTextFonts.poppinsSemiBold.copyWith(
                    fontSize: 16,
                    color: AppColors.color_1618,
                  ),
                ),
              ],
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (ftthAcount?.level ?? "").toLowerCase() == "normal"
                    ? AppColors.color_43B6_10
                    : AppColors.color_8588_10,
                borderRadius: BorderRadius.all(Radius.circular(1000)),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppImages.icStatusCircle,
                    colorFilter: ColorFilter.mode(
                      (ftthAcount?.level ?? "").toLowerCase() == "normal"
                          ? AppColors.color_43B6
                          : AppColors.color_8588,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    ftthAcount?.level ?? "",
                    style: AppTextFonts.poppinsRegular.copyWith(
                      fontSize: 13,
                      color: (ftthAcount?.level ?? "").toLowerCase() == "normal"
                          ? AppColors.color_43B6
                          : AppColors.color_8588,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.color_E11B_4,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AppImages.icSpeedNetworkV2),
                      SizedBox(width: 6),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.package,
                              style: AppTextFonts.poppinsRegular.copyWith(
                                fontSize: 12,
                                color: AppColors.color_464B,
                              ),
                            ),
                            Text(
                              ftthAcount?.ftthName ?? "",
                              style: AppTextFonts.poppinsSemiBold.copyWith(
                                fontSize: 14,
                                color: AppColors.color_1618,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.color_E11B_4,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AppImages.icSpeedNetworkV2),
                      SizedBox(width: 6),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.price,
                              style: AppTextFonts.poppinsRegular.copyWith(
                                fontSize: 12,
                                color: AppColors.color_464B,
                              ),
                            ),
                            Text(
                              l10n.months("\$${ftthAcount?.monthlyPrice}/"),
                              style: AppTextFonts.poppinsSemiBold.copyWith(
                                fontSize: 14,
                                color: AppColors.color_1618,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
        SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.color_E11B,
            minimumSize: const Size.fromHeight(44),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(AppImages.icRotateLeft, width: 20, height: 20),
              const SizedBox(width: 8),
              Text(
                l10n.change_package,
                style: AppTextFonts.poppinsMedium.copyWith(
                  fontSize: 16,
                  color: AppColors.color_FFFF,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildItem(String icon, String label) {
    return Expanded(
      child: InkWell(
        onTap: () => onServiceClick(label),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            SvgPicture.asset(icon),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextFonts.poppinsRegular.copyWith(
                fontSize: 12,
                color: AppColors.color_1618,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemFTTHPackage() {
    return SizedBox(
      height: 178,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: listPackageFTTH?.length ?? 0,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = listPackageFTTH?[index];
          EdgeInsetsGeometry padding = EdgeInsets.zero;
          if (index == 0) {
            padding = const EdgeInsets.only(left: 12);
          }
          if (index == listPackageFTTH!.length - 1) {
            padding = padding.add(const EdgeInsets.only(right: 12));
          }
          return Padding(
            padding: padding,
            child: Container(
              width: 252,
              decoration: BoxDecoration(
                color: AppColors.color_1618,
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [AppColors.color_E11B, AppColors.color_FF34],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: SvgPicture.asset(
                          AppImages.bgFTTHPackage,
                          width: double.infinity,
                          height: 44,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Center(
                            child: Text(
                              item?.name ?? '',
                              style: AppTextFonts.poppinsMedium.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.color_FFFF,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.color_E11B_4,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        AppImages.icSpeedNetwork,
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        "${item?.speed ?? 0}Mbps",
                                        style: AppTextFonts.poppinsRegular
                                            .copyWith(
                                              fontSize: 12,
                                              color: AppColors.color_E11B,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),

                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.color_E11B_4,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        AppImages.icTimer,
                                        width: 24,
                                        height: 24,
                                      ),
                                      SizedBox(height: 6),
                                      AutoMarqueeText(
                                        text: "${item?.subDescription}",
                                        style: AppTextFonts.poppinsRegular
                                            .copyWith(
                                              fontSize: 12,
                                              color: AppColors.color_E11B,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${item?.price ?? 0}',
                                      style: AppTextFonts.poppinsSemiBold
                                          .copyWith(
                                            fontSize: 20,
                                            color: AppColors.color_1618,
                                          ),
                                    ),
                                    TextSpan(
                                      text: "/month",
                                      style: AppTextFonts.poppinsRegular
                                          .copyWith(
                                            fontSize: 16,
                                            color: AppColors.color_1618,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              SizedBox(
                                width: 105,
                                height: 36,
                                child: ElevatedButton(
                                  onPressed: () => {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.color_FFFF,
                                    elevation: 0,
                                    side: const BorderSide(
                                      color: AppColors.color_1618,
                                      width: 1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1000),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                  ),
                                  child: Text(
                                    l10n.register,
                                    style: AppTextFonts.poppinsRegular.copyWith(
                                      color: AppColors.color_1618,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void onServiceClick(String label) {
    if (label == l10n.refer_friend) {
      // context.push('/referFriend');
    } else if (label == l10n.speed_test) {
      // launchUrl(Uri.parse('https://speedtest.net'));
    } else if (label == l10n.support) {
      // context.push('/support');
    } else if (label == l10n.payment) {
      // context.push('/payment');
    } else if (label == l10n.feedback) {
      // context.push('/feedback');
    } else if (label == l10n.my_order) {
      // context.push('/order');
    }
  }

  Widget _buildBannerFooterSection(
      BuildContext context,
      AppLocalizations l10n,
      ) {
    final banners = listBannerFooter ?? [];
    if (banners.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 120,
              autoPlay: true,
              viewportFraction: 1,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() => bannerIndex = index);
              },
            ),
            items: banners.map((banner) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: SafeImage(
                  url: banner.adImgUrl ?? '',
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  fit: BoxFit.cover,
                  placeholder: AppImages.imgPromotionDefault,
                  errorAsset: AppImages.imgPromotionDefault,
                ),
              );
            }).toList(),
          ),
          Positioned(
            top: 100,
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: banners.asMap().entries.map((entry) {
                final isActive = bannerIndex == entry.key;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isActive ? 30 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: isActive
                        ? AppColors.color_2121
                        : AppColors.color_E4E6,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

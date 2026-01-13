import 'dart:async';

import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/accounts_ocs_detail_v2_model.dart';
import 'package:cam_id/main/data/model/banner_model.dart';
import 'package:cam_id/main/data/model/mobile_package_model.dart';
import 'package:cam_id/main/data/model/sign_in_model.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/data/repository/all_app_repository.dart';
import 'package:cam_id/main/data/repository/service_by_group_repository.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/home/home_bloc.dart';
import 'package:cam_id/main/ui/home/home_event.dart';
import 'package:cam_id/main/ui/home/home_state.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/main/utils/package_short_des.dart';
import 'package:cam_id/main/utils/widget/app_toast_widget.dart';
import 'package:cam_id/main/utils/widget/circular_progress_widget.dart';
import 'package:cam_id/main/utils/widget/image_widget.dart';
import 'package:cam_id/main/utils/widget/loading_overlay_widget.dart';
import 'package:cam_id/main/utils/widget/loading_widget.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  late final HomeBloc _bloc;
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final phoneNumberController = TextEditingController();
  LoadingWidgetState viewState = LoadingWidgetState.success;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  int _secondsRemaining = 90;
  bool _canResend = false;
  static const int _itemsPerPage = 4;
  bool _isEnteringOTP = false;
  bool isLoggedIn = false;
  int bannerIndex = 0;
  List<AdsModel>? listBannerFooter = [];
  List<AdsModel>? listVasService = [];
  List<PackageModel>? listPackageMobile = [];
  AccountsOcsDetailV2Model? ocsBasic;
  AccountsOcsDetailV2Model? ocsData;
  AccountsOcsDetailV2Model? ocsCall;
  AccountsOcsDetailV2Model? ocsSms;
  AccountsOcsDetailV2Model? ocsRoaming;

  int _getPageCount(List items) {
    return (items.length / _itemsPerPage).ceil();
  }

  List<Map<String, String>> _buildItems(AppLocalizations l10n) {
    return [
      {'key': Constant.FUNC_FTTH, 'icon': AppImages.icFTTH, 'title': l10n.ftth},
      {'key': Constant.FUNC_ESIM, 'icon': AppImages.icEsim, 'title': l10n.esim},
      {
        'key': Constant.FUNC_MY_SERVICES,
        'icon': AppImages.icMyService,
        'title': l10n.my_services,
      },
      {
        'key': Constant.FUNC_PAYMENT_HISTORY,
        'icon': AppImages.icPaymentHistory,
        'title': l10n.payment_history,
      },
      {
        'key': Constant.FUNC_TOP_UP,
        'icon': AppImages.icTopUp,
        'title': l10n.top_up,
      },
      {
        'key': Constant.FUNC_CHARGE_HISTORY,
        'icon': AppImages.icChargeHistory,
        'title': l10n.charge_history,
      },
      {
        'key': Constant.FUNC_SCAN_CARD,
        'icon': AppImages.icScanCard,
        'title': l10n.scan_card,
      },
      {
        'key': Constant.FUNC_ACCOUNT_DETAIL,
        'icon': AppImages.icAccountDetail,
        'title': l10n.account_detail,
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    _bloc = HomeBloc(AppRepository(), ServiceRepository())..add(HomeStarted());
    _bloc.add(GetAllAppsEvent());
    _bloc.add(GetServiceByGroupAppsEvent("Recommend"));
    _bloc.add(GetAccountsOcsDetailEvent());
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bloc.close();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoading) {
            LoadingOverlayWidget.show(context);
          }
          if (state is OnTapLogin) {
            context.push(PATH_LOGIN);
          }
          if (state is OnStarted) {
            setState(() {
              isLoggedIn = state.isLoggedIn;
            });
          }
          if (state is GetAllAppSuccess) {
            setState(() {
              listBannerFooter = state.listBanner;
              listVasService = state.listVas;
            });
          }
          if (state is GetServiceByGroupSuccess) {
            setState(() {
              listPackageMobile = state.listPackage;
            });
          }
          if (state is SignUpSuccess) {
            LoadingOverlayWidget.hide();
            setState(() {
              _isEnteringOTP = true;
            });
            _bloc.add(GenerateOTPEvent(phoneNumberController.text));
            _startCountdown();
          }
          if (state is SignUpFailure) {
            LoadingOverlayWidget.hide();
            AppToast.show(context, state.message);
          }
          if (state is GetAccountsOcsDetailSuccess) {
            setState(() {
              ocsBasic = state.ocsBasic;
              ocsData = state.ocsData;
              ocsCall = state.ocsCall;
              ocsSms = state.ocsSms;
              ocsRoaming = state.ocsRoaming;
            });
          }
          if (state is SignInSuccess) {
            LoadingOverlayWidget.hide();
            _onSaveToken(state.data, _bloc);
          }
          if (state is SignInFailure) {
            LoadingOverlayWidget.hide();
            AppToast.show(context, state.message);
          }
          if (state is GetUserInfoSuccess) {
            LoadingOverlayWidget.hide();
            _onSaveUserInfo(state.user);
            _bloc.add(HomeStarted());
            _bloc.add(GetAllAppsEvent());
            _bloc.add(GetServiceByGroupAppsEvent("Recommend"));
            _bloc.add(GetAccountsOcsDetailEvent());
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: AppColors.color_0000,
          appBar: _buildAppBar(context, l10n),
          body: RefreshIndicator(
            onRefresh: () async {
              _bloc.add(GetAllAppsEvent(isCallAPI: true));
              _bloc.add(
                GetServiceByGroupAppsEvent("Recommend", isCallAPI: true),
              );
              _bloc.add(GetAccountsOcsDetailEvent());
            },
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [_buildBannerSection(context, l10n)],
                      ),
                    ),

                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(
                        width: double.infinity,
                        // padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: AppColors.color_F7F7,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: LoadingWidget(
                          state: viewState,
                          child: _buildBody(context, l10n),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSaveUserInfo(UserInfoModel? model) async {
    if (model == null) return;
    await SharePreferenceUtil.saveUser(model);
  }

  Future<void> _onSaveToken(SignInModel model, HomeBloc bloc) async {
    String token = "Bearer ${model.accessToken}";

    await SharePreferenceUtil.setString(
      ShareKey.KEY_PHONE_NUMBER,
      phoneNumberController.text,
    );
    await SharePreferenceUtil.setString(ShareKey.KEY_ACCESS_TOKEN, token);
    await SharePreferenceUtil.setString(
      ShareKey.KEY_REFRESH_TOKEN,
      model.refreshToken ?? '',
    );

    bloc.add(GetUserInfoEvent(token));
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(AppImages.icDrawerMenuV2, width: 38, height: 38),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      title: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return InkWell(
            onTap: () {
              if (isLoggedIn) {
                context.push(PATH_USER_PROFILE);
              } else {
                _bloc.add(LoginTapped());
              }
            },
            child: Column(
              children: [
                if (isLoggedIn) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        UserInfoModel.instance.fullName.isNotEmpty
                            ? UserInfoModel.instance.fullName
                            : 'UserName',
                        style: AppTextFonts.poppinsRegular.copyWith(
                          fontSize: 12,
                          color: AppColors.color_FFFF,
                        ),
                      ),
                      const SizedBox(width: 2),
                      SvgPicture.asset(
                        AppImages.icArrowRight,
                        width: 14,
                        height: 14,
                        colorFilter: const ColorFilter.mode(
                          AppColors.color_FFFF,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    Constant.normalizePhoneV2(
                      UserInfoModel.instance.phoneNumber,
                    ),
                    style: AppTextFonts.poppinsSemiBold.copyWith(
                      fontSize: 16,
                      color: AppColors.color_FFFF,
                    ),
                  ),
                ] else ...[
                  Image.asset(AppImages.imgLogoLogin, width: 96),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.title_drawer,
                        style: AppTextFonts.poppinsRegular.copyWith(
                          fontSize: 12,
                          color: AppColors.color_FFFF,
                        ),
                      ),
                      const SizedBox(width: 2),
                      SvgPicture.asset(
                        AppImages.icArrowRight,
                        width: 12,
                        height: 12,
                        colorFilter: const ColorFilter.mode(
                          AppColors.color_FFFF,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            AppImages.icNotification,
            width: 24,
            height: 24,
          ),
          onPressed: () {
            context.push(PATH_NOTIFICATION);
          },
        ),
        IconButton(
          icon: SvgPicture.asset(AppImages.icSearch, width: 24, height: 24),
          onPressed: () {
            context.push(PATH_SEARCH);
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildBannerSection(BuildContext context, AppLocalizations l10n) {
    final isEmpty = listBannerFooter == null || listBannerFooter!.isEmpty;

    return Stack(
      children: [
        if (isEmpty)
          SafeImage(
            height: 415,
            url: null,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: AppImages.imgEntertainmentDefault,
            errorAsset: AppImages.imgEntertainmentDefault,
          )
        else
          CarouselSlider(
            options: CarouselOptions(
              height: 415,
              autoPlay: true,
              viewportFraction: 1.05,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() => bannerIndex = index);
              },
            ),
            items: listBannerFooter!.map((banner) {
              return SafeImage(
                url: banner.adImgUrl,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                placeholder: AppImages.imgEntertainmentDefault,
                errorAsset: AppImages.imgEntertainmentDefault,
              );
            }).toList(),
          ),
        Container(
          width: double.infinity,
          height: 415,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                AppColors.color_0000,
              ],
              begin: Alignment.topCenter, // hướng gradient
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 212),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: isEmpty
                  ? [
                      Container(
                        width: 30,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: AppColors.color_FFFF,
                        ),
                      ),
                    ]
                  : listBannerFooter!.asMap().entries.map((entry) {
                      final isActive = bannerIndex == entry.key;
                      return Container(
                        width: isActive ? 30 : 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: isActive
                              ? AppColors.color_FFFF
                              : AppColors.color_FFFF_70,
                        ),
                      );
                    }).toList(),
            ),

            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.color_1818_80,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.color_FFFF_16, width: 1),
              ),
              child: _buildLoginSection(),
            ),

          ],
        ),
      ],
    );
  }

  Widget _buildNoLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.phone_number,
          style: AppTextFonts.poppinsRegular.copyWith(
            fontSize: 14,
            color: AppColors.color_AEAE,
          ),
        ),
        SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: AppColors.color_FFFF_10,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: phoneNumberController,
            keyboardType: TextInputType.phone,
            style: AppTextFonts.poppinsRegular.copyWith(
              color: AppColors.color_FFFF,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: l10n.enter_your_phone_number,
              hintStyle: AppTextFonts.poppinsRegular.copyWith(
                color: AppColors.color_8588,
                fontSize: 14,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (isValidCambodiaPhone(phoneNumberController.text)) {
                LoadingOverlayWidget.show(context);
                _bloc.add(
                  SignUpEvent(phoneNumberController.text, false, "123456"),
                );
              } else {
                AppToast.show(context, l10n.phone_number_is_not_valid);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.color_E11B,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
            ),
            child: Text(
              l10n.login,
              style: AppTextFonts.poppinsSemiBold.copyWith(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOTP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: l10n.otp_sent_to,
                style: AppTextFonts.poppinsRegular.copyWith(
                  fontSize: 14,
                  color: AppColors.color_BCC0,
                ),
              ),
              TextSpan(
                text: " 0313828606",
                style: AppTextFonts.poppinsSemiBold.copyWith(
                  fontSize: 14,
                  color: AppColors.color_FFFF,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4),
        InkWell(
          onTap: () {
            setState(() {
              _isEnteringOTP = false;
            });
          },
          child: Text(
            l10n.changeAccount,
            style: AppTextFonts.poppinsRegular.copyWith(
              fontSize: 14,
              color: AppColors.color_FFFF,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.color_FFFF,
            ),
          ),
        ),
        SizedBox(height: 12),
        PinCodeTextField(
          appContext: context,
          length: 6,
          keyboardType: TextInputType.number,
          animationType: AnimationType.none,
          autoFocus: true,
          textStyle: AppTextFonts.poppinsSemiBold.copyWith(
            fontSize: 24,
            color: AppColors.color_FFFF,
          ),
          enableActiveFill: true,
          cursorColor: AppColors.color_E11B,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(12),
            fieldHeight: 44,
            fieldWidth: 44,
            borderWidth: 1,
            activeBorderWidth: 1,
            selectedBorderWidth: 1,
            inactiveBorderWidth: 1,
            activeColor: AppColors.color_EF30,
            selectedColor: AppColors.color_E11B,
            inactiveColor: AppColors.color_FFFF_8,
            inactiveFillColor: AppColors.color_FFFF_8.withOpacity(0.12),
            activeFillColor: AppColors.color_FFFF_8.withOpacity(0.12),
            selectedFillColor: AppColors.color_FFFF_8.withOpacity(0.12),
          ),
          onCompleted: (value) {
            _bloc.add(SignInEvent(phoneNumberController.text, value));
          },
          onChanged: (value) {
            debugPrint('OTP đang nhập: $value');
          },
        ),
        // const SizedBox(height: 12),
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.didn_t_otp,
              style: AppTextFonts.poppinsRegular.copyWith(
                fontSize: 14,
                color: AppColors.color_BCC0,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: _canResend
                  ? () {
                      _bloc.add(GenerateOTPEvent(phoneNumberController.text));
                      _startCountdown();
                    }
                  : null,
              child: Text(
                _canResend
                    ? AppLocalizations.of(context)!.resend_otp
                    : _timeText,
                style: AppTextFonts.poppinsMedium.copyWith(
                  fontSize: 14,
                  color: AppColors.color_E11B,
                  decoration: _canResend
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor: AppColors.color_E11B,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountLogin() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.account_balance,
                    style: AppTextFonts.poppinsRegular.copyWith(
                      fontSize: 12,
                      color: AppColors.color_BCC0,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "\$${Constant.formatNumber(ocsBasic?.value ?? 0.0)}",
                    style: AppTextFonts.poppinsSemiBold.copyWith(
                      fontSize: 24,
                      color: AppColors.color_FFFF,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "${l10n.expired}: ${ocsBasic?.exp ?? ""}",
                    style: AppTextFonts.poppinsRegular.copyWith(
                      fontSize: 10,
                      color: AppColors.color_BCC0,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.colorMain,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.top_up,
                      style: AppTextFonts.poppinsSemiBold.copyWith(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: 120,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.color_ECEC,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.scan_card,
                      style: AppTextFonts.poppinsSemiBold.copyWith(
                        color: AppColors.color_1618,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            SvgPicture.asset(AppImages.icData),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.data,
                style: AppTextFonts.poppinsRegular.copyWith(
                  fontSize: 12,
                  color: AppColors.color_FFFF,
                ),
              ),
            ),
            Text(
              "${Constant.formatNumber(ocsData?.value ?? 0.0)}${Constant.MB}",
              style: AppTextFonts.poppinsSemiBold.copyWith(
                fontSize: 16,
                color: AppColors.color_E11B,
              ),
            ),
            SizedBox(width: 8),
            SvgPicture.asset(
              AppImages.icArrowRight,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                AppColors.color_8588,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginSection() {
    if (isLoggedIn) {
      return _buildAccountLogin();
    } else {
      if (_isEnteringOTP) {
        return _buildOTP();
      } else {
        return _buildNoLogin();
      }
    }
  }

  String get _timeText {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _startCountdown() {
    _secondsRemaining = 90;
    _canResend = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    final items = _buildItems(l10n);
    final pageCount = _getPageCount(items);
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
          margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          decoration: BoxDecoration(
            color: AppColors.color_FFFF,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: AppColors.color_1618_10,
                blurRadius: 12,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pageCount,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, pageIndex) {
                    final start = pageIndex * _itemsPerPage;
                    final end = (start + _itemsPerPage) > items.length
                        ? items.length
                        : start + _itemsPerPage;

                    final pageItems = items.sublist(start, end);

                    return Row(
                      children: List.generate(_itemsPerPage, (index) {
                        if (index < pageItems.length) {
                          final item = pageItems[index];
                          return _buildItem(
                            item['key']!,
                            item['icon']!,
                            item['title']!,
                          );
                        }
                        return const Expanded(child: SizedBox());
                      }),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pageCount,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: _currentPage == index ? 18 : 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.color_2121
                          : AppColors.color_E4E6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    l10n.vasService,
                    style: AppTextFonts.poppinsSemiBold.copyWith(
                      color: AppColors.color_1618,
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  Text(
                    l10n.viewAll,
                    style: AppTextFonts.poppinsMedium.copyWith(
                      color: AppColors.color_E11B,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: AppColors.color_FFFF,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.color_1618_10,
                      blurRadius: 12,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: _buildVasService(),
              ),
            ],
          ),
        ),
        if ((listPackageMobile ?? []).isNotEmpty) ...[
          SizedBox(height: 20),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Row(
                  children: [
                    Text(
                      l10n.services_for_you,
                      style: AppTextFonts.poppinsSemiBold.copyWith(
                        color: AppColors.color_1618,
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    Text(
                      l10n.viewAll,
                      style: AppTextFonts.poppinsMedium.copyWith(
                        color: AppColors.color_E11B,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12),
              _buildItemPackage(),
            ],
          ),
        ],

        SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    l10n.my_usage,
                    style: AppTextFonts.poppinsSemiBold.copyWith(
                      color: AppColors.color_1618,
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      context.push(PATH_CHARGE_HISTORY);
                    },
                    child: Text(
                      l10n.viewAll,
                      style: AppTextFonts.poppinsMedium.copyWith(
                        color: AppColors.color_E11B,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.color_FCF0,
                      AppColors.color_FFEB,
                      AppColors.color_FFEF,
                      AppColors.color_FFF7,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircularProgressCustom(
                          usedData: ocsData?.value ?? 0.0,
                          totalData: 20,
                          unit: Constant.MB,
                        ),
                        SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Data Osja Monthly",
                              style: AppTextFonts.poppinsRegular.copyWith(
                                fontSize: 12,
                                color: AppColors.color_464B,
                              ),
                            ),
                            SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "${Constant.formatNumber(ocsData?.value ?? 0.0)} ${Constant.MB}",
                                    style: AppTextFonts.poppinsSemiBold
                                        .copyWith(
                                          fontSize: 18,
                                          color: AppColors.color_1618,
                                        ),
                                  ),
                                  TextSpan(
                                    text: " ${l10n.remaining}",
                                    style: AppTextFonts.poppinsSemiBold
                                        .copyWith(
                                          fontSize: 14,
                                          color: AppColors.color_1618,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "${l10n.due_date}: ${ocsData?.exp ?? ""}",
                              style: AppTextFonts.poppinsRegular.copyWith(
                                fontSize: 12,
                                color: AppColors.color_8588,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        color: AppColors.color_FFFF,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _buildUsageInfo(
                              l10n.call,
                              Constant.formatNumber(ocsCall?.value ?? 0.0),
                              Constant.MINS,
                            ),
                          ),
                          Expanded(
                            child: _buildUsageInfo(
                              l10n.sms,
                              Constant.formatNumber(ocsSms?.value ?? 0.0),
                              Constant.SMS,
                            ),
                          ),
                          Expanded(
                            child: _buildUsageInfo(
                              l10n.roaming,
                              Constant.formatNumber(ocsRoaming?.value ?? 0.0),
                              Constant.MB,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  Widget _buildUsageInfo(String title, String value, String unit) {
    return Column(
      children: [
        Text(
          title,
          style: AppTextFonts.poppinsRegular.copyWith(
            fontSize: 10,
            color: AppColors.color_464B,
          ),
        ),
        SizedBox(height: 2),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$value ",
                style: AppTextFonts.poppinsSemiBold.copyWith(
                  fontSize: 14,
                  color: AppColors.color_E11B,
                ),
              ),
              TextSpan(
                text: unit,
                style: AppTextFonts.poppinsRegular.copyWith(
                  fontSize: 12,
                  color: AppColors.color_E11B,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemPackage() {
    final list = listPackageMobile ?? [];

    if (list.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = list[index];
          final info = parseShortDes(item.shortDes);

          EdgeInsetsGeometry padding = EdgeInsets.zero;
          if (index == 0) {
            padding = const EdgeInsets.only(left: 12);
          }
          if (index == list.length - 1) {
            padding = padding.add(const EdgeInsets.only(right: 12));
          }

          return Padding(
            padding: padding,
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [AppColors.color_E11B, AppColors.color_FF34],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 44,
                    padding: const EdgeInsets.fromLTRB(12, 15, 12, 12),
                    child: Row(
                      children: [
                        Text(
                          item.name!,
                          style: AppTextFonts.poppinsRegular.copyWith(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        if (info.isParsed)
                          Text(
                            info.data!,
                            style: AppTextFonts.poppinsSemiBold.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                      decoration: BoxDecoration(
                        color: AppColors.color_FFFF,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.color_5F5F,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '\$${Constant.formatNumber(item.price ?? 0.0)}/',
                                      style: AppTextFonts.poppinsSemiBold
                                          .copyWith(
                                            fontSize: 20,
                                            color: AppColors.color_1618,
                                          ),
                                    ),
                                    TextSpan(
                                      text: item.validity,
                                      style: AppTextFonts.poppinsRegular
                                          .copyWith(
                                            fontSize: 16,
                                            color: AppColors.color_1618,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(AppImages.icCheck),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  info.time ?? '',
                                  style: AppTextFonts.poppinsRegular.copyWith(
                                    color: AppColors.color_8588,
                                    fontSize: 12,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (info.isParsed)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(AppImages.icCheck),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    info.sms ?? '',
                                    style: AppTextFonts.poppinsRegular.copyWith(
                                      color: AppColors.color_8588,
                                      fontSize: 12,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          const Spacer(),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 36,
                            width: double.infinity,
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

  Widget _buildVasService() {
    final list = listVasService ?? [];

    if (list.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 103,
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = list[index];

          EdgeInsetsGeometry padding = EdgeInsets.zero;
          if (index == 0) {
            padding = const EdgeInsets.only(left: 12);
          }
          if (index == list.length - 1) {
            padding = padding.add(const EdgeInsets.only(right: 12));
          }

          return Padding(
            padding: padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SafeImage(
                  url: item.adImgUrl,
                  width: 54,
                  height: 54,
                  borderRadius: BorderRadius.circular(10),
                  placeholder: AppImages.imgPromotionDefault,
                  errorAsset: AppImages.imgPromotionDefault,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 72,
                  child: Text(
                    item.des ?? "",
                    textAlign: TextAlign.center,
                    style: AppTextFonts.poppinsRegular.copyWith(
                      fontSize: 12,
                      color: AppColors.color_1618,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool isValidCambodiaPhone(String phone) {
    return (phone.startsWith('+855') || phone.startsWith('0')) &&
        phone.length >= 9 &&
        phone.length <= 14;
  }

  Widget _buildItem(String key, String icon, String title) {
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTap(key),
        child: Column(
          children: [
            SvgPicture.asset(icon),
            const SizedBox(height: 6),
            SizedBox(
              height: 38,
              width: 80,
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextFonts.poppinsRegular.copyWith(
                  fontSize: 12,
                  color: AppColors.color_1618,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTap(String key) {
    switch (key) {
      case Constant.FUNC_FTTH:
        context.push(PATH_INTERNET_WIFI);
        break;
      case Constant.FUNC_ESIM:
        context.push(PATH_BUY_E_SIM);
        break;
      case Constant.FUNC_MY_SERVICES:
        context.push(PATH_METFONE_SERVICE);
        break;
      case Constant.FUNC_PAYMENT_HISTORY:
        context.push(PATH_PAYMENT_HISTORY);
        break;
      case Constant.FUNC_TOP_UP:
        context.push(PATH_TOP_UP);
        break;
      case Constant.FUNC_CHARGE_HISTORY:
        context.push(PATH_CHARGE_HISTORY);
        break;
      case Constant.FUNC_SCAN_CARD:
        context.push(PATH_SCAN_SCRATCH_CARD);
        break;
      case Constant.FUNC_ACCOUNT_DETAIL:
        context.push(PATH_ACCOUNT_DETAILS);
        break;
    }
  }
}

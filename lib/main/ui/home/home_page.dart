import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/test_package_model.dart';
import 'package:cam_id/main/data/model/test_vas_model.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/ui/home/home_bloc.dart';
import 'package:cam_id/main/ui/home/home_event.dart';
import 'package:cam_id/main/ui/home/home_state.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/main/utils/widget/circular_progress_widget.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  late final HomeBloc _bloc;
  late final l10n = AppLocalizations.of(context)!;
  final phoneNumberController = TextEditingController();
  LoadingWidgetState viewState = LoadingWidgetState.success;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> bannerImages = [
    AppImages.imgBanner1,
    AppImages.imgBanner2,
    AppImages.imgBanner3,
    AppImages.imgBanner4,
    AppImages.imgBanner5
  ];

  static const int _itemsPerPage = 4;

  int _getPageCount(List items) {
    return (items.length / _itemsPerPage).ceil();
  }

  List<Map<String, String>> _buildItems(AppLocalizations l10n) {
    return [
      {'icon': AppImages.icFTTH, 'title': l10n.ftth},
      {'icon': AppImages.icEsim, 'title': l10n.esim},
      {'icon': AppImages.icMyService, 'title': l10n.my_services},
      {'icon': AppImages.icPaymentHistory, 'title': l10n.payment_history},
    ];
  }

  final List<VasItem> _vasItems = [
    VasItem(
      title: 'Data Plus',
      imageUrl:
          AppImages.imgVasTest,
    ),
    VasItem(
      title: 'Data Plus',
      imageUrl:
      AppImages.imgVasTest,
    ),
    VasItem(
      title: 'Data Plus',
      imageUrl:
      AppImages.imgVasTest,
    ),
    VasItem(
      title: 'Data Plus',
      imageUrl:
      AppImages.imgVasTest,
    ),
    VasItem(
      title: 'Data Plus',
      imageUrl:
      AppImages.imgVasTest,
    ),
    VasItem(
      title: 'Data Plus',
      imageUrl:
      AppImages.imgVasTest,
    ),
  ];

  final List<PackageItem> _listPackage = [
    PackageItem("Data Osja Monthly ", "10GB", "18", "30 days", "1000Mins"),
    PackageItem("Data Osja 1 ", "8GB", "18", "30 days", "1000Mins"),
    PackageItem("Data Osja 2 ", "4GB", "18", "30 days", "1000Mins"),
    PackageItem("Data Osja 3 ", "13GB", "18", "30 days", "1000Mins"),
    PackageItem("Data Osja 4 ", "15GB", "18", "30 days", "1000Mins"),
  ];

  @override
  void initState() {
    super.initState();
    _bloc = HomeBloc()..add(HomeStarted());
  }

  @override
  void dispose() {
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
        // listenWhen: (prev, curr) => curr.navigateToLogin,
        listener: (context, state) {
          if (state.navigateToLogin) {
            context.push(PATH_LOGIN);
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: AppColors.color_0000,
          appBar: _buildAppBar(context, l10n),
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _buildBannerSection(context, state, l10n),
                      ],
                    ),
                  ),

                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppColors.color_F7F7,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: LoadingWidget(
                        state: viewState,
                        child: _buildBody(context, state, l10n),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
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
              if (state.isLoggedIn) {
                context.push(PATH_USER_PROFILE);
              } else {
                context.read<HomeBloc>().add(LoginTapped());
              }
            },
            child: Column(
              children: [
                if (state.isLoggedIn) ...[
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

  Widget _buildBannerSection(
    BuildContext context,
    HomeState state,
    AppLocalizations l10n,
  ) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 415,
            autoPlay: true,
            viewportFraction: 1.05,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              context.read<HomeBloc>().add(BannerChanged(index));
            },
          ),
          items: bannerImages.map((url) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // borderRadius: const BorderRadius.only(
                //   bottomLeft: Radius.circular(24),
                //   bottomRight: Radius.circular(24),
                // ),
                image: DecorationImage(
                  image: AssetImage(url),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
        ),
        Column(
          children: [
            const SizedBox(height: 212),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: bannerImages.asMap().entries.map((entry) {
                final isActive = state.bannerIndex == entry.key;
                return Container(
                  width: isActive ? 30 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: isActive ? Colors.white : Colors.grey,
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
                border: Border.all(
                  color: AppColors.color_FFFF_16, // màu border
                  width: 1,
                ),
              ),
              child: Column(
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
                      onPressed: () {},
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
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    HomeState state,
    AppLocalizations l10n,
  ) {
    final items = _buildItems(l10n);
    final pageCount = _getPageCount(items);
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
          margin: const EdgeInsets.only(top: 4),
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
                          return _buildItem(item['icon']!, item['title']!);
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
        Column(
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
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
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
              child: _buildItemVAS(),
            ),
          ],
        ),
        SizedBox(height: 20),
        Column(
          children: [
            Row(
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
            SizedBox(height: 12),
            _buildItemPackage(),
          ],
        ),
        SizedBox(height: 20),
        Column(
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
                Text(
                  l10n.viewAll,
                  style: AppTextFonts.poppinsMedium.copyWith(
                    color: AppColors.color_E11B,
                    fontSize: 12,
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
                      CircularProgressCustom(usedGB: 10.54, totalGB: 20),
                      SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Data Osja Monthly ",
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
                                  text: '20.54 GB ',
                                  style: AppTextFonts.poppinsSemiBold.copyWith(
                                    fontSize: 18,
                                    color: AppColors.color_1618,
                                  ),
                                ),
                                TextSpan(
                                  text: "remaining",
                                  style: AppTextFonts.poppinsSemiBold.copyWith(
                                    fontSize: 14,
                                    color: AppColors.color_1618,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Due Date: 19/01/2026",
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
                          child: _buildUsageInfo(l10n.call, '2000', 'MINS'),
                        ),
                        Expanded(child: _buildUsageInfo(l10n.sms, '20', 'SMS')),
                        Expanded(
                          child: _buildUsageInfo(l10n.roaming, '0', 'MB'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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
    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _listPackage.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = _listPackage[index];
          return Container(
            width: 192,
            height: 210,
            decoration: BoxDecoration(
              // color: AppColors.color_E11B,
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
                        item.name,
                        style: AppTextFonts.poppinsRegular.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Spacer(),
                      Text(
                        item.data,
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 35,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.color_5F5F,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '\$${item.price}/',
                                  style: AppTextFonts.poppinsSemiBold.copyWith(
                                    fontSize: 20,
                                    color: AppColors.color_1618,
                                  ),
                                ),
                                TextSpan(
                                  text: item.expired,
                                  style: AppTextFonts.poppinsRegular.copyWith(
                                    fontSize: 16,
                                    color: AppColors.color_1618,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SvgPicture.asset(AppImages.icCheck),
                            SizedBox(width: 8),
                            Text(
                              item.description,
                              style: AppTextFonts.poppinsRegular.copyWith(
                                color: AppColors.color_8588,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            SvgPicture.asset(AppImages.icCheck),
                            SizedBox(width: 8),
                            Text(
                              item.description,
                              style: AppTextFonts.poppinsRegular.copyWith(
                                color: AppColors.color_8588,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 36,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.color_FFFF,
                              // foregroundColor: AppColors.color_E11B,
                              elevation: 0,
                              side: const BorderSide(
                                color: AppColors.color_1618,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 4),
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
          );
        },
      ),
    );
  }

  Widget _buildItemVAS() {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _vasItems.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = _vasItems[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  item.imageUrl,
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 72,
                child: Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: AppTextFonts.poppinsMedium.copyWith(
                    fontSize: 12,
                    color: AppColors.color_1618,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildItem(String icon, String title) {
    return Expanded(
      child: Column(
        children: [
          SvgPicture.asset(icon),
          const SizedBox(height: 6),

          SizedBox(
            height: 36, // đủ cho 2 dòng
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextFonts.poppins12Regular,
            ),
          ),
        ],
      ),
    );
  }
}

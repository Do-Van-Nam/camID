import 'package:cached_network_image/cached_network_image.dart';
import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/banner_model.dart';
import 'package:cam_id/main/data/repository/all_app_repository.dart';
import 'package:cam_id/main/data/repository/service_by_group_repository.dart';
import 'package:cam_id/main/ui/metfone/metfone_bloc.dart';
import 'package:cam_id/main/ui/metfone/metfone_event.dart';
import 'package:cam_id/main/ui/metfone/metfone_state.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:cam_id/main/utils/package_short_des.dart';
import 'package:cam_id/main/utils/widget/auto_marquee_text.widget.dart';
import 'package:cam_id/main/utils/widget/image_widget.dart';
import 'package:cam_id/main/utils/widget/loading_widget.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:marquee/marquee.dart';

class MetFonePage extends StatefulWidget {
  const MetFonePage({super.key});
  @override
  State<MetFonePage> createState() => _MetFonePageState();
}

class _MetFonePageState extends State<MetFonePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final MetfoneBloc _bloc;
  late final l10n = AppLocalizations.of(context)!;
  LoadingWidgetState viewState = LoadingWidgetState.success;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _bloc = MetfoneBloc(AppRepository(), ServiceRepository());
    _bloc.add(GetAllAppsEvent());
    _bloc.add(GetServiceByGroupAppsEvent("Recommend"));
    _bloc.add(GetFTTHPackageAppsEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<MetfoneBloc, MetfoneState>(
        listener: (context, state) {
          if (state.error != null) {
            AppLogger().logError('GetAllApps error: ${state.error}');
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: AppColors.color_F7F7,
          appBar: _buildAppBar(context, l10n),
          body: RefreshIndicator(
            onRefresh: () async {
              _bloc.add(GetAllAppsEvent(isCallAPI: true));
              _bloc.add(GetServiceByGroupAppsEvent("Recommend", isCallAPI: true));
              _bloc.add(GetFTTHPackageAppsEvent());
            },
            child: BlocBuilder<MetfoneBloc, MetfoneState>(
                builder: (context, state) {
                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            _buildBannerHeaderSection(context, state, l10n),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: LoadingWidget(
                          state: viewState,
                          child: _buildBody(context, state, l10n),
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
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            AppImages.icNotificationV2,
            width: 38,
            height: 38,
          ),
          onPressed: () {
            context.push(PATH_NOTIFICATION);
          },
        ),
        IconButton(
          icon: SvgPicture.asset(AppImages.icSearchV2, width: 38, height: 38),
          onPressed: () {
            context.push(PATH_SEARCH);
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildBannerHeaderSection(
    BuildContext context,
    MetfoneState state,
    AppLocalizations l10n,
  ) {
    final banners = state.listBannerHeader ?? [];

    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 211,
            autoPlay: true,
            viewportFraction: 1.05,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              context.read<MetfoneBloc>().add(BannerHeaderChanged(index));
              _preloadNext(context, banners, index);
            },
          ),
          items: banners.map((banner) {
            return ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: SafeImage(
                url: banner.adImgUrl,
                width: MediaQuery.of(context).size.width,
                height: 211,
                fit: BoxFit.cover,
                placeholder: AppImages.imgEntertainmentDefault,
                errorAsset: AppImages.imgEntertainmentDefault,
              ),
            );
          }).toList(),
        ),
        Column(
          children: [
            const SizedBox(height: 160),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: banners.asMap().entries.map((entry) {
                final isActive = state.bannerHeaderIndex == entry.key;
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
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.color_FFFF,
                borderRadius: BorderRadius.circular(16),
                // boxShadow: const [
                //   BoxShadow(
                //     color: AppColors.color_1618_10,
                //     blurRadius: 12,
                //     offset: Offset(0, 1),
                //   ),
                // ],
              ),
              child: Row(
                children: [
                  _buildItem(AppImages.icEsim, l10n.esim),
                  _buildItem(AppImages.icTopUp, l10n.top_up),
                  _buildItem(AppImages.icTV360V2, l10n.tv360),
                  _buildItem(
                    AppImages.icExchanged,
                    l10n.exchanged_damaged_card,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBannerFooterSection(
    BuildContext context,
    MetfoneState state,
    AppLocalizations l10n,
  ) {
    final banners = state.listBannerFooter ?? [];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 120,
              autoPlay: true,
              viewportFraction: 1,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                context.read<MetfoneBloc>().add(BannerFooterChanged(index));
                _preloadNext(context, banners, index);
              },
            ),
            items: banners.map((banner) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: SafeImage(
                  url: banner.adImgUrl,
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  fit: BoxFit.cover,
                  placeholder: AppImages.imgPromotionDefault,
                  errorAsset: AppImages.imgPromotionDefault,
                ),
              );
            }).toList(),
          ),
          Column(
            children: [
              const SizedBox(height: 130),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: banners.asMap().entries.map((entry) {
                  final isActive = state.bannerFooterIndex == entry.key;
                  return Container(
                    width: isActive ? 30 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: isActive
                          ? AppColors.color_2121
                          : AppColors.color_E4E6,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    MetfoneState state,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  l10n.mobile_package,
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
          const SizedBox(height: 12),
          _buildItemPackage(state),
          const SizedBox(height: 16),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  l10n.ftth_package,
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
          const SizedBox(height: 12),
          _buildItemFTTHPackage(state),
          const SizedBox(height: 12),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  l10n.entertainment,
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
          const SizedBox(height: 12),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: _buildCustomTab(),
          ),
          const SizedBox(height: 12),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _buildTabContent(state),
            ),
          ),
          const SizedBox(height: 12),
          _buildBannerFooterSection(context, state, l10n),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTabContent(MetfoneState state) {
    return Column(
      children: [
        _buildOffstageTab(
          isActive: _selectedIndex == 0,
          child: _buildTabGame(state),
        ),
        _buildOffstageTab(
          isActive: _selectedIndex == 1,
          child: _buildTabTV360(state),
        ),
        _buildOffstageTab(
          isActive: _selectedIndex == 2,
          child: _buildTabVasService(state),
        ),
      ],
    );
  }

  Widget _buildOffstageTab({required bool isActive, required Widget child}) {
    return Offstage(
      offstage: !isActive,
      child: TickerMode(enabled: isActive, child: child),
    );
  }

  void _preloadNext(BuildContext context, List<AdsModel> banners, int index) {
    if (banners.isEmpty) return;

    final nextIndex = (index + 1) % banners.length;
    final url = banners[nextIndex].adImgUrl;

    if (url != null && url.isNotEmpty) {
      precacheImage(CachedNetworkImageProvider(url), context);
    }
  }

  Widget _buildItemFTTHPackage(MetfoneState state) {
    final packages = state.listPackageFTTH ?? [];

    if (packages.isEmpty) {
      return const SizedBox(height: 210, child: Center(child: Text('No data')));
    }

    return SizedBox(
      height: 178,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: packages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = packages[index];
          EdgeInsetsGeometry padding = EdgeInsets.zero;
          if (index == 0) {
            padding = const EdgeInsets.only(left: 12);
          }
          if (index == packages.length - 1) {
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
                              item.name!,
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
                                        "${item.speed}Mbps",
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
                                        text: "${item.subDescription}",
                                        style: AppTextFonts.poppinsRegular.copyWith(
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
                                      text: '${item.price}',
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

  Widget _buildItemPackage(MetfoneState state) {
    final packages = state.listPackageMobile ?? [];

    if (packages.isEmpty) {
      return const SizedBox(height: 210, child: Center(child: Text('No data')));
    }

    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: packages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = packages[index];
          final info = parseShortDes(item.shortDes);

          EdgeInsetsGeometry padding = EdgeInsets.zero;
          if (index == 0) {
            padding = const EdgeInsets.only(left: 12);
          }
          if (index == packages.length - 1) {
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

  Widget _buildItem(String icon, String title) {
    return Expanded(
      child: Column(
        children: [
          SvgPicture.asset(icon, width: 54, height: 54),
          const SizedBox(height: 8),
          SizedBox(
            height: 36, // đủ cho 2 dòng
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextFonts.poppinsRegular.copyWith(
                color: AppColors.color_1618,
                fontSize: 11.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTab() {
    final tabs = ['Game', 'TV360', 'Vas Service'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.color_FFFF,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: List.generate(tabs.length * 2 - 1, (i) {
          if (i.isOdd) {
            return const SizedBox(width: 6);
          }

          final index = i ~/ 2;
          final isActive = _selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedIndex = index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.color_1618 : AppColors.color_F7F7,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tabs[index],
                  style: AppTextFonts.poppinsMedium.copyWith(
                    fontSize: 14,
                    color: isActive
                        ? AppColors.color_FFFF
                        : AppColors.color_8588,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabGame(MetfoneState state) {
    final packages = state.listGame ?? [];

    if (packages.isEmpty) {
      return const SizedBox(height: 210, child: Center(child: Text('No data')));
    }

    return Container(
      height: 170,
      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: packages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = packages[index];

          EdgeInsetsGeometry padding = EdgeInsets.zero;
          if (index == 0) {
            padding = const EdgeInsets.only(left: 12);
          }
          if (index == packages.length - 1) {
            padding = padding.add(const EdgeInsets.only(right: 12));
          }

          return Padding(
            padding: padding,
            child: SizedBox(
              width: 120,
              height: 144,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeImage(
                    url: item.adImgUrl,
                    width: 120,
                    height: 120,
                    borderRadius: BorderRadius.circular(12),
                    placeholder: AppImages.imgGameDefault,
                    errorAsset: AppImages.imgGameDefault,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.des ?? "",
                    style: AppTextFonts.poppinsRegular.copyWith(
                      fontSize: 12,
                      color: AppColors.color_1E0D,
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

  Widget _buildTabTV360(MetfoneState state) {
    final packages = state.listTV360 ?? [];

    if (packages.isEmpty) {
      return const SizedBox(height: 210, child: Center(child: Text('No data')));
    }

    return Container(
      height: 253,
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: packages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = packages[index];

          EdgeInsetsGeometry padding = EdgeInsets.zero;
          if (index == 0) {
            padding = const EdgeInsets.only(left: 12);
          }
          if (index == packages.length - 1) {
            padding = padding.add(const EdgeInsets.only(right: 12));
          }

          return Padding(
            padding: padding,
            child: Container(
              width: 150,
              height: 244,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeImage(
                    url: item.adImgUrl,
                    width: 150,
                    height: 200,
                    borderRadius: BorderRadius.circular(12),
                    placeholder: AppImages.imgFilmDefault,
                    errorAsset: AppImages.imgFilmDefault,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.des ?? "",
                    style: AppTextFonts.poppinsRegular.copyWith(
                      fontSize: 12,
                      color: AppColors.color_1E0D,
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

  Widget _buildTabVasService(MetfoneState state) {
    final packages = state.listVasService ?? [];

    if (packages.isEmpty) {
      return const SizedBox(height: 210, child: Center(child: Text('No data')));
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
        itemCount: packages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = packages[index];

          EdgeInsetsGeometry padding = EdgeInsets.zero;
          if (index == 0) {
            padding = const EdgeInsets.only(left: 12);
          }
          if (index == packages.length - 1) {
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
}

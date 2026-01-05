import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/test_package_model.dart';
import 'package:cam_id/main/ui/metfone/metfone_bloc.dart';
import 'package:cam_id/main/ui/metfone/metfone_event.dart';
import 'package:cam_id/main/ui/metfone/metfone_state.dart';
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

class MetFonePage extends StatefulWidget{
  const MetFonePage({super.key});
  @override
  State<MetFonePage> createState() => _MetFonePageState();
}

class _MetFonePageState extends State<MetFonePage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  late final MetfoneBloc _bloc;
  late final l10n = AppLocalizations.of(context)!;
  LoadingWidgetState viewState = LoadingWidgetState.success;
  final List<String> bannerImages = [
    AppImages.imgBanner6,
    AppImages.imgBanner6,
    AppImages.imgBanner6,
    AppImages.imgBanner6,
    AppImages.imgBanner6
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
    _bloc = MetfoneBloc();
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

        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: AppColors.color_F7F7,
          appBar: _buildAppBar(context, l10n),
          body: BlocBuilder<MetfoneBloc, MetfoneState>(
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
                  SliverToBoxAdapter(
                    child: LoadingWidget(
                      state: viewState,
                      child: _buildBody(context, state, l10n),
                    ),
                  )
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
      MetfoneState state,
      AppLocalizations l10n,
      ) {
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
            },
          ),
          items: bannerImages.map((url) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
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
            const SizedBox(height: 160),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: bannerImages.asMap().entries.map((entry) {
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
              margin: const EdgeInsets.all(16),
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
              child: Row(
                children: [
                  _buildItem(AppImages.icEsim, l10n.esim),
                  _buildItem(AppImages.icTopUp, l10n.top_up),
                  _buildItem(AppImages.icTV360V2, l10n.tv360),
                  _buildItem(AppImages.icExchanged, l10n.exchanged_damaged_card)
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
      MetfoneState state,
      AppLocalizations l10n,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          const SizedBox(height: 12),
          _buildItemPackage(),
          const SizedBox(height: 16),
          Row(
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
          const SizedBox(height: 12),
          _buildItemFTTHPackage(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildItemFTTHPackage() {
    return SizedBox(
      height: 239,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _listPackage.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = _listPackage[index];
          return Container(
            width: 302,
            height: 239,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.color_FFFF,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    AppImages.imgBanner6,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 131,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(3,2,8,2),
                      decoration: BoxDecoration(
                        color: AppColors.color_E11B_4,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppImages.icSpeedNetwork
                          ),
                          SizedBox(width: 4),
                          Text("20Mbps",style: AppTextFonts.poppinsMedium.copyWith(
                            fontSize: 14,
                            color: AppColors.color_E11B
                          ),)
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.fromLTRB(3,2,8,2),
                      decoration: BoxDecoration(
                        color: AppColors.color_E11B_4,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                              AppImages.icDollar
                          ),
                          SizedBox(width: 4),
                          Text("\$18/month",style: AppTextFonts.poppinsMedium.copyWith(
                              fontSize: 14,
                              color: AppColors.color_E11B
                          ),)
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "HOME PLUS 1",
                          style: AppTextFonts.poppinsMedium.copyWith(
                            fontSize: 14,
                            color: AppColors.color_1618
                          ),
                        ),
                        Text(
                          "12 months + Free 2 months",
                          style: AppTextFonts.poppinsRegular.copyWith(
                              fontSize: 12,
                              color: AppColors.color_8588
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    SizedBox(
                      height: 36,
                      width: 98,
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
                )
              ],
            ),
          );
        },
      ),
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
              // style: AppTextFonts.poppins12Regular,
            ),
          ),
        ],
      ),
    );
  }
}
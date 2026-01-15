import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/ftth_package_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/language/language_bloc.dart';
import 'package:cam_id/main/ui/language/language_event.dart';
import 'package:cam_id/main/utils/dialog/ftth_package_dialog.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:cam_id/main/utils/widget/auto_marquee_text.widget.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:cam_id/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class RecommendForYouPage extends StatefulWidget {
  const RecommendForYouPage({super.key});
  @override
  State<RecommendForYouPage> createState() => _RecommendForYouPageState();
}

class _RecommendForYouPageState extends State<RecommendForYouPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  List<PackageFtthModel>? listPackageFTTH = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    listPackageFTTH = GoRouterState.of(context).extra as List<PackageFtthModel>;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.color_F7F7,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.color_FFFF,
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: kToolbarHeight,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.color_1618,
                          ),
                          onPressed: () => context.pop(),
                        ),
                      ),
                      Text(
                        l10n.recommend_for_you,
                        style: AppStyles.headerBlack,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: _buildItemFTTHPackage())
          ],
        ),
      ),
    );
  }

  Widget _buildItemFTTHPackage() {
    return SizedBox(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.vertical,
        itemCount: listPackageFTTH?.length ?? 0,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 212,
        ),
        itemBuilder: (context, index) {
          final item = listPackageFTTH?[index];
          return _buildPackageCard(item);
        },
      ),
    );
  }
  Widget _buildPackageCard(PackageFtthModel? item) {
    return Container(
      decoration: BoxDecoration(
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
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.color_E11B_4,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              SvgPicture.asset(AppImages.icSpeedNetwork),
                              const SizedBox(height: 6),
                              Text(
                                "${item?.speed ?? 0}Mbps",
                                style: AppTextFonts.poppinsRegular.copyWith(
                                  fontSize: 12,
                                  color: AppColors.color_E11B,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.color_E11B_4,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                AppImages.icTimer,
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(height: 6),
                              AutoMarqueeText(
                                text: "${item?.subDescription}",
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
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${item?.price ?? 0}',
                          style: AppTextFonts.poppinsSemiBold.copyWith(
                            fontSize: 20,
                            color: AppColors.color_1618,
                          ),
                        ),
                        TextSpan(
                          text: "/month",
                          style: AppTextFonts.poppinsRegular.copyWith(
                            fontSize: 16,
                            color: AppColors.color_1618,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 7),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => FtthPackageDialog(
                            package: item!,
                            onYes: () {
                              context.push(PATH_REGISTER_FTTH);
                            },
                          ),
                        );
                      },
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
  }

}
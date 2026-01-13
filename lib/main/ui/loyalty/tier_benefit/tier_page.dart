import 'package:cam_id/main/utils/widget/common_widgets.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'tier_bloc.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/generated/app_localizations.dart';

class TierPage extends StatefulWidget {
  const TierPage({super.key});

  @override
  State<TierPage> createState() => _TierPageState();
}

class _TierPageState extends State<TierPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => TierBloc(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: SvgPicture.asset(AppImages.icBack, width: 24, height: 24),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            l10n.tierBenefits,
            style: AppStyles.header.copyWith(color: AppColors.color_FFFF),
          ),
        ),
        body: BlocBuilder<TierBloc, TierState>(
          builder: (context, state) {
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(AppImages.chatbotBG, fit: BoxFit.fitWidth),
                ),
                SafeArea(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(height: 12),
                          _buildCurrentTierCard(context, state),
                          SizedBox(height: 24),
                          // Tier Selection
                          _buildTierSelection(context, state),
                          SizedBox(height: 24),
                          // Requirements Section
                          _buildRequirementsSection(context),
                          SizedBox(height: 24),
                          // Exclusive Privileges Section
                          _buildPrivilegesSection(context),
                          SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentTierCard(BuildContext context, TierState state) {
    final tierInfo = _getTierInfo(state.currentTier);
    final nextTierInfo = _getNextTierInfo(state.currentTier);
    final progress =
        state.currentPoints / (state.currentPoints + state.pointsNeeded);

    return AspectRatio(
      aspectRatio: 343 / 200,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.imgBronzeCard),
            fit: BoxFit.contain,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 12,
          children: [
            Spacer(),
            Text(
              tierInfo.name.toUpperCase(),
              style: AppTextFonts.poppinsBold.copyWith(
                fontSize: 20,
                color: AppColors.color_FFFF,
              ),
            ),
            Text(
              state.userName,
              style: AppTextFonts.poppinsRegular.copyWith(
                fontSize: 14,
                color: AppColors.color_FFFF,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${state.currentPoints} Points",
                  style: AppTextFonts.poppinsBold.copyWith(
                    fontSize: 18,
                    color: AppColors.color_FFFF,
                  ),
                ),
                Text(
                  "${state.usedPoints} Used points",
                  style: AppTextFonts.poppinsRegular.copyWith(
                    fontSize: 14,
                    color: AppColors.color_FFFF,
                  ),
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Color(0xFFE8D5C4),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.color_FFFF),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Upgrade to ${nextTierInfo.name}",
                      style: AppTextFonts.poppinsRegular.copyWith(
                        fontSize: 12,
                        color: AppColors.color_FFFF,
                      ),
                    ),
                    Text(
                      "Need ${state.pointsNeeded} Points",
                      style: AppTextFonts.poppinsBold.copyWith(
                        fontSize: 12,
                        color: AppColors.color_FFFF,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.color_FFFF,
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Text(
                    "View history",
                    style: AppTextFonts.poppinsMedium.copyWith(
                      fontSize: 12,
                      color: Color(0xFF333333),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierSelection(BuildContext context, TierState state) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTierBadge(
            context,
            TierType.bronze,
            AppImages.imgBronze,
            l10n.bronze,
            state.selectedTier == TierType.bronze,
            AppColors.color_8568,
          ),
          _buildTierBadge(
            context,
            TierType.silver,
            AppImages.imgSilver,
            l10n.silver,
            state.selectedTier == TierType.silver,
            AppColors.color_8588,
          ),
          _buildTierBadge(
            context,
            TierType.gold,
            AppImages.imgGold,
            l10n.gold,
            state.selectedTier == TierType.gold,
            AppColors.color_FDB9,
          ),
          _buildTierBadge(
            context,
            TierType.diamond,
            AppImages.imgDiamond,
            l10n.diamond,
            state.selectedTier == TierType.diamond,
            AppColors.color_AA87,
          ),
        ],
      ),
    );
  }

  Widget _buildTierBadge(
    BuildContext context,
    TierType tier,
    String iconPath,
    String name,
    bool isSelected,
    Color color,
  ) {
    final isActive = isSelected;
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: GestureDetector(
          onTap: () {
            context.read<TierBloc>().add(SelectTierEvent(tier));
          },
          child: Container(
            // width: 101,
            // height: 101,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive ? color.withAlpha(10) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isActive ? Border.all(color: color, width: 2) : null,
            ),
            // child: SvgPicture.asset(iconPath, width: 48, height: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(iconPath, width: 56, height: 56),
                Text(
                  name,
                  style: AppTextFonts.poppinsRegular.copyWith(
                    fontSize: 12,
                    color: isSelected ? color : AppColors.color_0000,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementsSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.requirements, style: AppStyles.header),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.color_F9FA,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      commonSvgIcon(
                        icon: AppImages.icMedalStar,
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(" 35.000", style: AppStyles.header),
                            Text(
                              l10n.pointsNeeded,
                              style: AppTextFonts.poppinsRegular.copyWith(
                                fontSize: 14,
                                color: Color(0xFF888888),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.color_F9FA,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      commonSvgIcon(
                        icon: AppImages.icTimer2,
                        width: 24,
                        height: 24,
                      ),

                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("12", style: AppStyles.header),
                            Text(
                              l10n.activePeriod,
                              style: AppTextFonts.poppinsRegular.copyWith(
                                fontSize: 14,
                                color: Color(0xFF888888),
                              ),
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
        ],
      ),
    );
  }

  Widget _buildPrivilegesSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final privileges = [
      "1. 100,000",
      "2. Prioritize prompt resolution of customer issues and complaints.",
      "3. Redeem points for rewards and partner programs.",
      "4. Deposit fee waived when increasing your credit limit up to 10 million VND.",
      "5. Dedicated customer service hotline",
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.exclusivePrivileges, style: AppStyles.header),
          SizedBox(height: 16),
          ...privileges.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                entry.value,
                style: AppTextFonts.poppinsRegular.copyWith(fontSize: 14),
              ),
            );
          }),
        ],
      ),
    );
  }

  TierInfo _getTierInfo(TierType tier) {
    switch (tier) {
      case TierType.bronze:
        return TierInfo(name: "Bronze", icon: AppImages.icBronze);
      case TierType.silver:
        return TierInfo(name: "Silver", icon: AppImages.icSilver);
      case TierType.gold:
        return TierInfo(name: "Gold", icon: AppImages.icGold);
      case TierType.diamond:
        return TierInfo(name: "Diamond", icon: AppImages.icDiamond);
    }
  }

  TierInfo _getNextTierInfo(TierType tier) {
    switch (tier) {
      case TierType.bronze:
        return TierInfo(name: "Gold", icon: AppImages.icGold);
      case TierType.silver:
        return TierInfo(name: "Gold", icon: AppImages.icGold);
      case TierType.gold:
        return TierInfo(name: "Diamond", icon: AppImages.icDiamond);
      case TierType.diamond:
        return TierInfo(name: "Diamond", icon: AppImages.icDiamond);
    }
  }
}

class TierInfo {
  final String name;
  final String icon;

  TierInfo({required this.name, required this.icon});
}

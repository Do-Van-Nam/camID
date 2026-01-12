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
        // margin: EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        padding: EdgeInsets.all(35),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.imgBronzeCard),
            fit: BoxFit.contain,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tierInfo.name.toUpperCase(),
                      style: AppTextFonts.poppinsBold.copyWith(
                        fontSize: 20,
                        color: AppColors.color_FFFF,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      state.userName,
                      style: AppTextFonts.poppinsRegular.copyWith(
                        fontSize: 14,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
                SvgPicture.asset(tierInfo.icon, width: 64, height: 64),
              ],
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${state.currentPoints} Points",
                        style: AppTextFonts.poppinsBold.copyWith(
                          fontSize: 18,
                          color: AppColors.color_FFFF,
                        ),
                      ),
                      SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: Color(0xFFE8D5C4),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFD4A574),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Upgrade to ${nextTierInfo.name}",
                        style: AppTextFonts.poppinsRegular.copyWith(
                          fontSize: 12,
                          color: Color(0xFF888888),
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
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${state.usedPoints} Used points",
                        style: AppTextFonts.poppinsRegular.copyWith(
                          fontSize: 14,
                          color: Color(0xFF888888),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFE8D5C4),
                          borderRadius: BorderRadius.circular(8),
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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTierBadge(
                context,
                TierType.bronze,
                AppImages.icBronze,
                l10n.bronze,
                state.selectedTier == TierType.bronze,
                state.currentTier == TierType.bronze,
              ),
              _buildTierBadge(
                context,
                TierType.silver,
                AppImages.icSilver,
                l10n.silver,
                state.selectedTier == TierType.silver,
                state.currentTier == TierType.silver,
              ),
              _buildTierBadge(
                context,
                TierType.gold,
                AppImages.icGold,
                l10n.gold,
                state.selectedTier == TierType.gold,
                state.currentTier == TierType.gold,
              ),
              _buildTierBadge(
                context,
                TierType.diamond,
                AppImages.icDiamond,
                l10n.diamond,
                state.selectedTier == TierType.diamond,
                state.currentTier == TierType.diamond,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTierBadge(
    BuildContext context,
    TierType tier,
    String iconPath,
    String name,
    bool isSelected,
    bool isCurrentTier,
  ) {
    final isActive = isSelected || isCurrentTier;
    return GestureDetector(
      onTap: () {
        context.read<TierBloc>().add(SelectTierEvent(tier));
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive ? Color(0xFFD4A574) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isActive
                  ? Border.all(color: Color(0xFF8B6F47), width: 2)
                  : null,
            ),
            child: SvgPicture.asset(iconPath, width: 48, height: 48),
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: AppTextFonts.poppinsRegular.copyWith(
              fontSize: 12,
              color: Color(0xFF888888),
            ),
          ),
        ],
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
          Text(
            l10n.requirements,
            style: AppTextFonts.poppinsBold.copyWith(
              fontSize: 16,
              color: Color(0xFF888888),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppImages.icMedalStar,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          AppColors.colorMain,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "${l10n.pointsNeeded} 35.000",
                          style: AppTextFonts.poppinsRegular.copyWith(
                            fontSize: 14,
                            color: Color(0xFF888888),
                          ),
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
                    color: Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppImages.icTimer2,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          AppColors.colorMain,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          " 12",
                          style: AppTextFonts.poppinsRegular.copyWith(
                            fontSize: 14,
                            color: Color(0xFF888888),
                          ),
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
      "100,000",
      "Prioritize prompt resolution of customer issues and complaints.",
      "Redeem points for rewards and partner programs.",
      "Deposit fee waived when increasing your credit limit up to 10 million VND.",
      "Dedicated customer service hotline",
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.exclusivePrivileges,
            style: AppTextFonts.poppinsBold.copyWith(
              fontSize: 16,
              color: Color(0xFF888888),
            ),
          ),
          SizedBox(height: 16),
          ...privileges.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${entry.key + 1}. ",
                    style: AppTextFonts.poppinsRegular.copyWith(
                      fontSize: 14,
                      color: Color(0xFF888888),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: AppTextFonts.poppinsRegular.copyWith(
                        fontSize: 14,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ),
                ],
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

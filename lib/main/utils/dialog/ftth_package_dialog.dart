import 'dart:math';

import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/generated/app_localizations_en.dart';
import 'package:cam_id/main/data/model/ftth_package_model.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FtthPackageDialog extends StatelessWidget {
  final PackageFtthModel package;
  final VoidCallback onYes;

  const FtthPackageDialog({
    super.key,
    required this.package,
    required this.onYes,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = package.name ?? "";
    final rawPrice = package.price ?? "";
    final price = rawPrice.startsWith("\$") ? rawPrice.substring(1) : rawPrice;
    final speed = "${package.speed ?? ''}Mbps";
    final validity = l10n.months(package.payAdvance ?? '');
    final promotion = (package.promotion ?? "")
        .replaceAll("\n", " ")
        .replaceAll("\r", " ")
        .replaceAll(RegExp(r'\s\s+'), ' ') // gom về 1 dấu cách
        .trim();
    final desc = package.description ?? "";

    return Dialog(
      backgroundColor: AppColors.color_FFFF,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: AppTextFonts.poppinsSemiBold.copyWith(
                fontSize: 16,
                color: AppColors.color_1618,
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "$price\$",
                style: AppTextFonts.poppinsSemiBold.copyWith(
                  fontSize: 24,
                  color: AppColors.color_E11B,
                ),
                children: [
                  TextSpan(
                    text: " /$validity",
                    style: AppTextFonts.poppinsRegular.copyWith(
                      fontSize: 12,
                      color: AppColors.color_8588,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _infoCard(AppImages.icWifiCircle, speed, l10n.speed),
                const SizedBox(width: 12),
                _infoCard(AppImages.icCalendarV2, validity, l10n.validity),
              ],
            ),

            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(AppImages.icInformation),
                const SizedBox(width: 6),
                Expanded(child: Text("${l10n.promotions}: $promotion")),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(AppImages.icInformation),
                const SizedBox(width: 6),
                Expanded(child: Text(desc)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.color_5F5F,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          l10n.no,
                          style: AppTextFonts.poppinsSemiBold.copyWith(
                            fontSize: 16,
                            color: AppColors.color_1618,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onYes();
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.color_E11B,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          l10n.yes,
                          style: AppTextFonts.poppinsSemiBold.copyWith(
                            fontSize: 16,
                            color: AppColors.color_FFFF,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _infoCard(String icon, String value, String label) {
    return Expanded(
      child: Container(
        // height: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.color_F9FA,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.color_F7F7, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon),
            SizedBox(height: 8),
            Text(
              value,
              style: AppTextFonts.poppinsSemiBold.copyWith(
                fontSize: 14,
                color: AppColors.color_1618,
              ),
            ),
            Text(
              label,
              style: AppTextFonts.poppinsRegular.copyWith(
                fontSize: 12,
                color: AppColors.color_464B,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

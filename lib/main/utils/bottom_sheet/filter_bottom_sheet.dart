import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<String?> showFilterBottomSheet(
    BuildContext context,
    String currentValue,
    ) {
  final List<String> options = ["today", "last7days", "last30days", "custom"];
  final l10n = AppLocalizations.of(context)!;

  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          String selected = currentValue;

          Widget buildItem(String value, String label) {
            final bool isSelected = selected == value;

            return InkWell(
              onTap: () {
                setState(() => selected = value);
                Navigator.pop(context, value);
              },
              child: SizedBox(
                height: 56,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      isSelected
                          ? AppImages.icRadioSelected
                          : AppImages.icRadioUnselected,
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: AppTextFonts.poppinsMedium.copyWith(
                        fontSize: 14,
                        color: AppColors.color_1618,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          l10n.filter,
                          style: AppTextFonts.poppinsSemiBold.copyWith(
                            fontSize: 16,
                            color: AppColors.color_1618,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset(AppImages.icClose),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: AppColors.color_F7F7),

                buildItem("today", l10n.today),
                buildItem("last7days", l10n.last7Days),
                buildItem("last30days", l10n.last30Days),
                buildItem("custom", l10n.customDay),
              ],
            ),
          );
        },
      );
    },
  );
}
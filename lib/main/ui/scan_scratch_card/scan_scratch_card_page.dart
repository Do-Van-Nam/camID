import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/language/language_bloc.dart';
import 'package:cam_id/main/ui/language/language_event.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ScanScratchCardPage extends StatefulWidget {
  const ScanScratchCardPage({super.key});
  @override
  State<ScanScratchCardPage> createState() => _ScanScratchCardPageState();
}

class _ScanScratchCardPageState extends State<ScanScratchCardPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        l10n.scan_scratch_card,
                        style: AppStyles.headerBlack,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
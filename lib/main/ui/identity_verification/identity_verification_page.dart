import 'dart:convert';
import 'dart:io';

import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/response/paper_response.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/identity_verification/identity_verification_bloc.dart';
import 'package:cam_id/main/ui/identity_verification/identity_verification_event.dart';
import 'package:cam_id/main/ui/identity_verification/identity_verification_state.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:cam_id/main/utils/widget/app_toast_widget.dart';
import 'package:cam_id/main/utils/widget/loading_overlay_widget.dart';
import 'package:cam_id/main/utils/widget/loading_widget.dart';
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

class IdentityVerificationPage extends StatefulWidget {
  final String idType;

  const IdentityVerificationPage({super.key, required this.idType});

  @override
  State<IdentityVerificationPage> createState() => _IdentityVerificationState();
}

class _IdentityVerificationState extends State<IdentityVerificationPage> {
  late final IdentityVerificationBloc _bloc;
  final List<PaperResponse> listPager = [];
  late String language = "";
  late String type;
  @override
  void initState() {
    super.initState();
    _bloc = IdentityVerificationBloc();
    type = widget.idType;
    _initData();
  }

  Future<void> _initData() async {
    final languageCode = await SharePreferenceUtil.getLanguageCode();
    setState(() {
      language = languageCode;
    });
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: AppColors.color_F7F7,
          body:
              BlocConsumer<IdentityVerificationBloc, IdentityVerificationState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      _buildHeader(context),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: PhotoItem(
                                    imagePath: state.paperFrontImage,
                                    onTap: () => _bloc.add(
                                      SelectImageEvent(PaperType.front),
                                    ),
                                    title: AppLocalizations.of(
                                      context,
                                    )!.front_side,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: PhotoItem(
                                    imagePath: state.paperBackImage,
                                    onTap: () => _bloc.add(
                                      SelectImageEvent(PaperType.back),
                                    ),
                                    title: AppLocalizations.of(
                                      context,
                                    )!.back_side,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final itemWidth =
                                    (constraints.maxWidth - 12) / 2;

                                return SizedBox(
                                  width: itemWidth,
                                  child: PhotoItem(
                                    imagePath: state.paperSelfieImage,
                                    onTap: () {
                                      _bloc.add(
                                        SelectImageEvent(PaperType.selfie),
                                      );
                                    },
                                    title: AppLocalizations.of(
                                      context,
                                    )!.portrait,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 32),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _bloc.add(ContinueEvent(language, type));
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
                            AppLocalizations.of(context)!.text_continue,
                            style: AppTextFonts.poppinsSemiBold.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                  listener: (context, state) {
                    if(state.isLoading){
                      LoadingOverlayWidget.show(context);
                    }
                    if (state.skipOcr ||
                        state.detectInfo != null ||
                        state.ocrFailed) {
                      LoadingOverlayWidget.hide();
                      context.push(
                        PATH_EDIT_INFORMATION,
                        extra: {
                          'idType': type,
                          'detectInfo': state.detectInfo,
                        },
                      );

                      _bloc.add(ResetNavigationEvent());
                    }

                    if (state.errorMessage != null) {
                      LoadingOverlayWidget.hide();
                      AppToast.show(context, state.errorMessage??AppLocalizations.of(context)!.error_occurred);
                    }
                  }
              ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
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
                AppLocalizations.of(context)!.identity_verification,
                style: AppStyles.headerBlack,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhotoItem extends StatelessWidget {
  final String? imagePath;
  final String title;
  final VoidCallback onTap;

  const PhotoItem({
    super.key,
    this.imagePath,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: title,
                style: AppTextFonts.poppinsRegular.copyWith(
                  color: AppColors.color_6161,
                  fontSize: 14,
                ),
              ),
              if (title == AppLocalizations.of(context)!.front_side)
                TextSpan(
                  text: ' *',
                  style: AppTextFonts.poppinsRegular.copyWith(
                    color: AppColors.color_E11B,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 92,
          child: Stack(
            alignment: Alignment.center,
              children: [
                  SvgPicture.asset(
                    AppImages.icBgImage,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fill,
                  ),

                  if (imagePath != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6.25, 6, 6.25, 6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(imagePath!),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              AppImages.icCambodia,
                              width: 44,
                              height: 44,
                            ),
                          ),
                        ),
                      ),
                    ),
                ]
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.color_FFFF,
              // foregroundColor: AppColors.color_E11B,
              elevation: 0,
              side: const BorderSide(color: AppColors.color_E11B_10, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1000),
              ),
              padding: const EdgeInsets.fromLTRB(10, 4, 16, 4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppImages.icCamera, width: 20, height: 20),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.take_a_photo,
                  style: AppTextFonts.poppinsRegular.copyWith(
                    color: AppColors.color_E11B,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

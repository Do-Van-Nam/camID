import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:cam_id/res/app_colors.dart';

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({super.key});

  @override
  State<UserInformationPage> createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.color_F7F7,
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: double.infinity,
          child: Image.asset(
            'assets/icons/bg_header_profile.png',
            fit: BoxFit.cover,
          ),
        ),

        Column(
          children: [
            _buildHeader(context),
            Container(color: AppColors.color_F7F7),
            const SizedBox(height: 50),
            Container(
              width: double.infinity,
              height: 11,
              margin: const EdgeInsets.symmetric(horizontal: 52),
              decoration: BoxDecoration(
                color: AppColors.color_FFFF_16,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 16,
              margin: const EdgeInsets.symmetric(horizontal: 35),
              decoration: BoxDecoration(
                color: AppColors.color_FFFF_24,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              // height: 382,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
              decoration: BoxDecoration(
                color: AppColors.color_FFFF,
                borderRadius: const BorderRadius.all(Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Constant.normalizePhoneV2(
                          UserInfoModel.instance.phoneNumber,
                        ).isEmpty
                        ? "-------"
                        : Constant.normalizePhoneV2(
                            UserInfoModel.instance.phoneNumber,
                          ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextFonts.poppinsSemiBold.copyWith(
                      color: AppColors.color_1618,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 4),
                  if (UserInfoModel.instance.verified.isNotEmpty)
                    buildIdentityStatus(
                      UserInfoModel.instance.verified,
                      context,
                    ),
                  _infoRow(
                    label: AppLocalizations.of(context)!.nationality,
                    value: UserInfoModel.instance.nationality,
                    top: 20,
                  ),
                  _infoRow(
                    label: AppLocalizations.of(context)!.gender,
                    value: UserInfoModel.instance.gender == 1
                        ? AppLocalizations.of(context)!.male
                        : UserInfoModel.instance.gender == 2
                        ? AppLocalizations.of(context)!.female
                        : "",
                    top: 20,
                  ),
                  _infoRow(
                    label: AppLocalizations.of(context)!.date_of_birth,
                    value: UserInfoModel.instance.dateOfBirth,
                    top: 20,
                  ),
                  _infoRow(
                    label: AppLocalizations.of(context)!.address,
                    value: UserInfoModel.instance.address,
                    top: 20,
                  ),
                  _infoRow(
                    label: AppLocalizations.of(context)!.id_passport_no,
                    value: UserInfoModel.instance.identityNumber,
                    top: 20,
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push(PATH_ID_TYPE);
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
                        AppLocalizations.of(context)!.update,
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
        Positioned(
          top: 120,
          left: (MediaQuery.of(context).size.width / 2) - 40,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/icons/camid_logo.png'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // height: 100,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => {context.pop()},
              ),
            ),
            Text(
              AppLocalizations.of(context)!.information,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIdentityStatus(String status, BuildContext context) {
    String text = '';
    Color backgroundColor = Colors.transparent;
    Color textColor = Colors.transparent;
    String iconPath = '';
    switch (status) {
      case Constant.APPROVE:
        text = AppLocalizations.of(context)!.identity_verified;
        backgroundColor = AppColors.color_43B6_10;
        textColor = AppColors.color_43B6;
        iconPath = 'assets/icons/ic_verified.svg';
        break;
      case Constant.PENDING:
        text = AppLocalizations.of(context)!.identity_verifying;
        backgroundColor = AppColors.color_FDB9_10;
        textColor = AppColors.color_FDB9;
        iconPath = 'assets/icons/ic_verifying.svg';
        break;
      case Constant.REJECT:
        text = AppLocalizations.of(context)!.identity_rejected;
        backgroundColor = AppColors.color_E11B_10;
        textColor = AppColors.color_E11B;
        iconPath = 'assets/icons/ic_rejected.svg';
        break;
      default:
        text = '';
        iconPath = 'assets/icons/ic_verified.svg';
    }

    return Container(
      padding: EdgeInsets.fromLTRB(12, 6, 6, 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: AppTextFonts.poppinsRegular.copyWith(
              color: textColor,
              fontSize: 12,
            ),
          ),
          SizedBox(width: 4),
          SvgPicture.asset(iconPath, width: 14, height: 14),
        ],
      ),
    );
  }

  Widget _infoRow({
    required String label,
    required String value,
    double top = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: top),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextFonts.poppinsMedium.copyWith(
                color: AppColors.color_8588,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "-------" : value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextFonts.poppinsMedium.copyWith(
                color: AppColors.color_1618,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

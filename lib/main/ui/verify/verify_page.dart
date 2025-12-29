import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/verify/verify_bloc.dart';
import 'package:cam_id/main/ui/verify/verify_event.dart';
import 'package:cam_id/main/ui/verify/verify_state.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  late final VerifyBloc _bloc;
  String phone = "";
  String language = "";
  final bool isIncorrectOTP = false;
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _bloc = VerifyBloc();
    _initData();
  }

  Future<void> _initData() async {
    final languageCode = await SharePreferenceUtil.getLanguageCode();
    final phoneNumber = await SharePreferenceUtil.getString(
      ShareKey.KEY_PHONE_NUMBER,
    );
    setState(() {
      phone = phoneNumber;
      language = languageCode;
    });
    _bloc.add(GetOTPByServiceEvent(phone, language, Constant.WS_CODE));
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: AppColors.color_F7F7,
        body: BlocConsumer<VerifyBloc, VerifyState>(
          builder: (context, state) {
            return Column(
              children: [
                Container(
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
                            AppLocalizations.of(context)!.verify,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.color_1618,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  margin: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    // border: Border.all(
                    //   color: Colors.grey.shade300,
                    // ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.otp_sent_to,
                            style: AppTextFonts.poppinsRegular.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            Constant.normalizePhoneV2(phone),
                            style: AppTextFonts.poppinsSemiBold.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      if (isIncorrectOTP) ...[
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.incorrect_pin_otp,
                          style: AppTextFonts.poppinsRegular.copyWith(
                            fontSize: 12,
                            color: AppColors.color_EF30,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.none,
                        autoFocus: true,
                        textStyle: AppTextFonts.poppinsSemiBold.copyWith(
                          fontSize: 24,
                          color: AppColors.color_EF30
                        ),
                        cursorColor: AppColors.color_EF30,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12),
                          fieldHeight: 56,
                          fieldWidth: 56,
                          activeColor: AppColors.color_EF30,
                          selectedColor: AppColors.color_EF30,
                          inactiveColor: AppColors.color_1618,
                        ),
                        onCompleted: (value) {
                          AppLogger().logInfo('OTP đầy đủ: $value');
                          _bloc.add(ConfirmOTPEvent(phone, language, Constant.WS_CODE, value));
                        },
                        onChanged: (value) {
                          debugPrint('OTP đang nhập: $value');
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.didn_t_otp,
                            style: AppTextFonts.poppinsRegular.copyWith(
                              fontSize: 14
                            ),
                          ),
                          Spacer(),
                          Text(
                            AppLocalizations.of(context)!.resend_otp,
                            style: AppTextFonts.poppinsMedium.copyWith(
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              color: AppColors.color_E11B,
                              decorationColor: AppColors.color_E11B
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          },
          listener: (context, state) {
            if (state is GetOTPByServiceSuccess) {
            } else if (state is GetOTPByServiceFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is ConfirmOTPSuccess) {
              context.push(PATH_USER_INFORMATION);
            } else if (state is ConfirmOTPFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
  }


}

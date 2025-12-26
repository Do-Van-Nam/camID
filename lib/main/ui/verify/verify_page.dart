import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/verify/verify_bloc.dart';
import 'package:cam_id/main/ui/verify/verify_event.dart';
import 'package:cam_id/main/ui/verify/verify_state.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  late final VerifyBloc _bloc;
  String phone = '';
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
    final language = await SharePreferenceUtil.getLanguageCode();
    final phoneNumber = await SharePreferenceUtil.getString(
      ShareKey.KEY_PHONE_NUMBER,
    );
    setState(() {
      phone = phoneNumber ?? '';
    });
    // _bloc.add(GetOTPByServiceEvent(phoneNumber, language, Constant.WS_CODE));
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

  Widget _buildOtpBox(int index) {
    return SizedBox(
      height: 56,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            if (_controllers[index].text.isEmpty && index > 0) {
              _controllers[index - 1].clear();
              _focusNodes[index - 1].requestFocus();
            }
          }
        },
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          cursorColor: AppColors.color_EF30,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.color_1618,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.color_EF30,
                width: 2,
              ),
            ),
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (index < 5) {
                _focusNodes[index + 1].requestFocus();
              } else {
                _focusNodes[index].unfocus();
              }
            }
          },
        ),
      ),
    );
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
                          Text(AppLocalizations.of(context)!.otp_sent_to),
                          const SizedBox(width: 6),
                          Text(
                            Constant.normalizePhoneV2(phone),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: List.generate(
                          6,
                              (index) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: _buildOtpBox(index),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
          listener: (context, state) {
            if(state is GetOTPByServiceSuccess){

            } else if(state is GetOTPByServiceFailure){
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if(state is ConfirmOTPSuccess){

            } else if(state is ConfirmOTPFailure){
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

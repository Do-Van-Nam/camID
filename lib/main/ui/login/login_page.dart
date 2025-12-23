import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/sign_in_model.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/login/login_bloc.dart';
import 'package:cam_id/main/ui/login/login_event.dart';
import 'package:cam_id/main/ui/login/login_state.dart';
import 'package:cam_id/main/utils/app_config.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:cam_id/main/utils/widget/loading_overlay_widget.dart';
import 'package:cam_id/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showOtp = false;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: Builder(builder: (context) {
        final loginBloc = BlocProvider.of<LoginBloc>(context);

        return Scaffold(
          body: BlocConsumer<LoginBloc, LoginState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 40),
                          TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.phone_number,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          if (showOtp) ...[
                            const SizedBox(height: 16),
                            TextField(
                              controller: otpController,
                              keyboardType: TextInputType.number,
                              autofillHints: const [AutofillHints.oneTimeCode],
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.enter_your_otp,
                                border: const OutlineInputBorder(),
                              ),
                            )
                          ],
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              if (!showOtp) {
                                LoadingOverlayWidget.show(context);
                                loginBloc.add(
                                  SignUpEvent(phoneController.text, false, "123456"),
                                );
                              } else {
                                LoadingOverlayWidget.show(context);
                                loginBloc.add(
                                  SignInEvent(phoneController.text, otpController.text),
                                );
                              }
                            },
                            child: Text(AppLocalizations.of(context)!.login),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onSkip,
                        child: Text(AppLocalizations.of(context)!.skip),
                      ),
                    ),
                  ],
                ),
              );
            },
            listener: (context, state) async {
              final loginBloc = BlocProvider.of<LoginBloc>(context);

              if (state is SignUpSuccess) {
                setState(() => showOtp = true);
                LoadingOverlayWidget.hide();

                loginBloc.add(GenerateOTPEvent(phoneController.text));
              }

              if (state is SignUpFailure) {
                LoadingOverlayWidget.hide();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }

              if (state is GenerateOTPSuccess || state is GenerateOTPFailure) {
                LoadingOverlayWidget.hide();
              }

              if (state is SignInSuccess) {
                LoadingOverlayWidget.hide();
                await _onSaveToken(state.data, loginBloc);
              }

              if (state is SignInFailure) {
                LoadingOverlayWidget.hide();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                AppLogger().logError("Login123: ${state.message}");
              }

              if (state is GetUserInfoSuccess) {
                LoadingOverlayWidget.hide();
                await _onSaveUserInfo(state.user);
                context.go(PATH_HOME);
              }

              if (state is GetUserInfoFailure) {
                LoadingOverlayWidget.hide();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
        );
      }),
    );
  }

  Future<void> _onSkip() async {
    await SharePreferenceUtil.setBool(ShareKey.KEY_FIRST_OPEN_APP, true);
    AppConfig.instance.isFirstOpenApp = true;
    if (!mounted) return;
    context.go(PATH_HOME);
  }

  Future<void> _onSaveToken(SignInModel model, LoginBloc bloc) async {
    String token = "Bearer ${model.accessToken}";

    await SharePreferenceUtil.setString(ShareKey.KEY_PHONE_NUMBER, phoneController.text);
    await SharePreferenceUtil.setString(ShareKey.KEY_ACCESS_TOKEN, token);
    await SharePreferenceUtil.setString(ShareKey.KEY_REFRESH_TOKEN, model.refreshToken?? '');

    bloc.add(GetUserInfoEvent(token));
  }

  Future<void> _onSaveUserInfo(UserInfoModel? model) async {
    if (model == null) return;

    AppLogger().logInfo("Home-123 ${model.username}");
    AppLogger().logInfo("Home-123 ${model.phoneNumber}");

    await SharePreferenceUtil.saveUser(model);
  }
}

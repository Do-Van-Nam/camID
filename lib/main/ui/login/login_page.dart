import 'dart:async';

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
  int resendSeconds = 60;
  Timer? resendTimer;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  @override
  void dispose() {
    resendTimer?.cancel();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) => handleBlocListener(context, state),
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(child: buildMainContent(context)),
                  buildSkipButton(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        buildPhoneInput(context),
        if (showOtp) ...[const SizedBox(height: 16), buildOtpInput(context)],
        const SizedBox(height: 24),
        buildLoginButton(context),
      ],
    );
  }

  Widget buildPhoneInput(BuildContext context) {
    return TextField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.phone_number,
        border: const OutlineInputBorder(),
        suffixIcon: showOtp ? buildChangeButton(context) : null,
      ),
    );
  }

  Widget buildChangeButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: handleChangePhone,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          minimumSize: const Size(0, 20),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: Text(
          AppLocalizations.of(context)!.change,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildOtpInput(BuildContext context) {
    return TextField(
      controller: otpController,
      keyboardType: TextInputType.number,
      autofillHints: const [AutofillHints.oneTimeCode],
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.enter_your_otp,
        border: const OutlineInputBorder(),
        suffixIcon: buildResendButton(context),
      ),
    );
  }

  Widget buildResendButton(BuildContext context) {
    final bloc = context.read<LoginBloc>();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: ElevatedButton(
        onPressed: () {
          if (resendSeconds > 0) return;

          bloc.add(GenerateOTPEvent(phoneController.text));
          startResendTimer();
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          minimumSize: const Size(40, 20),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: Text(
          resendSeconds > 0
              ? "${resendSeconds < 10 ? resendSeconds : resendSeconds.toString().padLeft(2, '0')}s"
              : AppLocalizations.of(context)!.resend,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => handleLoginPressed(context),
      child: Text(AppLocalizations.of(context)!.login),
    );
  }

  Widget buildSkipButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onSkip,
        child: Text(AppLocalizations.of(context)!.skip),
      ),
    );
  }

  void handleLoginPressed(BuildContext context) {
    final bloc = context.read<LoginBloc>();
    LoadingOverlayWidget.show(context);

    if (!showOtp) {
      bloc.add(SignUpEvent(phoneController.text, false, "123456"));
    } else {
      bloc.add(SignInEvent(phoneController.text, otpController.text));
    }
  }

  void handleChangePhone() {
    setState(() {
      showOtp = false;
      otpController.clear();
      resendTimer?.cancel();
      resendSeconds = 60;
    });
  }

  Future<void> handleBlocListener(
    BuildContext context,
    LoginState state,
  ) async {
    final bloc = context.read<LoginBloc>();

    if (state is SignUpSuccess) {
      setState(() => showOtp = true);
      startResendTimer();
      LoadingOverlayWidget.hide();
      bloc.add(GenerateOTPEvent(phoneController.text));
    }
    if (state is SignUpFailure) {
      LoadingOverlayWidget.hide();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
    }

    if (state is SignInFailure) {
      LoadingOverlayWidget.hide();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
    }

    if (state is GetUserInfoFailure) {
      LoadingOverlayWidget.hide();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
    }

    if (state is GenerateOTPSuccess || state is GenerateOTPFailure) {
      LoadingOverlayWidget.hide();
    }

    if (state is SignInSuccess) {
      LoadingOverlayWidget.hide();
      await _onSaveToken(state.data, bloc);
    }

    if (state is GetUserInfoSuccess) {
      LoadingOverlayWidget.hide();
      await _onSaveUserInfo(state.user);
      context.go(PATH_HOME);
    }
  }

  Future<void> _onSkip() async {
    await SharePreferenceUtil.setBool(ShareKey.KEY_FIRST_OPEN_APP, true);
    AppConfig.instance.isFirstOpenApp = true;
    if (!mounted) return;
    context.go(PATH_HOME);
  }

  Future<void> _onSaveToken(SignInModel model, LoginBloc bloc) async {
    String token = "Bearer ${model.accessToken}";

    await SharePreferenceUtil.setString(
      ShareKey.KEY_PHONE_NUMBER,
      phoneController.text,
    );
    await SharePreferenceUtil.setString(ShareKey.KEY_ACCESS_TOKEN, token);
    await SharePreferenceUtil.setString(
      ShareKey.KEY_REFRESH_TOKEN,
      model.refreshToken ?? '',
    );

    bloc.add(GetUserInfoEvent(token));
  }

  Future<void> _onSaveUserInfo(UserInfoModel? model) async {
    if (model == null) return;

    AppLogger().logInfo("Home-123 ${model.username}");
    AppLogger().logInfo("Home-123 ${model.phoneNumber}");

    await SharePreferenceUtil.saveUser(model);
  }

  void startResendTimer() {
    resendSeconds = 90;
    resendTimer?.cancel();
    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (resendSeconds > 0) {
          resendSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }
}

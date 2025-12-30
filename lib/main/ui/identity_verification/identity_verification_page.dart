import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/response/paper_response.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/identity_verification/identity_verification_bloc.dart';
import 'package:cam_id/main/ui/identity_verification/identity_verification_state.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  void initState() {
    super.initState();
    _bloc = IdentityVerificationBloc();
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
            body: BlocConsumer<IdentityVerificationBloc, IdentityVerificationState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      _buildHeader(context),
                    ],
                  );
                },
                listener: (context, state) {
                  if(state is DetectOCRFromImageSuccess){

                  } else if( state is DetectOCRFromImageFailure) {

                  }
                }
            )
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
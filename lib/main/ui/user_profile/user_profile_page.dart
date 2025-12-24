import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/user_profile/user_profile_bloc.dart';
import 'package:cam_id/main/ui/user_profile/user_profile_event.dart';
import 'package:cam_id/main/ui/user_profile/user_profile_state.dart';
import 'package:cam_id/main/utils/widget/loading_widget.dart';
import 'package:cam_id/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cam_id/res/app_colors.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late final UserProfileBloc _bloc;

  LoadingWidgetState viewState = LoadingWidgetState.loading;
  List<String> data = [];

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = UserProfileBloc();
    _initData();
  }

  Future<void> _initData() async {
    final token = await SharePreferenceUtil.getString(
      ShareKey.KEY_ACCESS_TOKEN,
    );

    _bloc.add(GetUserInfoEvent(token));
    // _bloc.add(GetListPaymentMethodEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        body: BlocConsumer<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
            if (state is UserProfileLoading) {
              viewState = LoadingWidgetState.loading;
            } else if (state is GetUserInfoSuccess) {
              _nameController.text = state.user?.username ?? "";
              _phoneController.text = state.user?.phoneNumber ?? "";

              viewState = LoadingWidgetState.success;
            } else if (state is GetUserInfoFailure) {
              viewState = LoadingWidgetState.error;
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: LoadingWidget(
                    state: viewState,
                    onRetry: _initData,
                    child: _buildBody(context), // gộp ở đây
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.colorMain,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: kToolbarHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.profile,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(
                          'assets/icons/camid_logo.png',
                        ),
                      ),
                    ),

                    // Icon edit
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(2),
                          child: Icon(
                            Icons.edit,
                            size: 15,
                            color: AppColors.colorMain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Text(
                    _nameController.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () => context.push(PATH_USER_INFORMATION),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.your_information,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.colorMain,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: AppColors.colorMain,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
            controller: _phoneController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.phone_number,
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.edit),
            ),
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (_, index) {
              return Card(child: ListTile(title: Text(data[index])));
            },
          ),
        ),
      ],
    );
  }
}

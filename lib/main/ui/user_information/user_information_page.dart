import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/ui/user_profile/user_profile_bloc.dart';
import 'package:cam_id/main/ui/user_profile/user_profile_state.dart';
import 'package:cam_id/main/utils/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cam_id/res/app_colors.dart';

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({super.key});

  @override
  State<UserInformationPage> createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  LoadingWidgetState viewState = LoadingWidgetState.loading;
  List<String> data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      viewState = LoadingWidgetState.loading;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final isError = false;
    final isEmpty = true;

    setState(() {
      if (isError) {
        viewState = LoadingWidgetState.error;
      } else if (isEmpty) {
        viewState = LoadingWidgetState.empty;
      } else {
        data = ['Item 1', 'Item 2', 'Item 3'];
        viewState = LoadingWidgetState.success;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileBloc(),
      child: Builder(
        builder: (context) {
          final userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
          return Scaffold(
            body: BlocConsumer<UserProfileBloc, UserProfileState>(
              builder: (context, state) {
                return Column(
                  children: [
                    _buildHeader(context),

                    Expanded(
                      child: LoadingWidget(
                        state: viewState,
                        onRetry: _loadData,
                        child: _buildContent(),
                      ),
                    ),
                  ],
                );
              },
              listener: (context, state) {},
            ),
          );
        },
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
                    AppLocalizations.of(context)!.information,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (_, index) {
        return Card(child: ListTile(title: Text(data[index])));
      },
    );
  }
}

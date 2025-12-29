import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/other_payment_method_model.dart';
import 'package:cam_id/main/data/model/sevice_model.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/data/response/linked_emoney_response.dart';
import 'package:cam_id/main/data/response/payment_method_response.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/user_profile/user_profile_bloc.dart';
import 'package:cam_id/main/ui/user_profile/user_profile_event.dart';
import 'package:cam_id/main/ui/user_profile/user_profile_state.dart';
import 'package:cam_id/main/utils/bottom_sheet/other_payment_bottom_sheet.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/main/utils/logger.dart';
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
  List<ServiceModel> dataService = [];
  List<OtherPaymentMethodModel> dataMethod = [];
  String directUrlEMoney = "";
  String termsAndCondition = "";

  final TextEditingController _phoneController = TextEditingController();

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
    final language = await SharePreferenceUtil.getLanguageCode();
    final phoneNumber = await SharePreferenceUtil.getString(
      ShareKey.KEY_PHONE_NUMBER,
    );

    _bloc.add(GetUserInfoEvent(token));
    _bloc.add(
      CheckLinkedPaymentEmoneyEvent(
        UserInfoModel.instance.userId.toString(),
        phoneNumber,
        language,
      ),
    );
    _bloc.add(
      GetListPaymentMethodEvent(
        UserInfoModel.instance.userId.toString(),
        Constant.PROFILE,
        language,
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    _phoneController.dispose();
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
              setState(() {
                _phoneController.text = Constant.normalizePhoneV2(
                  state.user?.phoneNumber,
                );
                dataService = state.services ?? [];
              });

              viewState = LoadingWidgetState.success;
            } else if (state is GetUserInfoFailure) {
              viewState = LoadingWidgetState.success;
              viewState = LoadingWidgetState.error;
            } else if (state is CheckLinkedPaymentEmoneySuccess) {
              _onSuccessCheckPayment(state.result);
            } else if (state is CheckLinkedPaymentEmoneyFailure) {
              AppLogger().logError(state.message);
            } else if (state is GetListPaymentMethodSuccess) {
              _onSuccessListPaymentMethod(state.response);
              AppLogger().logInfo(state.response?.termsAndCondition ?? "");
            } else if (state is CheckLinkedPaymentEmoneyFailure) {
              AppLogger().logError(state.message);
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
                    child: _buildBody(context),
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
                    _phoneController.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () => context.push(PATH_VERIFY),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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

            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dataService.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return buildServiceItem(dataService[index]);
              },
            ),

            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => OtherPaymentBottomSheet(
                    listPaymentMethod: dataMethod,
                    termsAndCondition: termsAndCondition,
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                padding: const EdgeInsets.fromLTRB(8, 10, 10, 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.add, size: 40, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.link_bank_account,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.link_aba_account_credit_debit_card,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Image.asset(
                            'assets/icons/ic_list_payment_method_temp.png',
                            width: 190,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildServiceItem(ServiceModel service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                service.serviceName ?? "",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),

              InkWell(
                onTap: () {
                  _onClickAddAnother(service);
                },
                child: Text(
                  AppLocalizations.of(context)!.add_another,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.color_1961,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          if (service.phoneLinkedList?.isNotEmpty == true)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Image.asset("assets/icons/ic_en.png", width: 28, height: 28),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      Constant.normalizePhoneV2(
                        service.phoneLinkedList?.isNotEmpty == true
                            ? service.phoneLinkedList![0].phoneNumber ?? ""
                            : "",
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (service.serviceName?.toLowerCase() == 'ftth')
                    Icon(Icons.qr_code, color: AppColors.color_1961),

                  if (service.phoneLinkedList?.isNotEmpty == true) ...[
                    if (Constant.normalizePhone(_phoneController.text) !=
                        Constant.normalizePhone(
                          service.phoneLinkedList!.first.phoneNumber ?? '',
                        ))
                      Icon(Icons.delete, color: AppColors.color_1961),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _onSuccessCheckPayment(CheckLinkResult? result) {
    setState(() {
      directUrlEMoney = result?.directUrl ?? "";
    });
  }

  void _onSuccessListPaymentMethod(PaymentMethodResponse? response) {
    setState(() {
      dataMethod =
          response?.otherLinkPaymentMethodList ?? <OtherPaymentMethodModel>[];
      termsAndCondition = response?.termsAndCondition ?? "";
    });
  }

  void _onClickAddAnother(ServiceModel service) {}
}

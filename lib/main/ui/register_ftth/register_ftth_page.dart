import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/province_model.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/ui/register_ftth/register_ftth_bloc.dart';
import 'package:cam_id/main/ui/register_ftth/register_ftth_event.dart';
import 'package:cam_id/main/ui/register_ftth/register_ftth_state.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/main/utils/widget/app_toast_widget.dart';
import 'package:cam_id/main/utils/widget/loading_overlay_widget.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RegisterFtthPage extends StatefulWidget {
  const RegisterFtthPage({super.key});
  @override
  State<RegisterFtthPage> createState() => _RegisterFtthPageState();
}

class _RegisterFtthPageState extends State<RegisterFtthPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  late final RegisterFTTHBloc _bloc;

  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  String storeAddress = "";
  LatLng? currentLatLng;
  GoogleMapController? mapController;
  List<ProvinceModel> listProvince = [];
  bool isShowDropdown = false;
  String? selectedProvinceCode;
  @override
  void initState() {
    super.initState();
    _bloc = RegisterFTTHBloc();
    _bloc.add(GetListProvinceEvent());
    phoneNumberController.addListener(() => setState(() {}));
    getCurrentLocation();
    nameController.text = UserInfoModel.instance.fullName;
    phoneNumberController.text = Constant.normalizePhoneV2(UserInfoModel.instance.phoneNumber);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentLatLng = LatLng(pos.latitude, pos.longitude);
    });

    List<Placemark> placeMarks = await placemarkFromCoordinates(
      pos.latitude,
      pos.longitude,
    );
    if (placeMarks.isNotEmpty) {
      final p = placeMarks.first;
      setState(() {
        addressController.text =
            "${p.street}, ${p.subAdministrativeArea}, ${p.administrativeArea}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<RegisterFTTHBloc, RegisterFtthState>(
        listener: (context, state) {
          if (state is RegisterFtthLoading) {
            LoadingOverlayWidget.show(context);
          }
          if (state is GetListProvinceSuccess) {
            LoadingOverlayWidget.hide();
            setState(() {
              listProvince = state.listProvince;
            });
          }
          if (state is GetListProvinceFailure) {
            LoadingOverlayWidget.hide();
          }
          if (state is GenerateOTPFTTHSuccess) {
            LoadingOverlayWidget.hide();
          }
          if (state is GenerateOTPFTTHFailure) {
            LoadingOverlayWidget.hide();
            AppToast.show(context, state.message.isNotEmpty ? state.message : l10n.error_occurred);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.color_F7F7,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: AppColors.color_FFFF,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            centerTitle: true,
            title: Text(l10n.register, style: AppStyles.headerBlack),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.color_1618,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          resizeToAvoidBottomInset: true,
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.color_FFFF,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.nameLabel,
              style: AppTextFonts.poppinsRegular.copyWith(
                fontSize: 14,
                color: AppColors.color_8588,
              ),
            ),
            SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                color: AppColors.color_F7F7,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: nameController,
                style: AppTextFonts.poppinsMedium.copyWith(
                  color: AppColors.color_1618,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: l10n.nameHint,
                  hintStyle: AppTextFonts.poppinsMedium.copyWith(
                    color: AppColors.color_8588,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: l10n.phone_number,
                    style: AppTextFonts.poppinsRegular.copyWith(
                      color: AppColors.color_8588,
                      fontSize: 14,
                    ),
                  ),
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
            SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                color: AppColors.color_F7F7,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                style: AppTextFonts.poppinsMedium.copyWith(
                  color: AppColors.color_1618,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: l10n.enter_your_phone_number,
                  hintStyle: AppTextFonts.poppinsMedium.copyWith(
                    color: AppColors.color_8588,
                    fontSize: 14,
                  ),
                  suffixIconConstraints: BoxConstraints(
                    maxHeight: 20,
                    maxWidth: 40,
                  ),
                  suffixIcon: phoneNumberController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            phoneNumberController.clear();
                            setState(() {});
                          },
                          child: SvgPicture.asset(
                            AppImages.icClose,
                            width: 20,
                            height: 20,
                          ),
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: l10n.address,
                    style: AppTextFonts.poppinsRegular.copyWith(
                      color: AppColors.color_8588,
                      fontSize: 14,
                    ),
                  ),
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
            SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                setState(() {
                  isShowDropdown = !isShowDropdown;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.color_F7F7,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        storeAddress.isNotEmpty
                            ? storeAddress
                            : l10n.province_city,
                        style: AppTextFonts.poppinsMedium.copyWith(
                          fontSize: 14,
                          color: storeAddress.isNotEmpty
                              ? AppColors.color_1618
                              : AppColors.color_8588,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8),
                    SvgPicture.asset(AppImages.icArrowDown),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isShowDropdown,
              child: buildProvinceSelectView(
                provinces: listProvince,
                selectedCode: selectedProvinceCode,
                onSelected: (p) {
                  setState(() {
                    selectedProvinceCode = p.provinceCode;
                    storeAddress = p.provinceName!;
                    isShowDropdown = false;
                  });
                },
              ),
            ),
            Visibility(
              visible: !isShowDropdown,
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Container(
                    height: 180,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: currentLatLng == null
                        ? Center(child: CircularProgressIndicator())
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: currentLatLng!,
                                zoom: 16,
                              ),
                              onMapCreated: (controller) =>
                                  mapController = controller,
                              myLocationEnabled: true,
                              markers: {
                                Marker(
                                  markerId: MarkerId("current"),
                                  position: currentLatLng!,
                                  infoWindow: InfoWindow(
                                    title: l10n.your_location,
                                  ),
                                ),
                              },
                            ),
                          ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    l10n.your_address,
                    style: AppTextFonts.poppinsRegular.copyWith(
                      fontSize: 14,
                      color: AppColors.color_8588,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.color_F7F7,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: addressController,
                      style: AppTextFonts.poppinsMedium.copyWith(
                        color: AppColors.color_1618,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: l10n.enter_your_full_address,
                        hintStyle: AppTextFonts.poppinsMedium.copyWith(
                          color: AppColors.color_8588,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AppImages.icInformation),
                      SizedBox(width: 8),
                      Text(
                        l10n.content_address,
                        style: AppTextFonts.poppinsRegular.copyWith(
                          fontSize: 12,
                          color: AppColors.color_E11B,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if(!isValidCambodiaPhone(phoneNumberController.text)){
                        AppToast.show(context, AppLocalizations.of(context)!.phone_number_is_not_valid);
                        return;
                      }
                      if(storeAddress.isEmpty){
                        AppToast.show(context, AppLocalizations.of(context)!.pls_select_address);
                        return;
                      }
                      if(UserInfoModel.instance.username.isNotEmpty){
                        _bloc.add(GenerateOTPFTTHEvent(phoneNumberController.text));
                      } else {

                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.color_E11B,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: Text(
                      l10n.get_otp,
                      style: AppTextFonts.poppinsSemiBold.copyWith(
                        fontSize: 16,
                        color: AppColors.color_FFFF,
                      ),
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

  Widget buildProvinceSelectView({
    required List<ProvinceModel> provinces,
    required Function(ProvinceModel) onSelected,
    String? selectedCode,
  }) {
    String query = '';

    return StatefulBuilder(
      builder: (context, setState) {
        final filtered = provinces
            .where(
              (p) =>
                  p.provinceName!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.choose_your_address,
                style: AppTextFonts.poppinsSemiBold.copyWith(
                  fontSize: 16,
                  color: AppColors.color_1618,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.color_F7F7,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  keyboardType: TextInputType.text,
                  style: AppTextFonts.poppinsMedium.copyWith(
                    color: AppColors.color_1618,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,

                    hintText: l10n.search,
                    hintStyle: AppTextFonts.poppinsMedium.copyWith(
                      color: AppColors.color_8588,
                      fontSize: 14,
                    ),

                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 4, right: 8),
                      child: SvgPicture.asset(
                        AppImages.icSearch,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          AppColors.color_1618,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                    onChanged: (v) => setState(() => query = v),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (_, index) {
                    final item = filtered[index];
                    final isSelected = selectedCode == item.provinceCode;

                    return GestureDetector(
                      onTap: () => onSelected(item),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              isSelected
                                  ? AppImages.icRadioSelected
                                  : AppImages.icRadioUnselected,
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.provinceName ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool isValidCambodiaPhone(String phone) {
    return (phone.startsWith('+855') || phone.startsWith('0')) &&
        phone.length >= 9 &&
        phone.length <= 14;
  }
}

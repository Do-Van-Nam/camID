import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/detect_info_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/edit_information/edit_information_bloc.dart';
import 'package:cam_id/main/ui/edit_information/edit_information_state.dart';
import 'package:cam_id/main/utils/widget/drop_down_widget.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EditInformationPage extends StatefulWidget {
  final String? idType;
  final DetectInfoModel? detectInfo;

  const EditInformationPage({super.key, this.idType, this.detectInfo});

  @override
  State<EditInformationPage> createState() => _EditInformationState();
}

class _EditInformationState extends State<EditInformationPage> {
  late final EditInformationBloc _bloc;
  final fullNameController = TextEditingController();
  final idPassportNoController = TextEditingController();
  final dateController = TextEditingController();
  String? selectedGender;
  final addressController = TextEditingController();
  String? selectedValue;
  final List<String> items = ['Apple', 'Banana', 'Orange'];
  @override
  void initState() {
    super.initState();
    _bloc = EditInformationBloc();
    selectedGender = "Male";
    _initData();
  }

  Future<void> _initData() async {
    final languageCode = await SharePreferenceUtil.getLanguageCode();
  }

  @override
  void dispose() {
    _bloc.close();
    fullNameController.dispose();
    idPassportNoController.dispose();
    dateController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      dateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.color_F7F7,
          body: BlocConsumer<EditInformationBloc, EditInformationState>(
            builder: (context, state) {
              return Column(
                children: [
                  _buildHeader(context),
                  _buildBody(context),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 32),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.color_E11B,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.save,
                        style: AppTextFonts.poppinsSemiBold.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            listener: (context, state) {},
          ),
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
                AppLocalizations.of(context)!.select_id_type,
                style: AppStyles.headerBlack,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabelWithAsterisk(
            context,
            AppLocalizations.of(context)!.full_name,
          ),
          const SizedBox(height: 4),
          _buildInputField(
            controller: fullNameController,
            hint: AppLocalizations.of(context)!.enter_your_full_name,
          ),
          const SizedBox(height: 16),
          _buildLabelWithAsterisk(
            context,
            AppLocalizations.of(context)!.id_passport_no,
          ),
          const SizedBox(height: 4),
          _buildInputField(
            controller: idPassportNoController,
            hint: AppLocalizations.of(context)!.enter_your_id,
          ),
          const SizedBox(height: 16),
          _buildLabelWithAsterisk(
            context,
            AppLocalizations.of(context)!.date_of_birth,
          ),
          const SizedBox(height: 4),
          _buildDateField(context),
          const SizedBox(height: 16),
          _buildLabelWithAsterisk(
            context,
            AppLocalizations.of(context)!.gender,
          ),
          const SizedBox(height: 16),
          _buildGenderRadioGroup(),
          const SizedBox(height: 16),
          _buildLabelWithAsterisk(
            context,
            AppLocalizations.of(context)!.nationality,
          ),
          const SizedBox(height: 4),
          CustomDropdownButton2(
            hint: AppLocalizations.of(context)!.select,
            value: selectedValue,
            dropdownItems: items,
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
            },
            buttonHeight: 50,
            buttonWidth: double.infinity,
            buttonDecoration: BoxDecoration(
              color: AppColors.color_5F5F,
              borderRadius: BorderRadius.circular(14),
            ),
            icon: AppImages.icArrowDown,
            iconSize: 24,
            dropdownWidth: MediaQuery.of(context).size.width - 64,
          ),

          const SizedBox(height: 16),

          _buildLabelWithAsterisk(
            context,
            AppLocalizations.of(context)!.address,
          ),
          const SizedBox(height: 4),
          _buildInputFieldAddress(
            controller: addressController,
            hint: AppLocalizations.of(context)!.enter_your_full_address,
          ),
        ],
      ),
    );
  }

  Widget _buildLabelWithAsterisk(BuildContext context, String label) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
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
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.color_5F5F,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppTextFonts.poppinsRegular.copyWith(
            color: AppColors.color_8588,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildInputFieldAddress({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.color_5F5F,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        minLines: 2,
        maxLines: 5,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppTextFonts.poppinsRegular.copyWith(
            color: AppColors.color_8588,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.color_5F5F,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: AppLocalizations.of(context)!.select,
                hintStyle: AppTextFonts.poppinsRegular.copyWith(
                  color: AppColors.color_8588,
                  fontSize: 14,
                ),
              ),
              style: AppTextFonts.poppinsRegular.copyWith(
                color: AppColors.color_1618,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(
            width: 22,
            child: Center(
              child: GestureDetector(
                onTap: _pickDate,
                child: SvgPicture.asset(
                  AppImages.icCalendar,
                  width: 22,
                  height: 22,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderRadioGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildRadio(
          "Male",
          AppImages.icRadioSelected,
          AppImages.icRadioUnselected,
        ),
        const SizedBox(width: 16),
        _buildRadio(
          "Female",
          AppImages.icRadioSelected,
          AppImages.icRadioUnselected,
        ),
        const SizedBox(width: 16),
        _buildRadio(
          "Other",
          AppImages.icRadioSelected,
          AppImages.icRadioUnselected,
        ),
      ],
    );
  }

  Widget _buildRadio(String gender, String svgChecked, String svgUnchecked) {
    bool isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: Row(
        children: [
          SvgPicture.asset(
            isSelected ? svgChecked : svgUnchecked,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 8),
          Text(
            gender,
            style: AppTextFonts.poppinsRegular.copyWith(
              color: AppColors.color_1618,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/response/paper_response.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/select_id_type/select_id_type_bloc.dart';
import 'package:cam_id/main/ui/select_id_type/select_id_type_event.dart';
import 'package:cam_id/main/ui/select_id_type/select_id_type_state.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SelectIDTypePage extends StatefulWidget {
  const SelectIDTypePage({super.key});

  @override
  State<SelectIDTypePage> createState() => _SelectIDTypeState();
}

class _SelectIDTypeState extends State<SelectIDTypePage> {
  late final SelectIdTypeBloc _bloc;
  final List<PaperResponse> listPager = [];
  @override
  void initState() {
    super.initState();
    _bloc = SelectIdTypeBloc();
    _initData();
  }

  Future<void> _initData() async {
    final languageCode = await SharePreferenceUtil.getLanguageCode();
    _bloc.add(GetListPaperTypeEvent(languageCode));
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
        body: BlocConsumer<SelectIdTypeBloc, SelectIDTypeState>(
            builder: (context, state) {
              return Column(
                children: [
                  _buildHeader(context),
                  _buildInfoBox(context),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: listPager.length,
                      itemBuilder: (_, index) {
                        return _buildIdItem(
                          context: context,
                          iconPath: getIconByType(listPager[index].type),
                          paperType: listPager[index],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            listener: (context, state) {
              if(state is GetListPaperTypeSuccess){
                setState(() {
                  listPager
                    ..clear()
                    ..addAll(state.listPaper ?? []);
                });
              } else if( state is GetListPaperTypeFailure) {

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
                AppLocalizations.of(context)!.select_id_type,
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
    );
  }

  Widget _buildInfoBox(BuildContext context) {
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
          Text(
            AppLocalizations.of(context)!.verification,
            style: AppTextFonts.poppinsMedium.copyWith(
              color: AppColors.color_1618,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.title_verifying,
            style: AppTextFonts.poppinsRegular.copyWith(
              color: AppColors.color_8588,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdItem({
    required BuildContext context,
    required String iconPath,
    required PaperResponse paperType
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.push(
            '/verify-id',
            extra: paperType.type,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SvgPicture.asset(iconPath, width: 46, height: 46),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  paperType.name,
                  style: AppTextFonts.poppinsMedium.copyWith(
                    color: AppColors.color_1618,
                    fontSize: 14,
                  ),
                ),
              ),
              SvgPicture.asset(
                "assets/icons/ic_arrow_right.svg",
                width: 16,
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
  String getIconByType(String type) {
    switch (type) {
      case 'ID':
        return 'assets/icons/ic_cambodia_card.svg';
      case 'PASSPORT':
        return 'assets/icons/ic_passport.svg';
      case 'ARMY_ID':
        return 'assets/icons/ic_army_id.svg';
      case 'MONK_ID':
        return 'assets/icons/ic_cambodia_card.svg';
      case 'POLICE_ID':
        return 'assets/icons/ic_police_id.svg';
      default:
        return 'assets/icons/ic_cambodia_card.svg';
    }
  }

}
import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/language/language_bloc.dart';
import 'package:cam_id/main/ui/language/language_event.dart';
import 'package:cam_id/main/ui/payment_history/payment_history_bloc.dart';
import 'package:cam_id/main/ui/payment_history/payment_history_state.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});
  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> with SingleTickerProviderStateMixin{
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  late final PaymentHistoryBloc _bloc;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _bloc = PaymentHistoryBloc();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: BlocProvider.value(
        value: _bloc,
        child: BlocListener<PaymentHistoryBloc, PaymentHistoryState>(
          listener: (context, state) {},
          child: Scaffold(
            backgroundColor: AppColors.color_F7F7,
            appBar: AppBar(
              backgroundColor: AppColors.color_FFFF,
              elevation: 0,
              centerTitle: true,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.color_1618,
                ),
                onPressed: () => context.pop(),
              ),
              title: Text(l10n.payment_history, style: AppStyles.headerBlack),
              actions: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(AppImages.icFilterV2),
                    const SizedBox(width: 4),
                    Text(
                      l10n.filter,
                      style: AppTextFonts.poppinsRegular.copyWith(
                        fontSize: 10,
                        color: AppColors.color_E11B,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16)
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(52),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    height: 44,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(2),

                    decoration: BoxDecoration(
                      color: AppColors.color_5F5F,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: AppColors.color_1618,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      indicatorColor: AppColors.color_1618,
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: AppColors.color_FFFF,
                      unselectedLabelColor: AppColors.color_464B,
                      tabs: [
                        Tab(child: Text(l10n.history)),
                        Tab(child: Text(l10n.auto_renew)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                // _buildTabContent(listServiceForYou, viewStateForYou),
                // _buildTabMyService(listMyService, viewStateMyService),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

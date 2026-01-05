import 'package:cam_id/main/utils/widget/common_widgets.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:cam_id/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../generated/app_localizations.dart';
import 'search_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => SearchBloc(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0, // ngăn elevation khi cuộn dưới
          surfaceTintColor: Colors.transparent, // ngăn tint màu khi cuộn
          leading: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    AppImages.icBackBlack,
                    // width: 24,
                    // height: 24,
                  ),
                ),
              ),
            ),
          ),

          title: Text(l10n.search, style: AppStyles.header),
        ),
        body: Column(
          children: [
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: AppLocalizations.of(context)!.enterSearch,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ), // Viền trắng
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ), // Viền trắng
                      ),

                      // 2. Cấu hình border khi đang gõ
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ), // Vẫn là viền trắng
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          AppImages.icSearchBlack, // Đường dẫn icon SVG của bạn
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                    onChanged: (query) {
                      context.read<SearchBloc>().add(SearchTextChanged(query));
                    },
                  ),
                );
              },
            ),

            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 16),
                            child: Text(
                              l10n.suggestionsForYou,
                              style: AppStyles.header,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              spacing: 16,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    supportIcon(
                                      AppImages.icWifi,
                                      l10n.ftth,
                                      () async {
                                        //_onShowCall();
                                      },
                                    ),
                                    supportIcon(
                                      AppImages.icSimcard,
                                      l10n.esim,
                                      () {},
                                    ),
                                    supportIcon(
                                      AppImages.icDatabase,
                                      l10n.myServices,
                                      () {},
                                    ),
                                    supportIcon(
                                      AppImages.icTimer,
                                      l10n.paymentHistory,
                                      () {},
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    supportIcon(
                                      AppImages.icTopUp2,
                                      l10n.topUp,
                                      () {},
                                    ),
                                    supportIcon(
                                      AppImages.icExchangeCard,
                                      l10n.exchangeDamagedCard,
                                      () {
                                        context.push(PATH_FEEDBACK);
                                      },
                                    ),
                                    supportIcon(
                                      AppImages.icChatBotRed,
                                      l10n.chatbotTitle,
                                      () {
                                        context.push(PATH_CHATBOT_INTRO);
                                      },
                                    ),
                                    supportIcon(
                                      AppImages.icWifi,
                                      l10n.networkTest,
                                      () {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 16),
                            child: Text(
                              l10n.mostSearched,
                              style: AppStyles.header,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Wrap(
                              spacing:
                                  8.0, // Khoảng cách giữa các phần tử theo hàng ngang
                              runSpacing:
                                  8.0, // Khoảng cách giữa các hàng khi bị xuống dòng
                              children: [
                                _buildWrapItem(l10n.ftth),
                                _buildWrapItem(l10n.esim),
                                _buildWrapItem("l10n.shopping"),
                                _buildWrapItem("l10n.beauty"),
                                _buildWrapItem("l10n.cafe"),
                              ],
                            ),
                          ),
                          viewAllHeader(
                            title: l10n.recentSearches,
                            onViewAll: () {},
                            context: context,
                            textAll: l10n.clearAll,
                          ),
                          ListView.builder(
                            shrinkWrap:
                                true, // Quan trọng: Yêu cầu ListView chỉ chiếm không gian vừa đủ
                            physics:
                                const NeverScrollableScrollPhysics(), // Tắt cuộn riêng của ListView
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return _buildHistorySearchItem("test", context);
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is SearchEmpty) {
                    return Center(
                      child: Text(AppLocalizations.of(context)!.enter),
                    );
                  }
                  if (state is SearchLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is SearchLoaded) {
                    if (state.filteredItems.isEmpty) {
                      return Center(
                        child: Text(AppLocalizations.of(context)!.enter),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.filteredItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.filteredItems[index]),
                        );
                      },
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySearchItem(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 2),
      child: Row(
        spacing: 8,
        children: [
          SvgPicture.asset(AppImages.icClock),
          Text(title, style: AppStyles.poppins12Regular.copyWith(fontSize: 14)),
          Spacer(),
          SvgPicture.asset(AppImages.icClose),
        ],
      ),
    );
  }

  Widget _buildWrapItem(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Bo góc tròn
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ), // Viền nhẹ để nổi trên nền trắng
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: AppStyles.poppins12Regular.copyWith(fontSize: 14),
      ),
    );
  }
}

import 'package:cam_id/main/data/model/banner_model.dart';
import 'package:cam_id/main/data/repository/all_app_repository.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'entertainment_state.dart';

part 'entertainment_event.dart';

class EntertainmentBloc extends Bloc<EntertainmentEvent, EntertainmentState> {
  EntertainmentBloc() : super(EntertainmentState.initial()) {
    on<ChangeBannerEvent>((event, emit) {
      emit(state.copyWith(currentBannerIndex: event.index));
    });
    on<ChangeFooterBannerEvent>((event, emit) {
      emit(state.copyWith(currentFooterBannerIndex: event.index));
    });
    on<GetBannerEvent>((event, emit) async {
      try {
        final response = await AppRepository().getAllApps(force: true);
        final ads = response.adBanner;

        final bannerFooterList = <AdsModel>[];
        final bannerHeaderList = <AdsModel>[];
        final listTv360 = <AdsModel>[];
        final listGame = <AdsModel>[];
        final listVas = <AdsModel>[];

        for (final item in ads!) {
          switch (item.type) {
            case Constant.SLIDER_METFONE_FOOTER:
              bannerFooterList.add(item);
              break;
            case Constant.SLIDER_METFONE_HEADER:
              bannerHeaderList.add(item);
              break;
            case Constant.TV360_TYPE:
              listTv360.add(item);
              break;
            case Constant.VAS_SERVICE:
              listVas.add(item);
              break;
            case Constant.TAB_GAME_MF:
              listGame.add(item);
              break;
          }
        }

        bannerFooterList.sort((a, b) {
          final oa = int.tryParse(a.orderBy ?? '') ?? 0;
          final ob = int.tryParse(b.orderBy ?? '') ?? 0;
          return oa.compareTo(ob);
        });

        bannerHeaderList.sort((a, b) {
          final oa = int.tryParse(a.orderBy ?? '') ?? 0;
          final ob = int.tryParse(b.orderBy ?? '') ?? 0;
          return oa.compareTo(ob);
        });

        emit(
          state.copyWith(
            bannerFooterList: bannerFooterList,
            bannerHeaderList: bannerHeaderList,
            listGame: listGame,
            listTv360: listTv360,
            listVas: listVas,
          ),
        );
      } catch (e) {
        print(e);
      }
    });
  }
}

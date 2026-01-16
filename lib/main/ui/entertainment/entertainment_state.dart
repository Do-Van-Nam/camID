import 'package:cam_id/main/data/model/banner_model.dart';
import 'package:collection/collection.dart';

class EntertainmentState {
  final int currentBannerIndex;
  final int currentFooterBannerIndex;
  final List<AdsModel> bannerFooterList;
  final List<AdsModel> bannerHeaderList;
  final List<AdsModel> listGame;
  final List<AdsModel> listTv360;
  final List<AdsModel> listVas;

  EntertainmentState({
    this.currentBannerIndex = 0,
    this.currentFooterBannerIndex = 0,
    List<AdsModel>? bannerFooterList,
    List<AdsModel>? bannerHeaderList,
    List<AdsModel>? listGame,
    List<AdsModel>? listTv360,
    List<AdsModel>? listVas,
  }) : bannerFooterList = bannerFooterList ?? const [],
       bannerHeaderList = bannerHeaderList ?? const [],
       listGame = listGame ?? const [],
       listTv360 = listTv360 ?? const [],
       listVas = listVas ?? const [];

  factory EntertainmentState.initial() => EntertainmentState();

  EntertainmentState copyWith({
    int? currentBannerIndex,
    int? currentFooterBannerIndex,
    List<AdsModel>? bannerFooterList,
    List<AdsModel>? bannerHeaderList,
    List<AdsModel>? listGame,
    List<AdsModel>? listTv360,
    List<AdsModel>? listVas,
  }) {
    return EntertainmentState(
      currentBannerIndex: currentBannerIndex ?? this.currentBannerIndex,
      currentFooterBannerIndex:
          currentFooterBannerIndex ?? this.currentFooterBannerIndex,
      bannerFooterList: bannerFooterList ?? this.bannerFooterList,
      bannerHeaderList: bannerHeaderList ?? this.bannerHeaderList,
      listGame: listGame ?? this.listGame,
      listTv360: listTv360 ?? this.listTv360,
      listVas: listVas ?? this.listVas,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final e = other as EntertainmentState;
    final listEq = const DeepCollectionEquality().equals;
    return currentBannerIndex == e.currentBannerIndex &&
        currentFooterBannerIndex == e.currentFooterBannerIndex &&
        listEq(bannerFooterList, e.bannerFooterList) &&
        listEq(bannerHeaderList, e.bannerHeaderList) &&
        listEq(listGame, e.listGame) &&
        listEq(listTv360, e.listTv360) &&
        listEq(listVas, e.listVas);
  }

  @override
  int get hashCode => Object.hash(
    currentBannerIndex,
    currentFooterBannerIndex,
    const DeepCollectionEquality().hash(bannerFooterList),
    const DeepCollectionEquality().hash(bannerHeaderList),
    const DeepCollectionEquality().hash(listGame),
    const DeepCollectionEquality().hash(listTv360),
    const DeepCollectionEquality().hash(listVas),
  );

  @override
  String toString() {
    return 'EntertainmentState(currentBannerIndex: $currentBannerIndex, currentFooterBannerIndex: $currentFooterBannerIndex, bannerFooterList: $bannerFooterList, bannerHeaderList: $bannerHeaderList, listGame: $listGame, listTv360: $listTv360, listVas: $listVas)';
  }
}

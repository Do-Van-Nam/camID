// game_state.dart
part of 'game_list_bloc.dart';

class GameListState {
  final List<String> banners;
  final List<GameItem> trendingGames;
  final List<GameItem> specialGames;
  final List<GameItem> actionGames;

  final bool isLoadingBanners;
  final bool isLoadingTrending;
  final bool isLoadingSpecial;
  final bool isLoadingAction;
  final int currentBannerIndex;
  GameListState({
    required this.banners,
    required this.trendingGames,
    required this.specialGames,
    required this.actionGames,
    required this.isLoadingBanners,
    required this.isLoadingTrending,
    required this.isLoadingSpecial,
    required this.isLoadingAction,
    required this.currentBannerIndex,
  });

  factory GameListState.initial() => GameListState(
    banners: [],
    trendingGames: [],
    specialGames: [],
    actionGames: [],
    isLoadingBanners: true,
    isLoadingTrending: true,
    isLoadingSpecial: true,
    isLoadingAction: true,
    currentBannerIndex: 0,
  );

  GameListState copyWith({
    List<String>? banners,
    List<GameItem>? trendingGames,
    List<GameItem>? specialGames,
    List<GameItem>? actionGames,
    bool? isLoadingBanners,
    bool? isLoadingTrending,
    bool? isLoadingSpecial,
    bool? isLoadingAction,
    int? currentBannerIndex,
  }) {
    return GameListState(
      banners: banners ?? this.banners,
      trendingGames: trendingGames ?? this.trendingGames,
      specialGames: specialGames ?? this.specialGames,
      actionGames: actionGames ?? this.actionGames,
      isLoadingBanners: isLoadingBanners ?? this.isLoadingBanners,
      isLoadingTrending: isLoadingTrending ?? this.isLoadingTrending,
      isLoadingSpecial: isLoadingSpecial ?? this.isLoadingSpecial,
      isLoadingAction: isLoadingAction ?? this.isLoadingAction,
      currentBannerIndex: currentBannerIndex ?? this.currentBannerIndex,
    );
  }
}

// game_state.dart
part of 'ranking_bloc.dart';

class GameState {
  final List<String> banners;
  final List<GameItem> trendingGames;
  final List<GameItem> specialGames;
  final List<GameItem> actionGames;

  final bool isLoadingBanners;
  final bool isLoadingTrending;
  final bool isLoadingSpecial;
  final bool isLoadingAction;
  final int currentBannerIndex;
  GameState({
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

  factory GameState.initial() => GameState(
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

  GameState copyWith({
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
    return GameState(
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

import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_list_event.dart';
part 'game_list_state.dart';

class GameItem {
  final String imageUrl;
  final String title;
  final String players; // ví dụ "20k player"

  GameItem({required this.imageUrl, required this.title, this.players = ''});
}

class GameListBloc extends Bloc<GameListEvent, GameListState> {
  GameListBloc() : super(GameListState.initial()) {
    on<LoadBannersEvent>((event, emit) async {
      emit(state.copyWith(isLoadingBanners: true));
      await Future.delayed(const Duration(seconds: 1));
      final banners = [
        'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/2023_10_15_638329878567586819_banner-la-gi-0.jpg',
        'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/2023_10_15_638329878567586819_banner-la-gi-0.jpg',
      ];
      emit(state.copyWith(banners: banners, isLoadingBanners: false));
    });

    on<LoadTrendingGamesEvent>((event, emit) async {
      emit(state.copyWith(isLoadingTrending: true));
      await Future.delayed(const Duration(seconds: 1));
      final games = List.generate(
        5,
        (i) => GameItem(
          imageUrl:
              'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/2023_10_15_638329878567586819_banner-la-gi-0.jpg',
          title: 'The Ultimate Racer ${i + 1}',
          players: '20k player',
        ),
      );
      emit(state.copyWith(trendingGames: games, isLoadingTrending: false));
    });

    on<LoadSpecialGamesEvent>((event, emit) async {
      emit(state.copyWith(isLoadingSpecial: true));
      await Future.delayed(const Duration(seconds: 1));
      final games = List.generate(
        7,
        (i) => GameItem(
          imageUrl:
              'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/2023_10_15_638329878567586819_banner-la-gi-0.jpg',
          title: i % 2 == 0 ? 'Mobile Legends' : 'Apex Legends',
        ),
      );
      emit(state.copyWith(specialGames: games, isLoadingSpecial: false));
    });

    on<LoadActionGamesEvent>((event, emit) async {
      emit(state.copyWith(isLoadingAction: true));
      await Future.delayed(const Duration(seconds: 1));
      final games = List.generate(
        26,
        (i) => GameItem(
          imageUrl:
              'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/2023_10_15_638329878567586819_banner-la-gi-0.jpg',
          title: i % 2 == 0 ? 'Mobile Legends' : 'Apex Legends',
        ),
      );
      emit(state.copyWith(actionGames: games, isLoadingAction: false));
    });
    on<ChangeBannerEvent>((event, emit) {
      emit(state.copyWith(currentBannerIndex: event.index));
    });
    // Load tất cả khi khởi tạo
    add(LoadBannersEvent());
    add(LoadTrendingGamesEvent());
    add(LoadSpecialGamesEvent());
    add(LoadActionGamesEvent());
  }
}

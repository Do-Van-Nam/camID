import 'package:cam_id/main/data/model/game/category_model.dart';
import 'package:cam_id/main/data/repository/game_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameItem {
  final String imageUrl;
  final String title;
  final String players; // ví dụ "20k player"

  GameItem({required this.imageUrl, required this.title, this.players = ''});
}

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameState.initial()) {
    on<LoadBannersEvent>((event, emit) async {
      final repo = GameRepository();
      emit(state.copyWith(isLoadingBanners: true));
      try {
        print("goi api");
        final botReply = await repo.getGames();
        // final botMessage = botReply.data!;
        final List<String> banners = botReply.items
            .map((item) {
              final firstGame = item.games?.firstOrNull;
              return firstGame?.bannerUrl ?? "";
            })
            .where((url) => url.isNotEmpty)
            .toList();
        emit(state.copyWith(categoryItems: botReply.items, banners: banners));
        print("response");
        print(botReply);
      } catch (e) {
        // Hiển thị lỗi cho user
        // emit(state.copyWith(isTyping: false));
        print('Lỗi lấy menu: $e');
      }
      emit(state.copyWith(isLoadingBanners: false));
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

    on<ChangeBannerEvent>((event, emit) {
      emit(state.copyWith(currentBannerIndex: event.index));
    });
    // Load tất cả khi khởi tạo
    add(LoadBannersEvent());
    add(LoadTrendingGamesEvent());
  }
}

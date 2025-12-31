// game_event.dart
part of 'game_list_bloc.dart';

abstract class GameListEvent {}

class LoadBannersEvent extends GameListEvent {}

class LoadTrendingGamesEvent extends GameListEvent {}

class LoadSpecialGamesEvent extends GameListEvent {}

class LoadActionGamesEvent extends GameListEvent {}

class ChangeBannerEvent extends GameListEvent {
  final int index;
  ChangeBannerEvent(this.index);
}

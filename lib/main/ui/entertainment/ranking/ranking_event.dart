// game_event.dart
part of 'ranking_bloc.dart';

abstract class GameEvent {}

class LoadBannersEvent extends GameEvent {}

class LoadTrendingGamesEvent extends GameEvent {}

class LoadSpecialGamesEvent extends GameEvent {}

class LoadActionGamesEvent extends GameEvent {}

class ChangeBannerEvent extends GameEvent {
  final int index;
  ChangeBannerEvent(this.index);
}

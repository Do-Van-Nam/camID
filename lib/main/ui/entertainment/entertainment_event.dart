part of 'entertainment_bloc.dart';

abstract class EntertainmentEvent {}

class ChangeBannerEvent extends EntertainmentEvent {
  final int index;
  ChangeBannerEvent(this.index);
}

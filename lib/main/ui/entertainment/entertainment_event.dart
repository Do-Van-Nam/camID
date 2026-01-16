part of 'entertainment_bloc.dart';

abstract class EntertainmentEvent {}

class ChangeBannerEvent extends EntertainmentEvent {
  final int index;
  ChangeBannerEvent(this.index);
}

class ChangeFooterBannerEvent extends EntertainmentEvent {
  final int index;
  ChangeFooterBannerEvent(this.index);
}

class GetBannerEvent extends EntertainmentEvent {
  GetBannerEvent();
}

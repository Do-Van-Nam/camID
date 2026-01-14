// notification_event.dart
part of 'gift_bloc.dart';

abstract class GiftEvent {}

class LoadNewsNotifications extends GiftEvent {}

class LoadComplainNotifications extends GiftEvent {}

class MarkAsReadEvent extends GiftEvent {
  final int id;
  MarkAsReadEvent(this.id);
}

class ReadAllEvent extends GiftEvent {
  final bool isNewsTab;
  ReadAllEvent(this.isNewsTab);
}

class ClearAllEvent extends GiftEvent {
  final bool isNewsTab;
  ClearAllEvent(this.isNewsTab);
}

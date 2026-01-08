// notification_event.dart
part of 'feedback_detail_bloc.dart';

abstract class NotificationDetailEvent {}

class LoadNewsNotifications extends NotificationDetailEvent {}

class LoadComplainNotifications extends NotificationDetailEvent {}

class MarkAsReadEvent extends NotificationDetailEvent {
  final int id;
  MarkAsReadEvent(this.id);
}

class ReadAllEvent extends NotificationDetailEvent {
  final bool isNewsTab;
  ReadAllEvent(this.isNewsTab);
}

class ClearAllEvent extends NotificationDetailEvent {
  final bool isNewsTab;
  ClearAllEvent(this.isNewsTab);
}

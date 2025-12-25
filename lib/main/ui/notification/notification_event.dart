// notification_event.dart
part of 'notification_bloc.dart';

abstract class NotificationEvent {}

class LoadNewsNotifications extends NotificationEvent {}
class LoadComplainNotifications extends NotificationEvent {}
class MarkAsReadEvent extends NotificationEvent {
  final int id;
  MarkAsReadEvent(this.id);
}
class ReadAllEvent extends NotificationEvent {
  final bool isNewsTab;
  ReadAllEvent(this.isNewsTab);
}
class ClearAllEvent extends NotificationEvent {
  final bool isNewsTab;
  ClearAllEvent(this.isNewsTab);
}

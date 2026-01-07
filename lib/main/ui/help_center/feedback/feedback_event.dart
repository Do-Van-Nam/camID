// notification_event.dart
part of 'feedback_bloc.dart';

abstract class FeedbackEvent {}

class LoadNewsNotifications extends FeedbackEvent {}

class LoadComplainNotifications extends FeedbackEvent {}

class MarkAsReadEvent extends FeedbackEvent {
  final int id;
  MarkAsReadEvent(this.id);
}

class ReadAllEvent extends FeedbackEvent {
  final bool isNewsTab;
  ReadAllEvent(this.isNewsTab);
}

class ClearAllEvent extends FeedbackEvent {
  final bool isNewsTab;
  ClearAllEvent(this.isNewsTab);
}

// chat_event.dart
part of 'tier_bloc.dart';

abstract class TierEvent {}

class SendMessageEvent extends TierEvent {
  final String message;
  SendMessageEvent(this.message);
}

class ChangeLanguageEvent extends TierEvent {
  final String language; // "km" hoặc "en"
  ChangeLanguageEvent(this.language);
}

class ToggleMenuEvent extends TierEvent {}

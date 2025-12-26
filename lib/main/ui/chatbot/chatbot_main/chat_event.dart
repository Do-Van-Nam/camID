// chat_event.dart
part of 'chat_bloc.dart';

abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String message;
  SendMessageEvent(this.message);
}

class ChangeLanguageEvent extends ChatEvent {
  final String language; // "km" hoặc "en"
  ChangeLanguageEvent(this.language);
}

class ToggleMenuEvent extends ChatEvent {}

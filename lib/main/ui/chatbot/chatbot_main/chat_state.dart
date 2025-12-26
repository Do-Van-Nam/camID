// chat_state.dart
part of 'chat_bloc.dart';

class ChatState {
  final List<Message> messages;
  final bool isTyping;
  final bool isOpenMenu;
  final String selectedLanguage; // "km" hoặc "en"

  ChatState({
    required this.messages,
    required this.isTyping,
    required this.selectedLanguage,
    required this.isOpenMenu,
  });

  factory ChatState.initial() => ChatState(
    messages: [
      Message(
        text: "Please select a language below",
        isBot: true,
        time: DateTime.now(),
      ),
    ],
    isTyping: false,
    selectedLanguage: "en",
    isOpenMenu: false,
  );

  ChatState copyWith({
    List<Message>? messages,
    bool? isTyping,
    String? selectedLanguage,
    bool? isOpenMenu,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isOpenMenu: isOpenMenu ?? this.isOpenMenu,
    );
  }
}

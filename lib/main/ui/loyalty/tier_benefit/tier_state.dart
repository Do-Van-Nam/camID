// chat_state.dart
part of 'tier_bloc.dart';

class TierState {
  final List<Message> messages;
  final bool isTyping;
  final bool isOpenMenu;
  final String selectedLanguage; // "km" hoặc "en"

  TierState({
    required this.messages,
    required this.isTyping,
    required this.selectedLanguage,
    required this.isOpenMenu,
  });

  factory TierState.initial() => TierState(
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

  TierState copyWith({
    List<Message>? messages,
    bool? isTyping,
    String? selectedLanguage,
    bool? isOpenMenu,
  }) {
    return TierState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isOpenMenu: isOpenMenu ?? this.isOpenMenu,
    );
  }
}

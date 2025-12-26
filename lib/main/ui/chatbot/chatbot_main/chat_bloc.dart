import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class Message {
  final String text;
  final bool isBot;
  final DateTime time;

  Message({required this.text, required this.isBot, required this.time});
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState.initial()) {
    // Gửi tin nhắn
    on<SendMessageEvent>((event, emit) async {
      final userMessage = Message(
        text: event.message,
        isBot: false,
        time: DateTime.now(),
      );
      emit(
        state.copyWith(
          messages: [...state.messages, userMessage],
          isTyping: true,
        ),
      );

      // Giả lập gọi API + phản hồi từ bot
      await Future.delayed(const Duration(seconds: 1));

      final botReply = _getBotReply(event.message);
      final botMessage = Message(
        text: botReply,
        isBot: true,
        time: DateTime.now(),
      );

      emit(
        state.copyWith(
          messages: [...state.messages, userMessage, botMessage],
          isTyping: false,
        ),
      );
    });

    // Chọn ngôn ngữ
    on<ChangeLanguageEvent>((event, emit) {
      emit(state.copyWith(selectedLanguage: event.language));
    });

    on<ToggleMenuEvent>((event, emit) {
      emit(state.copyWith(isOpenMenu: !state.isOpenMenu));
    });
  }

  String _getBotReply(String userInput) {
    // Giả lập logic trả lời (sau này gọi API thật)
    final lower = userInput.toLowerCase();
    if (lower.contains('mobile') || lower.contains('wifi')) {
      return "Hello customer! Metfone BOT virtual assistant is very willing to support for you, hope you will have a great experience. Please share your need for advice or choose to learn about Metfone products and service here:";
    }
    return "Thank you for contacting us. How can I assist you today?";
  }
}

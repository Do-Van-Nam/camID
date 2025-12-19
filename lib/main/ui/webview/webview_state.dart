import 'package:equatable/equatable.dart';

class WebviewState extends Equatable {
  final String url;
  final String? title;
  final bool isLoading;
  final bool canGoBack;
  final bool canGoForward;
  final String? errorMessage;

  const WebviewState({
    required this.url,
    this.title,
    this.isLoading = true,
    this.canGoBack = false,
    this.canGoForward = false,
    this.errorMessage,
  });

  WebviewState copyWith({
    String? url,
    String? title,
    bool? isLoading,
    bool? canGoBack,
    bool? canGoForward,
    String? errorMessage,
  }) {
    return WebviewState(
      url: url ?? this.url,
      title: title ?? this.title,
      isLoading: isLoading ?? this.isLoading,
      canGoBack: canGoBack ?? this.canGoBack,
      canGoForward: canGoForward ?? this.canGoForward,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    url,
    title,
    isLoading,
    canGoBack,
    canGoForward,
    errorMessage,
  ];
}

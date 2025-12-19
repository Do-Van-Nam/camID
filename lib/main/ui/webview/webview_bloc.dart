import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'webview_event.dart';
import 'webview_state.dart';

class WebviewBloc extends Bloc<WebviewEvent, WebviewState> {
  late final WebViewController controller;

  WebviewBloc(String initialUrl) : super(WebviewState(url: initialUrl)) {
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (_) => add(_PageLoading()),
              onPageFinished: (_) => add(_PageLoaded()),
              onNavigationRequest: (request) {
                // Có thể chặn một số URL nếu cần
                return NavigationDecision.navigate;
              },
              onWebResourceError: (error) {
                add(_PageError(error.description));
              },
            ),
          );

    // Load URL ban đầu
    on<LoadUrl>((event, emit) {
      controller.loadRequest(Uri.parse(event.url));
      emit(state.copyWith(url: event.url, errorMessage: null));
    });

    on<ReloadPage>((event, emit) {
      controller.reload();
    });

    on<GoBack>((event, emit) async {
      if (await controller.canGoBack()) {
        controller.goBack();
      }
    });

    on<GoForward>((event, emit) async {
      if (await controller.canGoForward()) {
        controller.goForward();
      }
    });

    // Internal events
    on<_PageLoading>((event, emit) {
      emit(state.copyWith(isLoading: true, errorMessage: null));
    });

    on<_PageLoaded>((event, emit) async {
      final title = await controller.getTitle();
      final canBack = await controller.canGoBack();
      final canForward = await controller.canGoForward();
      emit(
        state.copyWith(
          isLoading: false,
          title: title,
          canGoBack: canBack,
          canGoForward: canForward,
        ),
      );
    });

    on<_PageError>((event, emit) {
      emit(state.copyWith(isLoading: false, errorMessage: event.message));
    });

    // Load URL đầu tiên
    add(LoadUrl(initialUrl));
  }
}

// Internal events (không public)
class _PageLoading extends WebviewEvent {}

class _PageLoaded extends WebviewEvent {}

class _PageError extends WebviewEvent {
  final String message;
  _PageError(this.message);
}

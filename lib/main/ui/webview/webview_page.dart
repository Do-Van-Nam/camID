import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart'; // Để ẩn status bar nếu cần
import 'package:webview_flutter/webview_flutter.dart';
import 'webview_bloc.dart';
import 'webview_event.dart';
import 'webview_state.dart';

class WebViewPage extends StatelessWidget {
  final String initialUrl;

  const WebViewPage({super.key, required this.initialUrl});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WebviewBloc(initialUrl),
      child: const _WebviewBody(),
    );
  }
}

class _WebviewBody extends StatefulWidget {
  const _WebviewBody();

  @override
  State<_WebviewBody> createState() => _WebviewBodyState();
}

class _WebviewBodyState extends State<_WebviewBody> {
  @override
  void initState() {
    super.initState();
    // Ẩn status bar và navigation bar để full screen thực sự
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Khôi phục lại khi thoát
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<WebviewBloc, WebviewState>(
        builder: (context, state) {
          final bloc = context.read<WebviewBloc>();

          return Stack(
            children: [
              WebViewWidget(controller: bloc.controller),

              // Loading overlay
              if (state.isLoading)
                const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),

              // Error message
              if (state.errorMessage != null)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.red.withOpacity(0.8),
                    child: Text(
                      'Lỗi: ${state.errorMessage}',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

              // Top bar (nút đóng, reload, back/forward)
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 10,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Nút back
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed:
                          state.canGoBack
                              ? () => context.read<WebviewBloc>().add(GoBack())
                              : null,
                    ),

                    // Nút reload
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed:
                          () => context.read<WebviewBloc>().add(ReloadPage()),
                    ),

                    // Nút forward
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      onPressed:
                          state.canGoForward
                              ? () =>
                                  context.read<WebviewBloc>().add(GoForward())
                              : null,
                    ),

                    // Nút đóng
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

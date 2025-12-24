import 'package:cam_id/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final LoadingWidgetState state;
  final Widget child;
  final String? emptyMessage;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const LoadingWidget({
    super.key,
    required this.state,
    required this.child,
    this.emptyMessage,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case LoadingWidgetState.loading:
        return const _LoadingView();

      case LoadingWidgetState.success:
        return child;

      case LoadingWidgetState.empty:
        return _StateContent(
          icon: Icons.hourglass_empty,
          message: emptyMessage ?? AppLocalizations.of(context)!.no_data,
        );

      case LoadingWidgetState.error:
        return _StateContent(
          icon: Icons.error,
          message: errorMessage ?? AppLocalizations.of(context)!.error_occurred,
          iconColor: Colors.red,
          onRetry: onRetry,
        );
    }
  }
}

enum LoadingWidgetState { loading, success, empty, error }

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _StateContent extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color iconColor;
  final VoidCallback? onRetry;

  const _StateContent({
    required this.icon,
    required this.message,
    this.iconColor = Colors.grey,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: iconColor),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onRetry, child: Text(AppLocalizations.of(context)!.retry)),
            ],
          ],
        ),
      ),
    );
  }
}

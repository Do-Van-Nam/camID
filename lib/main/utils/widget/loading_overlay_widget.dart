import 'package:flutter/material.dart';

class LoadingOverlayWidget {
  static final _overlayEntry = ValueNotifier<OverlayEntry?>(null);

  static void show(BuildContext context) {
    if (_overlayEntry.value != null) return;

    _overlayEntry.value = OverlayEntry(
      builder: (context) => Stack(
        children: [
          ModalBarrier(
            color: Colors.black.withOpacity(0.5),
            dismissible: false,
          ),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry.value!);
  }

  static void hide() {
    _overlayEntry.value?.remove();
    _overlayEntry.value = null;
  }
}

import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModalBarrier(
          // color: Colors.black.withOpacity(0.5),
          dismissible: false,
        ),
        const Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }
}

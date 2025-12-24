import 'package:cam_id/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'splash_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashResolved) {
          switch (state.next) {
            case SplashNext.home:
              context.go(PATH_HOME);
              break;
            case SplashNext.login:
              context.go(PATH_LOGIN);
              break;
            case SplashNext.forceUpdate:
              context.go(PATH_FORCE_UPDATE);
              break;
            case SplashNext.maintenance:
              context.go(PATH_MAINTENANCE);
              break;
          }
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

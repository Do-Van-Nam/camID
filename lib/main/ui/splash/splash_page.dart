import 'package:cam_id/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'splash_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(SplashStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashAuthenticated) {
            context.go(PATH_HOME);
          }

          if (state is SplashUnauthenticated) {
            context.go(PATH_LOGIN);
          }

          if (state is SplashError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset('assets/app_icon.png', width: 120),
          // const SizedBox(height: 16),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}

import 'package:cam_id/main/ui/login/login_page.dart';
import 'package:cam_id/main/ui/main_page.dart';
import 'package:go_router/go_router.dart';

const String PATH_HOME = "/main";
const String PATH_LOGIN = "/login";

final GoRouter router = GoRouter(
  initialLocation: PATH_HOME,
  routes: [
    GoRoute(
      path: PATH_HOME,
      builder: (context, state) => MainPage(),
    ),
    GoRoute(
      path: PATH_LOGIN,
      builder: (context, state) => LoginPage(),
    ),
  ],
);

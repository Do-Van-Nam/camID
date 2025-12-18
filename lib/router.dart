import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/ui/language/language_page.dart';
import 'package:cam_id/main/ui/login/login_page.dart';
import 'package:cam_id/main/ui/search/search_page.dart';
import 'package:cam_id/main/ui/feedback/feedback_page.dart';
import 'package:cam_id/main/ui/main_page.dart';
import 'package:cam_id/main/ui/webview/webview_page.dart';
import 'package:cam_id/main/utils/app_config.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:go_router/go_router.dart';

const String PATH_HOME = "/main";
const String PATH_LOGIN = "/login";
const String PATH_LANGUAGE = "/language";
const String PATH_SEARCH = "/search";
const String PATH_FEEDBACK = "/feedback";
const String PATH_WEBVIEW = "/webview";

final GoRouter router = GoRouter(
  initialLocation: PATH_LOGIN,
  routes: [
    GoRoute(path: PATH_HOME, builder: (context, state) => MainPage()),
    GoRoute(path: PATH_LOGIN, builder: (context, state) => LoginPage()),
    GoRoute(path: PATH_LANGUAGE, builder: (context, state) => LanguagePage()),
    GoRoute(path: PATH_SEARCH, builder: (context, state) => SearchPage()),
    GoRoute(path: PATH_FEEDBACK, builder: (context, state) => FeedbackPage()),
    GoRoute(
      name: 'webview', // Đặt name để dễ gọi
      path: PATH_WEBVIEW,
      builder: (context, state) {
        final String url = state.extra as String? ?? 'about:blank';
        return WebViewPage(initialUrl: url);
      },
    ),
  ],
  redirect: (context, state) {
    final isLoggedIn = UserInfoModel.instance.username.isNotEmpty;
    final isFirstOpenApp = AppConfig.instance.isFirstOpenApp;

    AppLogger().logError(
      "CheckApp: isLoggedIn=$isLoggedIn, isFirstOpenApp=$isFirstOpenApp",
    );

    if (isLoggedIn && state.matchedLocation != PATH_HOME) {
      return PATH_HOME;
    }

    if (!isLoggedIn && state.matchedLocation == PATH_LOGIN) {
      if (isFirstOpenApp) {
        return PATH_HOME;
      } else {
        return PATH_LOGIN;
      }
    }

    return null;
  },
);

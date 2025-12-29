import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/ui/chatbot/chatbot_intro/chatbot_intro_page.dart';
import 'package:cam_id/main/ui/chatbot/chatbot_main/chat_page.dart';
import 'package:cam_id/main/ui/find_stores/find_stores_page.dart';
import 'package:cam_id/main/ui/force_update/force_update_page.dart';
import 'package:cam_id/main/ui/language/language_page.dart';
import 'package:cam_id/main/ui/login/login_page.dart';
import 'package:cam_id/main/ui/notification/notification_page.dart';
import 'package:cam_id/main/ui/search/search_page.dart';
import 'package:cam_id/main/ui/feedback/feedback_page.dart';
import 'package:cam_id/main/ui/main_page.dart';
import 'package:cam_id/main/ui/select_id_type/select_id_type_page.dart';
import 'package:cam_id/main/ui/terms_html/terms_html_page.dart';
import 'package:cam_id/main/ui/user_information/user_information_page.dart';
import 'package:cam_id/main/ui/user_profile/user_profile_page.dart';
import 'package:cam_id/main/ui/verify/verify_page.dart';
import 'package:cam_id/main/ui/webview/webview_page.dart';
import 'package:cam_id/main/utils/app_config.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'main/ui/maintenance/maintenance_page.dart';
import 'main/ui/miniapp/mini_app_bloc.dart';
import 'main/ui/miniapp/mini_app_overlay.dart';
import 'main/ui/miniapp/mini_app_state.dart';
import 'main/ui/splash/splash_page.dart';

const String PATH_SPLASH = "/";
const String PATH_HOME = "/main";
const String PATH_LOGIN = "/login";
const String PATH_LANGUAGE = "/language";
const String PATH_SEARCH = "/search";
const String PATH_FEEDBACK = "/feedback";
const String PATH_FIND_STORES = "/find_stores";
const String PATH_USER_PROFILE = "/user_profile";
const String PATH_USER_INFORMATION = "/user_information";
const String PATH_FORCE_UPDATE = "/force-update";
const String PATH_MAINTENANCE = "/maintenance";
const String PATH_TERMS = "/terms";
const String PATH_VERIFY = "/verify";
const String PATH_ID_TYPE = "/id_type";
const String PATH_IDENTITY_VERIFICATION = "/identity_verification";

// notificaion
const String PATH_NOTIFICATION = "/notificaion";

// chatbot
const String PATH_CHATBOT_INTRO = "/chatbot-info";
const String PATH_CHATBOT = "/chatbot";

final GoRouter router = GoRouter(
  initialLocation: PATH_SPLASH,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (_) => MiniAppBloc(),
          child: BlocBuilder<MiniAppBloc, MiniAppState>(
            builder: (context, miniAppState) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Child page - bị che khi webview mở
                  IgnorePointer(
                    ignoring: miniAppState.opened && !miniAppState.minimized,
                    child: child,
                  ),
                  // MiniAppOverlay - luôn ở trên cùng
                  const MiniAppOverlay(), // webview + bubble + close zone
                ],
              );
            },
            buildWhen: (previous, current) =>
                previous.opened != current.opened ||
                previous.minimized != current.minimized,
          ),
        );
      },
      routes: [
        GoRoute(
          path: PATH_SPLASH,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(path: PATH_HOME, builder: (context, state) => MainPage()),
        GoRoute(path: PATH_LOGIN, builder: (context, state) => LoginPage()),
        GoRoute(
          path: PATH_LANGUAGE,
          builder: (context, state) => LanguagePage(),
        ),

        // --- N
        GoRoute(path: PATH_SEARCH, builder: (context, state) => SearchPage()),
        GoRoute(
          path: PATH_FEEDBACK,
          builder: (context, state) => FeedbackPage(),
        ),
        // notificaion
        GoRoute(
          path: PATH_NOTIFICATION,
          builder: (context, state) => NotificationPage(),
        ),
        //chat bot
        GoRoute(
          path: PATH_CHATBOT_INTRO,
          builder: (context, state) => ChatbotIntroPage(),
        ),
        GoRoute(path: PATH_CHATBOT, builder: (context, state) => ChatBotPage()),

        // ---
        GoRoute(
          path: PATH_FIND_STORES,
          builder: (context, state) => FindStoresPage(),
        ),
        GoRoute(path: PATH_USER_PROFILE, builder: (context, state) => UserProfilePage()),
        GoRoute(path: PATH_USER_INFORMATION, builder: (context, state) => UserInformationPage()),
        GoRoute(path: PATH_FORCE_UPDATE, builder: (context, state) => ForceUpdatePage()),
        GoRoute(path: PATH_MAINTENANCE, builder: (context, state) => MaintenancePage()),
        GoRoute(
          path: PATH_TERMS,
          builder: (context, state) {
            final html = state.extra as String;
            return TermsHtmlPage(html: html);
          },
        ),
        GoRoute(path: PATH_VERIFY, builder: (context, state) => VerifyPage()),
        GoRoute(path: PATH_ID_TYPE, builder: (context, state) => SelectIDTypePage()),
        // GoRoute(
        //   path: PATH_IDENTITY_VERIFICATION,
        //   builder: (context, state) {
        //     final idType = state.extra as IDType;
        //     return VerifyIdPage(idType: idType);
        //   },
        // ),

      ],
    ),

  ],
  redirect: (context, state) {
    final isLoggedIn = UserInfoModel.instance.username.isNotEmpty;
    final isFirstOpenApp = AppConfig.instance.isFirstOpenApp;

    AppLogger().logError(
      "CheckApp: isLoggedIn=$isLoggedIn, isFirstOpenApp=$isFirstOpenApp",
    );

    // if (isLoggedIn && state.matchedLocation != PATH_HOME) {
    //   return PATH_HOME;
    // }

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

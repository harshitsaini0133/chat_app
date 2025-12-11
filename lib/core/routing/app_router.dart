import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/auth/domain/entities/user_entity.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/chats',
        builder: (context, state) {
          final user = state.extra as UserEntity;
          return ChatListPage(user: user);
        },
      ),
      GoRoute(
        path:
            '/chat_details', // Using query params or extra? Extra is easier for objects
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ChatPage(
            chatId: extra['chatId'],
            currentUserId: extra['currentUserId'],
            chatName: extra['chatName'],
          );
        },
      ),
    ],
  );
}

import 'dart:developer';

import 'package:demo_frontend/views/home/home_screen.dart';
import 'package:demo_frontend/views/login/login_screen.dart';
import 'package:demo_frontend/views/notes/note_create.dart';
import 'package:demo_frontend/views/notes/note_edit.dart';
import 'package:demo_frontend/views/notes/note_screen.dart';
import 'package:demo_frontend/views/profile/profile_edit_screen.dart';
import 'package:demo_frontend/views/profile/profile_screen.dart';
import 'package:demo_frontend/views/signup/signup_screen.dart';
import 'package:demo_frontend/views/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_frontend/providers/auth_provider.dart';
import 'package:demo_frontend/routes/router_info.dart';

class AppRouterDelegate extends RouterDelegate<AppRouterInfo>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRouterInfo> {
  final ProviderRef ref;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  AppRouterInfo _currentConfiguration = AppRouterInfo.register();

  AppRouterDelegate({required this.ref})
      : navigatorKey = GlobalKey<NavigatorState>() {
    final auth = ref.read(authProvider);
    if (auth.status == AuthStatus.authenticated) {
      _currentConfiguration = AppRouterInfo.home();
    }
  }
  @override
  AppRouterInfo get currentConfiguration => _currentConfiguration;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    log(auth.status.toString());
    return Navigator(
      key: navigatorKey,
      pages: [
        if (auth.status == AuthStatus.unknown)
          const MaterialPage(child: SplashPage()),
        if (auth.status == AuthStatus.authenticated ||
            _currentConfiguration.isRegister())
          if (_currentConfiguration.isHome())
            const MaterialPage(child: HomeScreen()),
        if (_currentConfiguration.isProfile())
          const MaterialPage(child: ProfileScreen()),
        if (_currentConfiguration.isRegister())
          const MaterialPage(child: SignupScreen()),
        if (_currentConfiguration.isNoteCreate())
          const MaterialPage(child: NoteCreateScreen()),
        if (_currentConfiguration.isNoteEdit())
          MaterialPage(child: NoteEdit(id: _currentConfiguration.id!)),
        if (_currentConfiguration.isNote())
          MaterialPage(child: NoteScreen(id: _currentConfiguration.id!)),
        if (_currentConfiguration.isProfileEdit())
          const MaterialPage(child: ProfileEditScreen()),
        if (auth.status == AuthStatus.unauthenticated)
          const MaterialPage(child: LoginScreen()),
      ],
      onPopPage: (route, result) {
        return route.didPop(result);
      },
      onGenerateRoute: (settings) {
        if (settings.name!.contains('/note/')) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
              builder: (context) => NoteScreen(id: args['id'] as String));
        } else if (settings.name == '/note/edit') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
              builder: (context) => NoteEdit(id: args['id'] as String));
        } else if (settings.name == '/profile/edit') {
          return MaterialPageRoute(
              builder: (context) => const ProfileEditScreen());
        } else if (settings.name == '/note/create') {
          return MaterialPageRoute(
              builder: (context) => const NoteCreateScreen());
        } else if (settings.name == '/profile') {
          return MaterialPageRoute(builder: (context) => const ProfileScreen());
        } else if (settings.name == '/register') {
          return MaterialPageRoute(builder: (context) => const SignupScreen());
        } else if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) => const HomeScreen());
        } else if (settings.name == '/login') {
          return MaterialPageRoute(builder: (context) => const LoginScreen());
        } else {
          return MaterialPageRoute(builder: (context) => const SplashPage());
        }
      },
    );
  }

  push(Widget page) {
    navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => page),
    );
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(AppRouterInfo configuration) async {
    _currentConfiguration = configuration;
    notifyListeners();
  }
}

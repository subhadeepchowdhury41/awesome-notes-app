import 'package:demo_frontend/views/home/home_screen.dart';
import 'package:demo_frontend/views/login/login_screen.dart';
import 'package:demo_frontend/views/note/note_create.dart';
import 'package:demo_frontend/views/note/note_edit.dart';
import 'package:demo_frontend/views/note/note_screen.dart';
import 'package:demo_frontend/views/profile/profile_edit_screen.dart';
import 'package:demo_frontend/views/profile/profile_screen.dart';
import 'package:demo_frontend/views/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_frontend/providers/auth_provider.dart';
import 'package:demo_frontend/routes/router_info.dart';

class AppRouterDelegate extends RouterDelegate<AppRouterInfo>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRouterInfo> {
  final WidgetRef ref;

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

    if (auth.status == AuthStatus.authenticated ||
        _currentConfiguration.isRegister()) {
      return Navigator(
        key: navigatorKey,
        pages: [
          if (_currentConfiguration.isHome()) const MaterialPage(child: HomeScreen()),
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
        ],
        onPopPage: (route, result) {
          return route.didPop(result);
        },
      );
    } else {
      return Navigator(
        key: navigatorKey,
        pages: const [
          MaterialPage(child: LoginScreen()),
        ],
        onPopPage: (route, result) {
          return route.didPop(result);
        },
      );
    }
  }

  @override
  Future<void> setNewRoutePath(AppRouterInfo configuration) async {
    _currentConfiguration = configuration;
    notifyListeners();
  }
}

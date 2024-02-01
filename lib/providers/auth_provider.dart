import 'package:demo_frontend/models/auth_model.dart';
import 'package:demo_frontend/services/hive_boxes.dart';
import 'package:demo_frontend/services/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthNotifier extends ChangeNotifier {
  AuthStatus status = AuthStatus.unknown;
  String? _id;
  Auth? _auth;

  String? get id => _id;
  Auth? get auth => _auth;

  Future<void> init() async {
    final auth = HiveBoxes.getAuthBox().values.firstOrNull;
    if (auth != null && auth.accessToken != null && auth.refreshToken != null) {
      status = AuthStatus.authenticated;
    } else {
      status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> login(
      {required String username, required String password}) async {
    await RestClient.post('auth/sigin', {
      "username": username,
      "password": password,
    }).then((res) {
      if (res?.statusCode == 200) {
        _auth = Auth.fromMap(res?.data);
        status = AuthStatus.authenticated;
        notifyListeners();
      }
    }).catchError((e) {
      status = AuthStatus.unauthenticated;
      notifyListeners();
    });
    notifyListeners();
  }

  void logout() {
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}

final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return AuthNotifier();
});

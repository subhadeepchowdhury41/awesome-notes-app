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

  Future<void> fetchUserId() async {
    await RestClient.get('auth/me', includeAuthTokens: true).then((res) {
      if (res?.statusCode == 200) {
        _id = res?.data['sub'];
        if (_id == null) {
          status = AuthStatus.unauthenticated;
          throw Exception('Invalid user id');
        }
        status = AuthStatus.authenticated;
        notifyListeners();
      }
    });
  }

  Future<void> init() async {
    final auth = HiveBoxes.getAuthBox().values.firstOrNull;
    if (auth != null && auth.accessToken != null && auth.refreshToken != null) {
      await fetchUserId();
    } else {
      status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> login(
      {required String username, required String password}) async {
    await RestClient.post('auth/signin', {
      "username": username,
      "password": password,
    }).then((res) async {
      if (res?.statusCode == 201) {
        if (res == null || res.data == null) {
          throw Exception('Invalid auth tokens');
        }
        _auth = Auth.fromMap(res.data);
        await HiveBoxes.getAuthBox().clear();
        await HiveBoxes.getAuthBox().put('auth', _auth!);
        await fetchUserId();
      }
    }).catchError((e) {
      status = AuthStatus.unauthenticated;
      notifyListeners();
    });
  }

  Future<void> logout() async {
    await RestClient.post('auth/logout', {}, includeAuthTokens: true)
        .then((res) {
      if (res?.statusCode == 200) {
        HiveBoxes.getAuthBox().clear();
      }
    }).catchError((e) {
      status = AuthStatus.unauthenticated;
      notifyListeners();
    });
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}

final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return AuthNotifier();
});

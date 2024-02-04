import 'package:demo_frontend/models/user_model.dart';
import 'package:demo_frontend/services/rest_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  String? _userId;
  void setUserId(String? userId) {
    if (userId == null) return;
    _userId = userId;
    refresh();
  }

  Future<void> refresh() async {
    if (_userId == null) return;
    await RestClient.get('users/$_userId', includeAuthTokens: true).then((res) {
      if (res != null) {
        state = User.fromMap(res.data);
      }
    });
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});

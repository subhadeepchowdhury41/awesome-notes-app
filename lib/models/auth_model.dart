import 'package:hive/hive.dart';

part 'auth_model.g.dart';

@HiveType(typeId: 0)
class Auth {
  @HiveField(0)
  final String? accessToken;

  @HiveField(1)
  final String? refreshToken;

  Auth({this.accessToken, this.refreshToken});

  factory Auth.fromMap(Map<String, dynamic> data) {
    return Auth(
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
    );
  }
}

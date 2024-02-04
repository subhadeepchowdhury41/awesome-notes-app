import 'dart:developer';

import 'package:demo_frontend/services/hive_boxes.dart';
import 'package:dio/dio.dart';

class RestClient {
  static const String _baseUrl = 'http://192.168.29.10:3000';
  static final _dio = Dio();

  static Future<Response?> get(String path,
      {bool includeAuthTokens = false, bool refresh = false}) async {
    log('$_baseUrl/$path ===>');
    String? accessToken;
    String? refreshToken;
    try {
      accessToken = HiveBoxes.getAuthBox().values.first.accessToken;
      refreshToken = HiveBoxes.getAuthBox().values.first.refreshToken;
    } catch (e) {
      log('No access token found: $e');
    }
    try {
      if (accessToken == null && refreshToken == null && includeAuthTokens) {
        throw Exception('Token required but no access token found');
      }
      final response = await _dio.get('$_baseUrl/$path',
          options: Options(headers: {
            'Authorization': includeAuthTokens
                ? 'Bearer ${refresh ? refreshToken : accessToken}'
                : '',
          }));
      log('${response.data}', level: 5);
      return response;
    } on DioException catch (e) {
      log('Error: ${e.response?.statusCode}  ${e.response?.data}');
      rethrow;
    }
  }

  static Future<Response?> post(
    String path,
    Map<String, dynamic> data, {
    bool includeAuthTokens = false,
  }) async {
    log('$_baseUrl/$path ===> ');
    String? accessToken;
    try {
      accessToken = HiveBoxes.getAuthBox().values.first.accessToken;
    } catch (e) {
      log('No access token found: $e');
    }
    try {
      if (accessToken == null && includeAuthTokens) {
        throw Exception('No access token found');
      } else {}
      final response = await _dio.post('$_baseUrl/$path',
          data: data,
          options: Options(headers: {
            'Authorization': includeAuthTokens ? 'Bearer $accessToken' : '',
          }));
      log('${response.data}', level: 5);
      return response;
    } on DioException catch (e) {
      log('Error: ${e.response?.statusCode}  ${e.response?.data}');
      rethrow;
    }
  }

  static Future<Response?> patch(String path, Map<String, dynamic> data, {bool includeAuthTokens = false}) async {
    log('$_baseUrl/$path ===> ');
    String? accessToken;
    try {
      accessToken = HiveBoxes.getAuthBox().values.first.accessToken;
    } catch (e) {
      log('No access token found: $e');
    }
    try {
      if (accessToken == null && includeAuthTokens) {
        throw Exception('No access token found');
      } else {}
      final response = await _dio.patch('$_baseUrl/$path',
          data: data,
          options: Options(headers: {
            'Authorization': includeAuthTokens ? 'Bearer $accessToken' : '',
          }));
      log('${response.data}', level: 5);
      return response;
    } on DioException catch (e) {
      log('Error: ${e.response?.statusCode}  ${e.response?.data}');
      rethrow;
    }
  }

  static Future<Response?> delete(String path, {bool includeAuthTokens = false}) async {
    log('$_baseUrl/$path ===> ');
    String? accessToken;
    try {
      accessToken = HiveBoxes.getAuthBox().values.first.accessToken;
    } catch (e) {
      log('No access token found: $e');
    }
    try {
      if (accessToken == null && includeAuthTokens) {
        throw Exception('No access token found');
      } else {}
      final response = await _dio.delete('$_baseUrl/$path',
          options: Options(headers: {
            'Authorization': includeAuthTokens ? 'Bearer $accessToken' : '',
          }));
      log('${response.data}', level: 5);
      return response;
    } on DioException catch (e) {
      log('Error: ${e.response?.statusCode}  ${e.response?.data}');
      rethrow;
    }
  }
}

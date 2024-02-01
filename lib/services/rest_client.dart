import 'package:dio/dio.dart';

class RestClient {
  static const String _baseUrl = 'http://localhost:3000';
  static final _dio = Dio();

  static Future<Response?> get(String path) async {
    try {
      final response = await _dio.get('$_baseUrl/$path');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response?> post(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('$_baseUrl/$path', data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response?> patch(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch('$_baseUrl/$path', data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

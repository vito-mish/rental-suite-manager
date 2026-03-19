import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiService {
  static const _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3001',
  );

  static Map<String, String> get _headers {
    final token = Supabase.instance.client.auth.currentSession?.accessToken;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Map<String, String> get _authOnlyHeaders {
    final token = Supabase.instance.client.auth.currentSession?.accessToken;
    return {
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> get(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse('$_baseUrl$path').replace(queryParameters: query);
    final res = await http.get(uri, headers: _headers);
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(res);
  }

  static Future<void> delete(String path) async {
    final uri = Uri.parse('$_baseUrl$path');
    debugPrint('[API] DELETE $uri');
    final res = await http.delete(uri, headers: _authOnlyHeaders);
    debugPrint('[API] DELETE response: ${res.statusCode} ${res.body}');
    if (res.statusCode != 204) {
      if (res.body.isNotEmpty) {
        final data = jsonDecode(res.body);
        throw ApiException(data['error']?.toString() ?? '操作失敗');
      }
      throw ApiException('刪除失敗 (${res.statusCode})');
    }
  }

  static Future<Map<String, dynamic>> patch(String path, [Map<String, dynamic>? body]) async {
    final uri = Uri.parse('$_baseUrl$path');
    debugPrint('[API] PATCH $uri');
    final res = await http.patch(
      uri,
      headers: body != null ? _headers : _authOnlyHeaders,
      body: body != null ? jsonEncode(body) : null,
    );
    debugPrint('[API] PATCH response: ${res.statusCode} ${res.body}');
    return _handleResponse(res);
  }

  static Map<String, dynamic> _handleResponse(http.Response res) {
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode >= 400) {
      final error = data['error'];
      final msg = error is String ? error : '操作失敗';
      throw ApiException(msg, statusCode: res.statusCode);
    }
    return data;
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

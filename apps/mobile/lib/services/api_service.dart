import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiService {
  static const _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3001',
  );

  static Future<String?> _getFreshToken() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) return null;
    if (session.isExpired) {
      final response = await Supabase.instance.client.auth.refreshSession();
      return response.session?.accessToken;
    }
    return session.accessToken;
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getFreshToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, String>> _getAuthOnlyHeaders() async {
    final token = await _getFreshToken();
    return {
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> get(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse('$_baseUrl$path').replace(queryParameters: query);
    final headers = await _getHeaders();
    final res = await http.get(uri, headers: headers);
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    final res = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    final res = await http.put(
      Uri.parse('$_baseUrl$path'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _handleResponse(res);
  }

  static Future<void> delete(String path) async {
    final uri = Uri.parse('$_baseUrl$path');
    debugPrint('[API] DELETE $uri');
    final headers = await _getAuthOnlyHeaders();
    final res = await http.delete(uri, headers: headers);
    debugPrint('[API] DELETE response: ${res.statusCode} ${res.body}');
    if (res.statusCode != 204) {
      if (res.body.isNotEmpty) {
        final data = jsonDecode(res.body);
        throw ApiException(data['error']?.toString() ?? 'Operation failed');
      }
      throw ApiException('Delete failed (${res.statusCode})');
    }
  }

  static Future<Map<String, dynamic>> patch(String path, [Map<String, dynamic>? body]) async {
    final uri = Uri.parse('$_baseUrl$path');
    debugPrint('[API] PATCH $uri');
    final headers = body != null ? await _getHeaders() : await _getAuthOnlyHeaders();
    final res = await http.patch(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    debugPrint('[API] PATCH response: ${res.statusCode} ${res.body}');
    return _handleResponse(res);
  }

  static Map<String, dynamic> _handleResponse(http.Response res) {
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode >= 400) {
      final error = data['error'];
      final msg = error is String ? error : 'Operation failed';
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

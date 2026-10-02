import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class AuthService {
  // POST /api/auth/login  ->  body: { "phoneNumber": "+998..." }
  static Future<http.Response> login(String phoneNumber) {
    return http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber}),
    );
  }

  // POST /api/auth/verify-login  ->  body: { "phoneNumber": "+998...", "code": "12345" }
  static Future<http.Response> verifyLogin(String phoneNumber, String code) {
    return http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/verify-login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber, 'code': code}),
    );
  }
}
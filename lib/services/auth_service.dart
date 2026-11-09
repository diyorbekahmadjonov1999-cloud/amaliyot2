import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:amaliyot2/config/api_config.dart';

class AuthService {
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  static Future<http.Response> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: _headers,
      body: jsonEncode(body),
    );

    print('\n\n**************************************************');
    print('🌐 API SO\'ROV: $path');
    print('STATUS: ${response.statusCode}');
    print('JAVOB: ${response.body}');
    try {
      final data = jsonDecode(response.body);
      if (data is Map && (data.containsKey('otp') || data.containsKey('code'))) {
        final code = data['otp'] ?? data['code'];
        print('🔑🔑🔑 BIR MARTALIK KOD: $code 🔑🔑🔑');
      }
    } catch (_) {}
    print('**************************************************\n\n');

    return response;
  }

  // ---------- SIGN UP ----------

  /// POST /api/auth/register
  static Future<http.Response> register({
    required String fullName,
    required String phoneNumber,
    required int brandId,
    required int carModelId,
    required int carYear,
    required int carKm,
    required String carNumber,
  }) {
    return _post('/api/auth/register', {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'brandId': brandId,
      'carModelId': carModelId,
      'carYear': carYear,
      'carKm': carKm,
      'carNumber': carNumber,
    });
  }

  /// POST /api/auth/verify-register
  static Future<http.Response> verifyRegister(String phoneNumber, String code) {
    return _post('/api/auth/verify-register', {
      'phoneNumber': phoneNumber,
      'code': code,
    });
  }

  // ---------- SIGN IN ----------

  /// POST /api/auth/login
  static Future<http.Response> login(String phoneNumber) {
    return _post('/api/auth/login', {'phoneNumber': phoneNumber});
  }

  /// POST /api/auth/verify-login
  static Future<http.Response> verifyLogin(String phoneNumber, String code) {
    return _post('/api/auth/verify-login', {
      'phoneNumber': phoneNumber,
      'code': code,
    });
  }
}
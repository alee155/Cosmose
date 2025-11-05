import 'dart:convert';
import 'package:cosmose/models/login_response.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static const String _baseUrl = "https://cosmoseworld.fr/api";

  static Future<LoginResponse?> loginUser({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final Uri url = Uri.parse("$_baseUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email.trim(),
          "password": password.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
        return loginResponse;
      } else {
        return null;
      }
    } catch (error) {
      debugPrint("Error: $error");
      return null;
    }
  }
}

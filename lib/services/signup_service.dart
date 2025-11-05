import 'dart:convert';

import 'package:flutter/foundation.dart'; // Required for debugPrint
import 'package:http/http.dart' as http;

class SignupService {
  static const String _baseUrl = "https://cosmoseworld.fr/api";

  /// **Register User**
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final Uri url = Uri.parse("$_baseUrl/register");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "role": "user",
        }),
      );

      debugPrint("Response Status Code: ${response.statusCode}");

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // ✅ Pretty Print JSON Response
      final formattedJson =
          const JsonEncoder.withIndent('  ').convert(responseData);
      debugPrint(
          "________________Signup API Response________________:\n$formattedJson");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"success": true, "message": "Registration successful!"};
      } else {
        return {
          "success": false,
          "message": responseData["message"] ?? "Registration failed"
        };
      }
    } catch (error) {
      debugPrint("Error: $error"); // ✅ Better Error Logging
      return {"success": false, "message": "Something went wrong"};
    }
  }
}

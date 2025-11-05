import 'dart:convert';

import 'package:http/http.dart' as http;

class ChangePasswordServices {
  static Future<Map<String, dynamic>> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final String url = "https://cosmoseworld.fr/api/change-password";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "current_password": oldPassword,
          "new_password": newPassword,
          "new_password_confirmation": confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "success": false,
          "message": "Failed to change password: ${response.body}"
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }
}

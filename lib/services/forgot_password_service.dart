import 'dart:convert';

import 'package:http/http.dart' as http;

class ForgotPasswordService {
  static Future<Map<String, dynamic>> sendResetLink(String email) async {
    final url = Uri.parse('https://cosmoseworld.fr/api/forgot-password');

    try {
      final response = await http.post(
        url,
        body: jsonEncode({"email": email}),
        headers: {"Content-Type": "application/json"},
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      print(
          "____________Forgot Password API Response____________: $responseData");

      return responseData;
    } catch (e) {
      print("Error: $e");
      return {"error": "Something went wrong!"};
    }
  }
}

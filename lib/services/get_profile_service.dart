import 'dart:convert';

import 'package:cosmose/Models/get_profile_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String apiUrl = "https://cosmoseworld.fr/api/getProfile";

  Future<GetProfile?> fetchUserProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return GetProfile.fromJson(data);
      } else {
        print("Error: ${response.statusCode}, ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}

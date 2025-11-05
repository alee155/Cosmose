import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LikeService {
  static Future<void> likeStream({
    required BuildContext context,
    required String token,
    required String channelName,
  }) async {
    final url = Uri.parse('https://cosmoseworld.fr/api/stream/like');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'channel_name': channelName}),
      );

      print("📨 Like API Response Status: ${response.statusCode}");
      print("📨 Like API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 You have liked the stream!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to like stream: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("❌ Like API error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Network error while liking stream.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

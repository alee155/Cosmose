import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DislikeService {
  static Future<void> dislikeStream({
    required BuildContext context,
    required String token,
    required String channelName,
  }) async {
    final url = Uri.parse('https://cosmoseworld.fr/api/stream/unlike');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'channel_name': channelName}),
      );

      print("📨 Dislike API Response Status: ${response.statusCode}");
      print("📨 Dislike API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('👎 You have disliked the stream!'),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to dislike stream: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("❌ Dislike API error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Network error while disliking stream.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

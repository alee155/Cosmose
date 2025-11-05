import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommentService {
  static Future<void> sendComment({
    required BuildContext context,
    required String token,
    required String channelName,
    required String comment,
  }) async {
    final url = Uri.parse('https://cosmoseworld.fr/api/stream/comment');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'channel_name': channelName, 'comment': comment}),
      );

      print(
        "**********📨 Comment API Status**********: ${response.statusCode}",
      );
      print("**********📨 Comment API Body**********: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('💬 Comment posted!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to post comment: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("❌ Comment API error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Network error while posting comment.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

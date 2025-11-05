import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BlockService {
  static Future<void> blockUser({
    required BuildContext context,
    required String token,
    required String channelName,
    required int remoteUid,
  }) async {
    final url = Uri.parse('https://cosmoseworld.fr/api/stream/block');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'channel_name': channelName,
          'type': 'block',
          'user_id': remoteUid,
        }),
      );

      print("📨 Block API Response Status: ${response.statusCode}");
      print("📨 Block API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🚫 User blocked.'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to block user: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("❌ Block API error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Network error while blocking user.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

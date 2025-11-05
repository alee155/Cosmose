import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LeaveService {
  static Future<void> leaveStream({
    required BuildContext context,
    required String token,
    required String channelName,
  }) async {
    final url = Uri.parse('https://cosmoseworld.fr/api/stream/leave');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'channel_name': channelName}),
      );

      print("📨 Leave API Response Status: ${response.statusCode}");
      print("📨 Leave API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🚪 You left the stream.'),
            backgroundColor: Colors.blue,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to leave stream: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("❌ Leave API error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Network error while leaving stream.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';

class WishlistService {
  static const String baseUrl = "https://cosmoseworld.fr/api/wishlist/add";

  // 🛠 Add To Wishlist API Call
  static Future<bool> addToWishlist(
      BuildContext context, int productId, String token) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // 🔥 Pass token
        },
        body: jsonEncode({
          "product_id": productId, // Send product ID
        }),
      );

      final responseData = jsonDecode(response.body); // Parse response
      print("📜 Wishlist Response: $responseData");

      if (response.statusCode == 201) {
        // ✅ Show success toast
        _showSuccessToast(
            context, responseData["message"] ?? "Added to wishlist!");
        return true;
      } else {
        // ❌ Show error toast with actual message
        _showErrorToast(
            context, responseData["message"] ?? "Failed to add to wishlist.");
        return false;
      }
    } catch (e) {
      print("🚨 Error adding to wishlist: $e");
      _showErrorToast(context, "Something went wrong!");
      return false;
    }
  }

  // 🎉 Show Success Toast
  static void _showSuccessToast(BuildContext context, String message) {
    MotionToast.success(
      title:
          const Text("Success", style: TextStyle(fontWeight: FontWeight.bold)),
      description: Text(message),
      position: MotionToastPosition.top,
    ).show(context);
  }

  // ❌ Show Error Toast
  static void _showErrorToast(BuildContext context, String message) {
    MotionToast.error(
      title: const Text("Error", style: TextStyle(fontWeight: FontWeight.bold)),
      description: Text(message),
      position: MotionToastPosition.top,
    ).show(context);
  }
}

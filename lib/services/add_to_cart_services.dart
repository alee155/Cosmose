import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';

class AddToCartService {
  static Future<void> addToCart(BuildContext context, int proId, int quant,
      String weight, String token) async {
    const String url = "https://cosmoseworld.fr/api/addtocart";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "pro_id": proId,
          "quant": quant,
          "weight": weight,
        }),
      );

      final responseData = jsonDecode(response.body);
      print("🛒 Add to Cart Response: $responseData");

      // ✅ Check if the response contains an error
      if (responseData.containsKey("error")) {
        // ❌ Show RED error toast
        MotionToast.error(
          title: const Text("Error"),
          description: Text(responseData["error"]),
        ).show(context);
      } else {
        // ✅ Show GREEN success toast
        MotionToast.success(
          title: const Text("Success"),
          description: Text(responseData.toString()), // Full response
        ).show(context);
      }
    } catch (e) {
      print("❌ Error adding to cart: $e");
      MotionToast.error(
        title: const Text("Error"),
        description: const Text("Failed to add item to cart"),
      ).show(context);
    }
  }
}

import 'dart:convert';

import 'package:cosmose/models/cart_model.dart'; // Import your CartModel
import 'package:http/http.dart' as http;

class MyCartServices {
  Future<CartModel?> fetchCart(String token) async {
    final String url = "https://cosmoseworld.fr/api/cart";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("______________My Cart Api____________: $data");

        return CartModel.fromJson(data); // Return parsed cart model
      } else {
        print("Failed to load cart: ${response.statusCode}");
        print("Response: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error fetching cart: $e");
      return null;
    }
  }
}

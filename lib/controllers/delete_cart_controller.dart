import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DeleteCartController extends GetxController {
  var isSelectionMode = false.obs;
  var selectedItems = <int>[].obs;
  var pro_id = [].obs; // Store selected product IDs in "pro_id"

  void toggleSelectionMode() {
    isSelectionMode.value = !isSelectionMode.value;
    if (!isSelectionMode.value) {
      selectedItems.clear();
      pro_id.clear();
    }
  }

  void toggleItemSelection(int id) {
    if (selectedItems.contains(id)) {
      selectedItems.remove(id);
      pro_id.remove(id); // Remove from "pro_id" as well
    } else {
      selectedItems.add(id);
      pro_id.add(id); // Add to "pro_id"
    }
  }

  Future<void> removeFromCart(String token, Function onCartUpdated) async {
    if (pro_id.isEmpty) return; // Ensure "pro_id" has items

    final String url = "https://cosmoseworld.fr/api/removefromcart";
    final body = jsonEncode({"pro_id": pro_id.toList()});

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print("Items removed successfully: ${response.body}");

        selectedItems.clear();
        pro_id.clear(); // Clear after successful deletion

        // Notify UI to fetch updated cart data
        onCartUpdated();
      } else {
        print("Failed to remove items: ${response.statusCode}");
      }
    } catch (e) {
      print("Error removing items: $e");
    }
  }
}

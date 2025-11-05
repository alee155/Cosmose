import 'dart:convert';

import 'package:cosmose/models/wishlist_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WishlistController extends GetxController {
  RxList<WishlistItem> wishlist = <WishlistItem>[].obs;
  RxBool isLoading = true.obs;
  RxBool isDeleteMode = false.obs;
  RxSet<int> selectedItems = <int>{}.obs;
  String token = '';

  void setToken(String userToken) {
    token = userToken;
  }

  @override
  void onInit() {
    super.onInit();
    fetchWishList();
  }

  Future<void> fetchWishList() async {
    const String url = "https://cosmoseworld.fr/api/wishlist";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      // Log the response body
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        wishlist.value = (data['wishlist'] as List)
            .map((item) => WishlistItem.fromJson(item))
            .toList();
      } else {
        showSnackBar("Failed to fetch wishlist", false);
      }
    } catch (e) {
      print("Error fetching wishlist: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSelectedItems() async {
    if (selectedItems.isEmpty) {
      showSnackBar("No items selected", false);
      return;
    }

    bool allDeleted = true;
    for (int productId in selectedItems) {
      final String url = "https://cosmoseworld.fr/api/wishlist/$productId";
      try {
        final response = await http.delete(
          Uri.parse(url),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        );

        if (response.statusCode == 200) {
          wishlist.removeWhere((item) => item.productId == productId);
        } else {
          allDeleted = false;
        }
      } catch (e) {
        allDeleted = false;
      }
    }

    selectedItems.clear();
    isDeleteMode.value = false;

    showSnackBar(
        allDeleted ? "Items deleted successfully" : "Some deletions failed",
        allDeleted);
  }

  void toggleDeleteMode() {
    isDeleteMode.value = !isDeleteMode.value;
    selectedItems.clear();
  }

  void toggleSelection(int productId) {
    if (selectedItems.contains(productId)) {
      selectedItems.remove(productId);
    } else {
      selectedItems.add(productId);
    }
  }

  void showSnackBar(String message, bool success) {
    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? Colors.green : Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      print("Error: No context available for Snackbar");
    }
  }
}

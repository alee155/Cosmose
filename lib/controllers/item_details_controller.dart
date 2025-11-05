import 'package:cosmose/services/add_to_cart_services.dart';
import 'package:cosmose/services/add_to_wishlist_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemDetailsController extends GetxController {
  var productQuantities = <int, int>{}.obs; // Store quantity per product
  var favoriteProducts = <int, bool>{}.obs; // Track favorites

  void increment(int productId) {
    if (productQuantities.containsKey(productId)) {
      productQuantities[productId] = productQuantities[productId]! + 1;
    } else {
      productQuantities[productId] = 2; // If product is new, start from 2
    }
  }

  void decrement(int productId) {
    if (productQuantities.containsKey(productId) &&
        productQuantities[productId]! > 1) {
      productQuantities[productId] = productQuantities[productId]! - 1;
    }
  }

  int getQuantity(int productId) {
    return productQuantities[productId] ?? 1; // Default quantity is 1
  }

  void resetQuantity(int productId) {
    productQuantities[productId] = 1;
  }

  void addToCart(
      BuildContext context, int productId, String size, String token) {
    int selectedQuantity = getQuantity(productId);

    // Call the API Service
    AddToCartService.addToCart(
        context, productId, selectedQuantity, size, token);
  }

  Future<void> toggleFavorite(
      BuildContext context, int productId, String token) async {
    if (favoriteProducts.containsKey(productId)) {
      favoriteProducts[productId] = !favoriteProducts[productId]!;
    } else {
      favoriteProducts[productId] = true;
    }

    print("🛍️ Product ID: $productId tapped for Wishlist");

    bool success =
        await WishlistService.addToWishlist(context, productId, token);
    if (!success) {
      favoriteProducts[productId] = false; // Revert on failure
    }
  }

  bool isFavorite(int productId) {
    return favoriteProducts[productId] ?? false;
  }
}

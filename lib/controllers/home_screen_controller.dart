import 'dart:convert';

import 'package:cosmose/Models/category_model.dart';
import 'package:cosmose/Models/product_model.dart';
import 'package:cosmose/services/all_categories_service.dart';
import 'package:cosmose/services/all_product_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var categories = <Category>[].obs;
  var allProducts = <Product>[].obs;

  var isLoading = true.obs;
  var hasError = false.obs;
  var selectedIndex = 0.obs;

  final PageController pageController = PageController();
  final ScrollController scrollController = ScrollController();
  var scrollOffset = 0.0.obs; // Track scrolling

  @override
  void onInit() {
    super.onInit();
    loadStoredData(); // Load data from SharedPreferences before fetching
    fetchCategories();
    fetchProducts();

    // Listen for scroll events
    scrollController.addListener(() {
      scrollOffset.value = scrollController.offset;
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// **Load Stored Data from SharedPreferences**
  Future<void> loadStoredData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load categories
    String? storedCategories = prefs.getString('categories');
    if (storedCategories != null) {
      List<dynamic> categoryJson = json.decode(storedCategories);
      categories
          .assignAll(categoryJson.map((e) => Category.fromJson(e)).toList());
    }

    // Load products
    String? storedProducts = prefs.getString('products');
    if (storedProducts != null) {
      List<dynamic> productJson = json.decode(storedProducts);
      allProducts
          .assignAll(productJson.map((e) => Product.fromJson(e)).toList());
    }

    isLoading.value = false;
  }

  /// **Fetch and Store Products API**
  Future<void> fetchProducts() async {
    try {
      List<Product> fetchedProducts = await AllProductsService.fetchProducts();

      if (_isNewData(fetchedProducts, allProducts)) {
        allProducts.assignAll(fetchedProducts);
        _storeData('products', fetchedProducts.map((e) => e.toJson()).toList());
      }
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  /// **Fetch and Store Categories API**
  Future<void> fetchCategories() async {
    try {
      List<Category> fetchedCategories = await AllCategories.fetchCategories();

      // Ensure "All" category comes first
      Category? allCategory;
      fetchedCategories.removeWhere((category) {
        if (category.title.toLowerCase() == "all" ||
            category.slug.toLowerCase() == "all") {
          allCategory = category;
          return true;
        }
        return false;
      });

      if (allCategory != null) {
        fetchedCategories.insert(0, allCategory!);
      }

      if (_isNewData(fetchedCategories, categories)) {
        categories.assignAll(fetchedCategories);
        _storeData(
            'categories', fetchedCategories.map((e) => e.toJson()).toList());
      }

      isLoading.value = false;

      if (categories.isNotEmpty) {
        selectedIndex.value = 0;
        pageController.jumpToPage(0);
      }
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      print(e);
    }
  }

  /// **Store Data in SharedPreferences**
  Future<void> _storeData(String key, List<dynamic> jsonData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(jsonData));
  }

  /// **Check if New Data is Different from Stored Data**
  bool _isNewData(List<dynamic> newData, List<dynamic> storedData) {
    return json.encode(newData) != json.encode(storedData);
  }

  /// **Handle Category Selection**
  void onCategoryTap(int index) {
    selectedIndex.value = index;
    pageController.jumpToPage(index);
  }
}

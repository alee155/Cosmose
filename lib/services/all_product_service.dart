import 'dart:convert';

import 'package:cosmose/Models/product_model.dart';
import 'package:http/http.dart' as http;

class AllProductsService {
  static Future<List<Product>> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('https://cosmoseworld.fr/api/products'));
      print('____________');
      print(
          '____________📢 [All Products Service API Call] Fetching products____________');
      print('____________🔹 Status Code____________: ${response.statusCode}');
      print('____________🔹 Headers____________: ${response.headers}');
      print('____________🔹 Raw API Response____________: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData.containsKey('products') && jsonData['products'] is List) {
          List<Product> products = [];

          for (var item in jsonData['products']) {
            try {
              products.add(Product.fromJson(item));
            } catch (e) {
              print('⚠️ Warning: Error parsing product: $item | Error: $e');
            }
          }

          print(
              '____________✅ Successfully fetched ${products.length} products.____________');
          return products;
        } else {
          print(
              "⚠️ Key 'products' not found or invalid format in API response.");
          return [];
        }
      } else {
        print('❌ Failed to load products. Status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('🚨 Error fetching products: $e');
      return [];
    }
  }
}

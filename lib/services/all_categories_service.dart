// Fetching All Categories Api Servicess
import 'dart:convert';

import 'package:cosmose/Models/category_model.dart';
import 'package:http/http.dart' as http;

class AllCategories {
  static const String _baseUrl = "https://cosmoseworld.fr/api/all-categories";

  static Future<List<Category>> fetchCategories() async {
    final url = Uri.parse(_baseUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode the JSON response properly
        List<dynamic> jsonData = json.decode(response.body);

        // Print response for debugging
        print("_____________Category API Response_____________: $jsonData");

        // Convert JSON list to List<Category>
        return jsonData.map((data) => Category.fromJson(data)).toList();
      } else {
        throw Exception(
            "Failed to load categories. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching categories: $e");
    }
  }
}

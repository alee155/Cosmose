import 'dart:convert';

import 'package:cosmose/Models/farmar_list_by_postalcode_model.dart';
import 'package:http/http.dart' as http;

class FarmarListByPostalCodeService {
  static const String _baseUrl = "https://cosmoseworld.fr/api/farmerlist";

  Future<List<FarmarListByPostalCode>> fetchFarmsByPostalCode(
      String postalCode) async {
    if (postalCode.isEmpty) {
      throw Exception("Postal code cannot be empty");
    }

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"postal_code": postalCode}),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return FarmarListByPostalCode.fromJsonList(jsonResponse);
      } else {
        throw Exception("Error: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      throw Exception("Failed to load farms: $e");
    }
  }
}

import 'package:cosmose/Models/farmar_list_by_postalcode_model.dart';
import 'package:cosmose/services/farmar_list_by_postal_code_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FarmsExistController extends GetxController {
  final TextEditingController postalCodeController = TextEditingController();
  final FarmarListByPostalCodeService farmService =
      FarmarListByPostalCodeService();

  var farmList = <FarmarListByPostalCode>[].obs;
  var isLoading = false.obs;
  var errorMessage = RxnString();

  Future<void> fetchFarms() async {
    String postalCode = postalCodeController.text.trim();
    if (postalCode.isEmpty) {
      errorMessage.value = "Please enter a postal code";
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      List<FarmarListByPostalCode> farms =
          await farmService.fetchFarmsByPostalCode(postalCode);
      farmList.value = farms;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

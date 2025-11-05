import 'package:get/get.dart';

class LoyaltyCardController extends GetxController {
  var isVisible = true.obs;
  var opacity = 1.0.obs;

  void toggleLoyaltyCard() {
    if (isVisible.value) {
      opacity.value = 0.0; // Fade out
      Future.delayed(Duration(milliseconds: 300), () {
        isVisible.value = false; // Hide after animation
        Future.delayed(Duration(seconds: 2), () {
          isVisible.value = true; // Show again
          opacity.value = 1.0; // Fade in
        });
      });
    }
  }
}

import 'package:get/get.dart';

class ImageController extends GetxController {
  var selectedImage = "".obs; // Observing selected image
  var selectedImageIndex = Rxn<int>(); // Nullable integer
  var showOriginalContainer = false.obs; // Boolean for showing container

  void setSelectedImage(String image, int? index) {
    selectedImage.value = image;
    selectedImageIndex.value = index;
    showOriginalContainer.value =
        false; // Hide original image container when selecting a new image
  }

  void toggleOriginalContainer() {
    showOriginalContainer.value = !showOriginalContainer.value;
  }

  void resetToOriginal(String defaultImage) {
    selectedImage.value = defaultImage;
    selectedImageIndex.value = null;
    showOriginalContainer.value = false;
  }
}

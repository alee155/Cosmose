import 'package:cosmose/Auth/login_screen.dart';
import 'package:cosmose/services/signup_service.dart';
import 'package:cosmose/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// **Signup Controller using GetX**
class SignupController extends GetxController {
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var isLoading = false.obs;
  var passwordError = RxnString();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void registerUser() async {
    isLoading.value = true;

    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ToastUtils.showErrorToast(Get.context!, "All fields are required");
      isLoading.value = false;
      return;
    }

    if (passwordError.value != null) {
      ToastUtils.showErrorToast(Get.context!, passwordError.value!);
      isLoading.value = false;
      return;
    }

    final response = await SignupService.registerUser(
      name: name,
      email: email,
      password: password,
    );

    isLoading.value = false;

    if (response["success"]) {
      ToastUtils.showSuccessToast(Get.context!, response["message"]);
      Get.off(() => LoginScreen());
    } else {
      ToastUtils.showErrorToast(Get.context!, response["message"]);
    }
  }

  void validatePasswords() {
    if (passwordController.text != confirmPasswordController.text) {
      passwordError.value = "Passwords do not match";
    } else {
      passwordError.value = null;
    }
  }
}

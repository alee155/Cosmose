import 'dart:convert';
import 'dart:io';

import 'package:cosmose/Auth/login_screen.dart';
import 'package:cosmose/controllers/user_controller.dart';
import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/widgets/CustomElevatedButton.dart';
import 'package:cosmose/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileController extends GetxController {
  var name = ''.obs;
  var farmName = ''.obs;
  var city = ''.obs;
  var country = ''.obs;
  var selectedImage = Rx<File?>(null);
  var isLoading = false.obs;
  final UserController userController = Get.find<UserController>();
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  void clearImage() {
    selectedImage.value = null;
  }

  Future<void> updateProfile(String token, BuildContext context) async {
    String url = "https://cosmoseworld.fr/api/updateProfile";
    isLoading.value = true;

    var request = http.MultipartRequest("POST", Uri.parse(url));

    // Add headers
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';

    // Add fields
    request.fields['name'] = name.value;
    request.fields['farm_name'] = farmName.value;
    request.fields['city'] = city.value;
    request.fields['country'] = country.value;

    // Add image if selected
    if (selectedImage.value != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'photo',
        selectedImage.value!.path,
      ));
    }

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseBody);

      print("Response: $decodedResponse");

      // Show Motion Toast
      if (response.statusCode == 200) {
        userController.setUserName(name.value);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('email');
        await prefs.remove('password');
        await prefs.remove('token');
        print(
            "User data cleared: email, password, and token removed from SharedPreferences");

        // Navigate to login screen and clear navigation stack
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false, // Removes all previous routes
        );
        MotionToast.success(
          title: Text(
            "Profile updated",
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Raleway',
              color: Colors.white,
            ),
          ),
          description: Text(
            decodedResponse['message'] ??
                "Login again due to security reason! ",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Raleway',
              color: Colors.white,
            ),
          ),
        ).show(context);
      } else {
        MotionToast.error(
          title: Text(
            "Error",
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Raleway',
              color: Colors.white,
            ),
          ),
          description: Text(
            decodedResponse['message'] ?? "Failed to update profile.",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Raleway',
              color: Colors.white,
            ),
          ),
        ).show(context);
      }
    } catch (e) {
      print("Error: $e");
      MotionToast.error(
        title: Text(
          "Error",
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway',
            color: Colors.white,
          ),
        ),
        description: Text(
          "Something went wrong. Please try again.",
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway',
            color: Colors.white,
          ),
        ),
      ).show(context);
    } finally {
      isLoading.value = false;
    }
  }
}

class UpdateProfile extends StatelessWidget {
  final LoginResponse loginResponse;
  UpdateProfile({super.key, required this.loginResponse});

  final UpdateProfileController controller = Get.put(UpdateProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Update Profile",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Raleway',
                  color: AppColors.primaryDark,
                ),
              ),
              Text(
                'Keep your profile up to date by editing your details below.',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 30.h),
              GestureDetector(
                onTap: controller.pickImage,
                child: Obx(() => Center(
                      child: Container(
                        width: 100.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: AppColors.green, width: 4),
                          image: controller.selectedImage.value != null
                              ? DecorationImage(
                                  image: FileImage(
                                      controller.selectedImage.value!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: controller.selectedImage.value != null
                            ? Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon:
                                          Icon(Icons.clear, color: Colors.red),
                                      onPressed: controller.clearImage,
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Icon(Icons.add_a_photo,
                                    color: Colors.black54, size: 30),
                              ),
                      ),
                    )),
              ),
              SizedBox(height: 10.h),
              CustomTextField(
                label: "Name:",
                hintText: "Enter your name",
                onChanged: (value) => controller.name.value = value,
              ),
              SizedBox(height: 10.h),
              CustomTextField(
                label: "Farm Name:",
                hintText: "Enter your farm name",
                onChanged: (value) => controller.farmName.value = value,
              ),
              SizedBox(height: 10.h),
              CustomTextField(
                label: "City:",
                hintText: "Enter your city",
                onChanged: (value) => controller.city.value = value,
              ),
              SizedBox(height: 10.h),
              CustomTextField(
                label: "Country:",
                hintText: "Enter your country",
                onChanged: (value) => controller.country.value = value,
              ),
              SizedBox(height: 30.h),
              Obx(() => controller.isLoading.value
                  ? Center(
                      child: SpinKitFadingCube(
                        color: AppColors.green,
                        size: 35.0,
                      ),
                    )
                  : Center(
                      child: CustomElevatedButton(
                        text: "Update",
                        onPressed: () => controller.updateProfile(
                            loginResponse.token, context),
                        color: AppColors.green,
                        borderRadius: 11.r,
                        height: 48.h,
                        width: 200.w,
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/services/change_password_services.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/widgets/CustomElevatedButton.dart';
import 'package:cosmose/widgets/change_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:motion_toast/motion_toast.dart';

class ForgetPasswordController extends GetxController {
  var isOldPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
}

class ForgetPassword extends StatefulWidget {
  final LoginResponse loginResponse;

  const ForgetPassword({super.key, required this.loginResponse});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final ForgetPasswordController controller =
      Get.put(ForgetPasswordController());

  @override
  void initState() {
    super.initState();
    print("___________Token___________: ${widget.loginResponse.token}");
  }

  Future<void> _handleChangePassword() async {
    String token = widget.loginResponse.token;
    String oldPassword = controller.currentPasswordController.text.trim();
    String newPassword = controller.newPasswordController.text.trim();
    String confirmPassword = controller.confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      MotionToast.error(description: Text("All fields are required!"))
          .show(context);
      return;
    }

    var response = await ChangePasswordServices.changePassword(
      token: token,
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    if (response['success'] == true) {
      MotionToast.success(
              description:
                  Text(response['message'] ?? "Password changed successfully!"))
          .show(context);
      controller.currentPasswordController.clear();
      controller.newPasswordController.clear();
      controller.confirmPasswordController.clear();
    } else {
      MotionToast.error(
              description:
                  Text(response['message'] ?? "Failed to change password"))
          .show(context);
    }

    print(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Reset Your Password",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your new password below to reset your account access.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 16.h),
            ChangePasswordFields(
              label: "Old Password",
              isVisible: controller.isOldPasswordVisible,
              controller: controller.currentPasswordController,
            ),
            SizedBox(height: 16.h),
            ChangePasswordFields(
              label: "New Password",
              isVisible: controller.isNewPasswordVisible,
              controller: controller.newPasswordController,
            ),
            SizedBox(height: 16.h),
            ChangePasswordFields(
              label: "Confirm New Password",
              isVisible: controller.isConfirmPasswordVisible,
              controller: controller.confirmPasswordController,
            ),
            SizedBox(height: 20.h),
            CustomElevatedButton(
              text: "Change",
              onPressed: _handleChangePassword,
              color: AppColors.green,
              borderRadius: 11.r,
              height: 48.h,
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
      ),
    );
  }
}

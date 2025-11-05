import 'package:cosmose/services/forgot_password_service.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/widgets/CustomElevatedButton.dart';
import 'package:cosmose/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motion_toast/motion_toast.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();

    if (email.isEmpty ||
        !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(email)) {
      _showErrorToast("Please enter a valid email address.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await ForgotPasswordService.sendResetLink(email);

    setState(() {
      _isLoading = false;
    });

    if (response.containsKey("message")) {
      _showAlertDialog("Success", response["message"]);
    } else {
      _showAlertDialog("Error", response["error"] ?? "Something went wrong!");
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway',
            color: AppColors.primaryDark,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway',
            color: AppColors.primaryDark,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Raleway',
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorToast(String message) {
    MotionToast.error(description: Text(message)).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildText("Forgot Your Password?", 24.sp, FontWeight.w700,
                AppColors.primaryDark),
            _buildText(
              "No worries! Enter your email below, and we’ll send you a password reset link.",
              16.sp,
              FontWeight.w400,
              AppColors.gray,
            ),
            CustomTextField(
              label: "",
              hintText: "Enter your email",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20.h),
            Center(
              child: _isLoading
                  ? CircularProgressIndicator(color: AppColors.green)
                  : CustomElevatedButton(
                      text: "Send Reset Link",
                      onPressed: _sendResetLink,
                      color: AppColors.green,
                      borderRadius: 20.r,
                      height: 48.h,
                      width: 200.w,
                    ),
            ),
            SizedBox(height: 20.h),
            _buildText(
                "⚠ If you don’t receive an email, check your spam folder.",
                12.sp,
                FontWeight.w400,
                Colors.red),
            _buildText("🔒 Keep your password secure.", 12.sp, FontWeight.w400,
                AppColors.primaryDark),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String text, double size, FontWeight weight, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        text,
        style: TextStyle(
            fontSize: size,
            fontWeight: weight,
            fontFamily: 'Raleway',
            color: color),
      ),
    );
  }
}

import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/utils/images_assets.dart';
import 'package:cosmose/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostCodeScreen extends StatefulWidget {
  const PostCodeScreen({super.key});

  @override
  _PostCodeScreenState createState() => _PostCodeScreenState();
}

class _PostCodeScreenState extends State<PostCodeScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  ImageAssets.cosmoselogo,
                  width: 92.w,
                  height: 77.h,
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  "Find Local Farm Products",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Raleway',
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              /// **Email Field**
              CustomTextField(
                label: "Enter Postal Code:",
                hintText: "Postal Code",
                controller: _codeController,
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

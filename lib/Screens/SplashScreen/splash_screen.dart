import 'dart:async';

import 'package:cosmose/Auth/login_screen.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/utils/images_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  double _scale = 0.8;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _navigateToLogin();
  }

  void _startAnimation() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });
  }

  void _navigateToLogin() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: _scale,
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(seconds: 1),
                child: Image.asset(
                  ImageAssets.cosmoselogo,
                  width: 205.w,
                  height: 171.h,
                ),
              ),
            ),
            SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(seconds: 1),
              child: Text(
                "Your best marketplace for your fruit",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Raleway',
                  color: AppColors.primaryDark,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

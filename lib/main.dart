import 'package:cosmose/Screens/BottomNavBarScreen/bottomNavBar_screen.dart';
import 'package:cosmose/Screens/SplashScreen/splash_screen.dart';
import 'package:cosmose/controllers/user_controller.dart';
import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/services/login_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  Stripe.publishableKey = dotenv.env["STRIPE_PUBLISH_KEY"]!;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  Get.put(UserController());
  LoginResponse? rememberedUser;

  try {
    rememberedUser = await _checkRememberedUser();
  } catch (e) {
    debugPrint("Error checking remembered user: $e");
  }

  runApp(MyApp(rememberedUser: rememberedUser));
}

class MyApp extends StatelessWidget {
  final LoginResponse? rememberedUser;

  const MyApp({super.key, required this.rememberedUser});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        try {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            home:
                rememberedUser != null
                    ? BottomNavScreen(loginResponse: rememberedUser!)
                    : SplashScreen(),
          );
        } catch (e) {
          debugPrint(
            "*******************Error initializing GetMaterialApp: $e",
          );
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: Text("An error occurred. Please restart.")),
            ),
          );
        }
      },
    );
  }
}

Future<LoginResponse?> _checkRememberedUser() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    String? token = prefs.getString('token');

    if (email != null && password != null) {
      print(
        "*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*Remembered User Found*_*_*_*_*_*_*_*_*_*_**_*_*_*_*_**_*_*_*_*_*: Email = $email, Token = $token",
      );
      print("***************Token******************* = $token");

      try {
        LoginResponse? response = await LoginService.loginUser(
          email: email,
          password: password,
          rememberMe: true,
        );

        if (response != null) {
          print(
            "*_*_*_*_*_*_*_*_*_*_**_*_*_*_*_**_*_*_*_*_*User logged in successfully with TOKEN*_*_*_*_*_*_*_*_*_*_**_*_*_*_*_**_*_*_*_*_*: ${response.token}",
          );

          Get.find<UserController>().setUserName(response.user.name);
        } else {
          print(
            "*_*_*_*_*_*_*_*_*_*_**_*_*_*_*_**_*_*_*_*_*Failed to log in the remembered user*_*_*_*_*_*_*_*_*_*_**_*_*_*_*_**_*_*_*_*_*.",
          );
        }

        return response;
      } catch (e) {
        debugPrint(
          "*_*_*_*_*_*_*_*_*_*_**_*_*_*_*_**_*_*_*_*_*Error logging in user**_*_*_*_*_*_*_*_*_*_**_*_*_*_*_**_*_*_*_*_**: $e",
        );
      }
    } else {
      print("*******************No remembered user found.*******************");
    }
  } catch (e) {
    debugPrint("Error accessing shared preferences: $e");
  }
  return null;
}

Future<void> storeUserCredentials({
  required String email,
  required String password,
  required String token,
  required bool rememberMe,
}) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (rememberMe) {
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setString('token', token);
      print("User credentials stored: Email = $email, Token = $token");
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.remove('token');
      print("*******************User credentials cleared.*******************");
    }
  } catch (e) {
    debugPrint(
      "*******************Error storing user credentials*******************: $e",
    );
  }
}

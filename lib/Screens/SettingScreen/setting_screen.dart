import 'package:cosmose/Auth/change_password_screen.dart';
import 'package:cosmose/Auth/login_screen.dart';
import 'package:cosmose/Models/get_profile_model.dart';
import 'package:cosmose/Screens/ProfileScreen/update_profile.dart';
import 'package:cosmose/Screens/ProfileScreen/user_profile_screen.dart';
import 'package:cosmose/Screens/WebViewScreen/webview_screen.dart';
import 'package:cosmose/controllers/user_controller.dart';
import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/services/get_profile_service.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/widgets/CustomElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  final LoginResponse loginResponse;
  const SettingScreen({super.key, required this.loginResponse});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final UserController userController = Get.find<UserController>();
  GetProfile? profileData;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchProfileData();
    userController.setUserName(widget.loginResponse.user.name);
  }

  Future<void> fetchProfileData() async {
    UserService userService = UserService();
    profileData = await userService.fetchUserProfile(
      widget.loginResponse.token,
    );
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Setting", style: _titleStyle()),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileCard(context),
            SizedBox(height: 20.h),
            _settingsContainer(context, [
              {
                "title": "Update Profile",
                "action": () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => UpdateProfile(
                            loginResponse: widget.loginResponse,
                          ),
                    ),
                  );
                },
              },
              {
                "title": "Language",
                "action": () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => LanguageScreen()));
                },
              },
              {
                "title": "Change Password",
                "action": () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ForgetPassword(
                            loginResponse: widget.loginResponse,
                          ),
                    ),
                  );
                },
              },
              {
                "title": "Payment History",
                "action": () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PaymentHistoryScreen()));
                },
              },
            ]),
            SizedBox(height: 20.h),
            _settingsContainer(context, [
              {
                "title": "WebView",
                "action": () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => WebViewScreen(
                            loginResponse: widget.loginResponse,
                          ),
                    ),
                  );
                },
              },
              {
                "title": "About Us",
                "action": () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => AboutUsScreen()));
                },
              },
              {
                "title": "Terms & Privacy Policy",
                "action": () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => TermsPrivacyScreen()));
                },
              },
              {
                "title": "Delete Account",
                "action": () {
                  // Show a confirmation dialog before deleting the account
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text("Confirm Deletion"),
                          content: Text(
                            "Are you sure you want to delete your account? This action cannot be undone.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                // Perform delete account logic here
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                  );
                },
              },
            ]),
            SizedBox(height: 20.h),
            CustomElevatedButton(
              text: "Logout",
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('email');
                await prefs.remove('password');
                await prefs.remove('token');
                print(
                  "User data cleared: email, password, and token removed from SharedPreferences",
                );

                // Navigate to login screen and clear navigation stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) =>
                      false, // Removes all previous routes
                );
              },
              color: Colors.red,
              borderRadius: 11.r,
              height: 48.h,
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    UserProfileScreen(loginResponse: widget.loginResponse),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: _boxDecoration(),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              backgroundImage:
                  profileData?.photo != null &&
                          profileData!.photo!['url'] != null
                      ? NetworkImage(profileData!.photo!['url'])
                          as ImageProvider
                      : const AssetImage("assets/images/buyer.png"),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  print("User Name: ${userController.userName.value}");
                  return Text(
                    userController.userName.value.isEmpty
                        ? "No Name"
                        : userController.userName.value,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  );
                }),
                Text(
                  widget.loginResponse.user.role,
                  style: _itemSubtitleStyle(),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _settingsContainer(
    BuildContext context,
    List<Map<String, dynamic>> items,
  ) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: _boxDecoration(),
      child: Column(
        children:
            items.map((item) => _buildSettingItem(context, item)).toList(),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, Map<String, dynamic> item) {
    return Column(
      children: [
        GestureDetector(
          onTap: item['action'] ?? () => print("${item['title']} tapped"),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item['title'], style: _itemTitleStyle()),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: AppColors.lightGray,
    borderRadius: BorderRadius.all(Radius.circular(10.r)),
  );

  TextStyle _titleStyle() => TextStyle(
    color: Colors.black,
    fontSize: 22.sp,
    fontWeight: FontWeight.bold,
    fontFamily: 'Raleway',
  );

  TextStyle _itemTitleStyle() => TextStyle(
    color: Colors.black,
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    fontFamily: 'Raleway',
  );

  TextStyle _itemSubtitleStyle() => TextStyle(
    color: AppColors.green,
    fontSize: 12.sp,
    fontWeight: FontWeight.bold,
    fontFamily: 'Raleway',
  );
}

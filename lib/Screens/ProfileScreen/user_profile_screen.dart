import 'package:cosmose/Models/get_profile_model.dart';
import 'package:cosmose/controllers/user_controller.dart';
import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/services/get_profile_service.dart';
import 'package:cosmose/widgets/gradient_painter_widget.dart';
import 'package:cosmose/widgets/profile_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UserProfileScreen extends StatefulWidget {
  final LoginResponse loginResponse;

  const UserProfileScreen({super.key, required this.loginResponse});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserController userController = Get.find<UserController>();
  GetProfile? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    UserService userService = UserService();
    profileData =
        await userService.fetchUserProfile(widget.loginResponse.token);
    setState(() => isLoading = false);
  }

  Widget _infoTile(IconData icon, String label, String? value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      margin: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: Colors.grey.withOpacity(0.1),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: Colors.white.withOpacity(0.9),
            child: Icon(icon, size: 24.h, color: Colors.grey),
          ),
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: Colors.black)),
              Text(value ?? "N/A",
                  style: TextStyle(fontSize: 13.sp, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Welcome Back!",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.sp,
                color: Colors.white)),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            painter: WavyGradientPainter(),
          ),
          Positioned(
            top: 180.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(top: 60.h, left: 20.w, right: 20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 10, spreadRadius: 2)
                ],
              ),
              child: isLoading
                  ? ProfileShimmer()
                  : profileData == null
                      ? Center(child: Text("Failed to load profile"))
                      : Column(
                          children: [
                            Text(profileData!.farmName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp)),
                            Text(profileData!.email,
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.grey)),
                            SizedBox(height: 20.h),
                            _infoTile(Icons.person, "Name", profileData!.name),
                            _infoTile(
                                Icons.location_city, "City", profileData!.city),
                            _infoTile(
                                Icons.flag, "Country", profileData!.country),
                            _infoTile(Icons.markunread_mailbox, "Postal Code",
                                profileData!.postalCode),
                            _infoTile(
                                Icons.badge, "ID", profileData!.id.toString()),
                          ],
                        ),
            ),
          ),
          Positioned(
            top: 120.h,
            left: MediaQuery.of(context).size.width / 2 - 50.w,
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: profileData?.photo != null &&
                        profileData!.photo!['url'] != null
                    ? Image.network(profileData!.photo!['url'],
                        fit: BoxFit.cover)
                    : SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

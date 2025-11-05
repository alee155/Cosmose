import 'package:cosmose/Screens/Agora/agor_list_stream.dart';
import 'package:cosmose/Screens/Agora/agora_stream.dart';
import 'package:cosmose/Screens/OrderScreens/order_history.dart';
import 'package:cosmose/Screens/SettingScreen/setting_screen.dart';
import 'package:cosmose/controllers/loyalty_card_controller.dart';
import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/widgets/CustomElevatedButton.dart';
import 'package:cosmose/widgets/loyalty_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AccountScreen extends StatefulWidget {
  final LoginResponse loginResponse;
  const AccountScreen({super.key, required this.loginResponse});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final LoyaltyCardController loyaltyCardController = Get.put(
    LoyaltyCardController(),
  );
  Widget _buildButton(
    String text,
    VoidCallback onPressed,
    Color color, {
    Color? textColor,
  }) {
    return CustomElevatedButton(
      text: text,
      onPressed: onPressed,
      color: color,
      textColor: textColor,
      borderRadius: 12.r,
      height: 50.h,
      width: 175.w,
    );
  }

  Widget _buildFeatureIcon(String asset, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(asset, height: 26.h, width: 26.h),
          SizedBox(height: 5.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Raleway',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyOrder(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Raleway',
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.gray,
            fontWeight: FontWeight.bold,
            fontFamily: 'Raleway',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: AppBar(
        backgroundColor: AppColors.bgcolor,
        automaticallyImplyLeading: false,
        title: Text(
          "My Account",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Raleway',
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButton("My Orders", () {
                  // Within the `FirstRoute` widget:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderHistoryScreen(),
                    ),
                  );
                }, AppColors.green),
                _buildButton(
                  "Stream",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => AgoraStreamStart(
                              loginResponse: widget.loginResponse,
                            ),
                      ),
                    );
                  },
                  AppColors.lightGray,
                  textColor: AppColors.green,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButton("View Streams", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => AgoraListStream(
                            loginResponse: widget.loginResponse,
                          ),
                    ),
                  );
                }, AppColors.green),
                _buildButton(
                  "My Offers",
                  () {},
                  AppColors.lightGray,
                  textColor: AppColors.green,
                ),
              ],
            ),
            SizedBox(height: 20.h),
            CustomElevatedButton(
              text: "Account Settings",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            SettingScreen(loginResponse: widget.loginResponse),
                  ),
                );
              },
              color: AppColors.green,
              borderRadius: 12.r,
              height: 50.h,
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(height: 20.h),
            Divider(color: AppColors.button2, thickness: 3.h),
            SizedBox(height: 10.h),
            Text(
              "Access your preferences and manage your account settings.",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway',
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Features",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway',
              ),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFeatureIcon(
                    "assets/icons/icon_History_.svg",
                    "History",
                    () {},
                  ),
                  _buildFeatureIcon(
                    "assets/icons/icon_Ticket_.svg",
                    "Royalty Card",
                    () {},
                  ),
                  _buildFeatureIcon(
                    "assets/icons/icon_payment_.svg",
                    "Payment",
                    () {},
                  ),
                  _buildFeatureIcon(
                    "assets/icons/icon_Location_.svg",
                    "Shipping Address",
                    () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            Text(
              "My Orders",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway',
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMyOrder("10", "Unpaid"),
                  _buildMyOrder("5", "Processing"),
                  _buildMyOrder("6", "Shipped"),
                  _buildMyOrder("24", "Review"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        return loyaltyCardController.isVisible.value
            ? AnimatedOpacity(
              opacity: loyaltyCardController.opacity.value,
              duration: Duration(milliseconds: 300),
              child: LoyaltyCard(
                widthPercentage: 0.8,
                onIconTap: () {
                  print("Cart icon tapped");
                },
                price: '3,13€',
                onButtonTap: () {},
                oncancelTap: () {
                  loyaltyCardController.toggleLoyaltyCard();
                },
              ),
            )
            : SizedBox();
      }),
    );
  }
}

// import 'dart:convert';

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:cosmose/Models/get_profile_model.dart';
// import 'package:cosmose/models/login_response.dart';
// import 'package:cosmose/services/get_profile_service.dart';
// import 'package:cosmose/utils/app_colors.dart';
// import 'package:cosmose/widgets/CustomElevatedButton.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';

// class LiveScreen extends StatefulWidget {
//   final LoginResponse loginResponse;
//   const LiveScreen({super.key, required this.loginResponse});

//   @override
//   State<LiveScreen> createState() => _LiveScreenState();
// }

// class _LiveScreenState extends State<LiveScreen> {
//   GetProfile? profileData;
//   final String appId = '48ba76ce17534abe9c3f5b461cca591f';
//   final String token =
//       '007eJxTYKg3Oj21IeqwmOlC5kueStP3COrpzXE/Wn04yYih4c/KOisFBhOLpERzs+RUQ3NTY5PEpFTLZOM00yQTM8Pk5ERTS8O0dhmujIZARoYvTD7MjAwQCOJzMuRklqXGl6QWlzAwAABOYx8v';
//   final String channelName = 'live_test';

//   late RtcEngine _engine;
//   int? _remoteUid;
//   bool _joined = false;
//   bool isHost = true;
//   bool isLoading = true;
//   @override
//   void initState() {
//     super.initState();
//     debugPrint(
//         '***************Token***************: ${widget.loginResponse.token}');
//     fetchProfileData();
//   }

//   Future<void> _startLiveStreamApiCall() async {
//     final uri = Uri.parse("https://cosmoseworld.fr/api/start-live-stream");
//     final response = await http.post(
//       uri,
//       headers: {
//         'Authorization': 'Bearer ${widget.loginResponse.token}',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         "title": profileData?.name ?? "Untitled",
//         "stream_url": profileData?.farmName.toString() ?? "Unknown Farm",
//       }),
//     );

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("🎉 Live stream data uploaded!")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ Failed to upload: ${response.body}")),
//       );
//     }
//   }

//   Future<void> fetchProfileData() async {
//     UserService userService = UserService();
//     profileData =
//         await userService.fetchUserProfile(widget.loginResponse.token);
//     setState(() => isLoading = false);
//   }

//   Future<void> initAgora() async {
//     await [Permission.camera, Permission.microphone].request();

//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(RtcEngineContext(appId: appId));

//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (connection, elapsed) {
//           setState(() => _joined = true);
//         },
//         onUserJoined: (connection, remoteUid, elapsed) {
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (connection, remoteUid, reason) {
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//       ),
//     );

//     await _engine.enableVideo();
//     await _engine.startPreview();

//     await _engine.setClientRole(
//       role: isHost
//           ? ClientRoleType.clientRoleBroadcaster
//           : ClientRoleType.clientRoleAudience,
//     );

//     await _engine.joinChannel(
//       token: token,
//       channelId: channelName,
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//   }

//   Future<void> rejoinWithNewRole() async {
//     await _engine.leaveChannel();
//     await _engine.setClientRole(
//       role: isHost
//           ? ClientRoleType.clientRoleBroadcaster
//           : ClientRoleType.clientRoleAudience,
//     );
//     await _engine.joinChannel(
//       token: token,
//       channelId: channelName,
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//     setState(() => _joined = false);
//   }

//   // Method to switch the camera between front and rear
//   Future<void> switchCamera() async {
//     await _engine.switchCamera();
//   }

//   @override
//   void dispose() {
//     _engine.leaveChannel();
//     _engine.release();
//     super.dispose();
//   }

//   Widget _renderLocalPreview() {
//     if (_joined && isHost) {
//       return AgoraVideoView(
//         controller: VideoViewController(
//           rtcEngine: _engine,
//           canvas: const VideoCanvas(uid: 0),
//         ),
//       );
//     } else {
//       return const Center(child: Text('Waiting for host to join...'));
//     }
//   }

//   Widget _renderRemoteVideo() {
//     if (_remoteUid != null && !isHost) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: _engine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: RtcConnection(channelId: channelName),
//         ),
//       );
//     } else if (!isHost) {
//       return const Center(child: Text('Waiting for host...'));
//     } else {
//       return const Center(child: Text('You are the host.'));
//     }
//   }

//   bool _isFullScreen = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgcolor,
//       appBar: AppBar(
//         backgroundColor: AppColors.bgcolor,
//         title: Text(
//           "Live Streaming",
//           style: TextStyle(
//               fontSize: 20.sp,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'Raleway'),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 10.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             AnimatedContainer(
//               duration:
//                   const Duration(milliseconds: 300), // ✅ Smooth transition
//               height: _isFullScreen
//                   ? MediaQuery.of(context).size.height - kToolbarHeight - 40.h
//                   : 400.h,
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(20.r),
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(20.r),
//                     child: SizedBox.expand(
//                       child: _renderLocalPreview(),
//                     ),
//                   ),
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.switch_camera),
//                           onPressed: switchCamera,
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.volume_off),
//                           color: Colors.black54,
//                           onPressed: () {
//                             // Handle mute/unmute here
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(_isFullScreen
//                               ? Icons.fullscreen_exit
//                               : Icons.fullscreen),
//                           color: Colors.black54,
//                           onPressed: () {
//                             setState(() {
//                               _isFullScreen = !_isFullScreen;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             30.h.verticalSpace,
//             isLoading
//                 ? const CircularProgressIndicator()
//                 : Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(profileData?.name.toString() ?? "No Name Available"),
//                       Text(profileData?.id.toString() ?? "No ID Available"),
//                       Text(profileData?.farmName.toString() ??
//                           "No Farm Name Available"),
//                     ],
//                   ),
//             Container(
//               height: 50.h,
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(20.r),
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(20.r),
//                     child: SizedBox.expand(
//                       child: _renderRemoteVideo(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             30.h.verticalSpace,
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 50.w),
//               child: CustomElevatedButton(
//                 text: _joined ? "End Stream" : "Start Stream",
//                 onPressed: () async {
//                   if (_joined) {
//                     await _engine.leaveChannel();
//                     setState(() {
//                       _joined = false;
//                     });
//                   } else {
//                     await initAgora();
//                     await _startLiveStreamApiCall();
//                   }
//                 },
//                 color: AppColors.green,
//                 borderRadius: 11.r,
//                 height: 48.h,
//                 width: MediaQuery.of(context).size.width,
//               ),
//             ),
//             30.h.verticalSpace,
//           ],
//         ),
//       ),
//     );
//   }
// }

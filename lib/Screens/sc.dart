// import 'package:cosmose/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class NewsFeedscreen extends StatefulWidget {
//   const NewsFeedscreen({super.key});

//   @override
//   State<NewsFeedscreen> createState() => _NewsFeedscreenState();
// }

// class _NewsFeedscreenState extends State<NewsFeedscreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgcolor,
//       appBar: AppBar(
//         backgroundColor: AppColors.bgcolor,
//         automaticallyImplyLeading: false,
//         title: Text("Social Media News Feed",
//             style: TextStyle(
//                 fontSize: 20.sp,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Raleway')),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 "Latest Posts",
//                 style: TextStyle(
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Raleway'),
//               ),
//               SizedBox(height: 5.h),
//               SizedBox(
//                 height: 252.h,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 5,
//                   padding: EdgeInsets.zero,
//                   itemBuilder: (context, index) {
//                     return Row(
//                       children: [
//                         Container(
//                           height: 252.h,
//                           width: 164.w,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(6.r),
//                               ),
//                               border: Border.all(color: AppColors.gray)),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Container(
//                                 height: 164.h,
//                                 width: 164.w,
//                                 decoration: BoxDecoration(
//                                   color: Colors.red,
//                                   borderRadius: BorderRadius.only(
//                                       topRight: Radius.circular(6.r),
//                                       topLeft: Radius.circular(6.r)),
//                                 ),
//                               ),
//                               SizedBox(height: 15.h),
//                               Text(
//                                 "Featured Products",
//                                 style: TextStyle(
//                                     fontSize: 12.sp,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: 'Raleway'),
//                               ),
//                               Row(
//                                 children: [
//                                   CircleAvatar(
//                                     backgroundColor: Colors.green,
//                                     radius: 15.r,
//                                   ),
//                                   SizedBox(width: 5.w),
//                                   Text(
//                                     "Featured ",
//                                     style: TextStyle(
//                                         fontSize: 12.sp,
//                                         fontWeight: FontWeight.bold,
//                                         fontFamily: 'Raleway'),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           width: 10.w,
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(height: 15.h),
//               Text(
//                 "Featured Products",
//                 style: TextStyle(
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Raleway'),
//               ),
//               SizedBox(height: 5.h),
//               SizedBox(
//                 height: 252.h,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 5,
//                   padding: EdgeInsets.zero,
//                   itemBuilder: (context, index) {
//                     return Row(
//                       children: [
//                         Container(
//                           height: 252.h,
//                           width: 164.w,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(6.r),
//                               ),
//                               border: Border.all(color: AppColors.gray)),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Container(
//                                 height: 164.h,
//                                 width: 164.w,
//                                 decoration: BoxDecoration(
//                                   color: Colors.red,
//                                   borderRadius: BorderRadius.only(
//                                       topRight: Radius.circular(6.r),
//                                       topLeft: Radius.circular(6.r)),
//                                 ),
//                               ),
//                               SizedBox(height: 15.h),
//                               Text(
//                                 "Amazing Product 1",
//                                 style: TextStyle(
//                                     fontSize: 12.sp,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: 'Raleway'),
//                               ),
//                               SizedBox(width: 5.w),
//                               Text(
//                                 "Price: 50 ",
//                                 style: TextStyle(
//                                     fontSize: 16.sp,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: 'Raleway'),
//                               )
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           width: 10.w,
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(height: 15.h),
//               Text(
//                 "Customer Reviews",
//                 style: TextStyle(
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Raleway'),
//               ),
//               SizedBox(height: 15.h),
//               Text(
//                 "Trending Posts",
//                 style: TextStyle(
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Raleway'),
//               ),
//               SizedBox(height: 15.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:cosmose/Models/get_profile_model.dart';
import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/services/get_profile_service.dart';
import 'package:cosmose/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';

class PaymentUpForm extends StatefulWidget {
  final LoginResponse loginResponse;
  final int shippingId;
  const PaymentUpForm({
    super.key,
    required this.loginResponse,
    required this.shippingId,
  });

  @override
  State<PaymentUpForm> createState() => _PaymentUpFormState();
}

class _PaymentUpFormState extends State<PaymentUpForm> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchProfileData();
    print("***************************************");
    print("User Token: ${widget.loginResponse.token}");
    print("Shipping ID: ${widget.shippingId}");
    print("***************************************");
  }

  bool isLoading = true;
  GetProfile? profileData;
  Future<void> fetchProfileData() async {
    UserService userService = UserService();
    profileData =
        await userService.fetchUserProfile(widget.loginResponse.token);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Information"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
              label: "First Name",
              hintText: "Enter your first name",
              controller: _firstNameController,
              keyboardType: TextInputType.name,
            ),
            CustomTextField(
              label: "Last Name",
              hintText: "Enter your last name",
              controller: _lastNameController,
              keyboardType: TextInputType.name,
            ),
            CustomTextField(
              label: "Address Line 1",
              hintText: "Enter your address",
              controller: _address1Controller,
              keyboardType: TextInputType.streetAddress,
            ),
            CustomTextField(
              label: "Address Line 2",
              hintText: "Apartment, suite, unit, etc. (optional)",
              controller: _address2Controller,
              keyboardType: TextInputType.streetAddress,
            ),
            CustomTextField(
              label: "Phone Number",
              hintText: "Enter your phone number",
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            CustomTextField(
              label: "Email Address",
              hintText: "Enter your email",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            CustomTextField(
              label: "Country",
              hintText: "Enter your country",
              controller: _countryController,
              keyboardType: TextInputType.text,
            ),
            Text(profileData?.rpAddress ?? "NA"),
            Text(profileData?.country ?? "NA"),
            Text(profileData?.rpNumber ?? "NA"),
            Text(profileData?.postalCode ?? "NA"),
            Text('${widget.shippingId}'),
          ],
        ),
      ),
    );
  }
}

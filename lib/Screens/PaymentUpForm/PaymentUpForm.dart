import 'dart:convert';

import 'package:cosmose/Models/get_profile_model.dart';
import 'package:cosmose/Screens/StripePaymentMethod/payment_home.dart';
import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/services/get_profile_service.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/widgets/CustomElevatedButton.dart';
import 'package:cosmose/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

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

  bool isLoading = true;
  GetProfile? profileData;
  String? orderResponseMessage;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
    print("***************************************");
    print("User Token: ${widget.loginResponse.token}");
    print("Shipping ID: ${widget.shippingId}");
    print("***************************************");
  }

  Future<void> fetchProfileData() async {
    UserService userService = UserService();
    profileData =
        await userService.fetchUserProfile(widget.loginResponse.token);
    setState(() => isLoading = false);
  }

  Future<void> placeOrder() async {
    // Collect form data
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String address1 = _address1Controller.text.trim();
    String address2 = _address2Controller.text.trim();
    String phone = _phoneController.text.trim();
    String email = _emailController.text.trim();
    String country = _countryController.text.trim();

    Map<String, dynamic> body = {
      'first_name': firstName,
      'last_name': lastName,
      'address1': address1,
      'address2': address2,
      'phone': phone,
      'email': email,
      'rp_number': profileData?.rpNumber ?? 'NA',
      'country': country,
      'rp_address': profileData?.rpAddress ?? 'NA',
      'shipping': widget.shippingId.toString(),
      'post_code': profileData?.postalCode ?? 'NA',
    };

    try {
      final response = await http.post(
        Uri.parse("https://cosmoseworld.fr/api/placeorder"),
        headers: {
          'Authorization': 'Bearer ${widget.loginResponse.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final message = data['success'] ?? 'Order Placed';
        final orderId = data['id'];
        final total = data['total_amount'];
        final shipping = data['shipping_cost'];

        final fullMessage =
            "$message\nOrder ID: $orderId\nTotal: $total\nShipping: $shipping";

        setState(() {
          orderResponseMessage = fullMessage;
        });

        // Show AlertDialog
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Congratulations! Your order has been placed. Now we are going towards Payment clearance.",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 5), // Show for 3 seconds
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentHomePage(message: fullMessage),
            ),
          );
        }
      } else {
        print("Failed to place order: ${response.statusCode}");
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Error making API request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Information"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  20.h.verticalSpace,
                  CustomElevatedButton(
                    text: "PAY",
                    onPressed: placeOrder,
                    color: AppColors.green,
                    borderRadius: 11.r,
                    height: 48.h,
                    width: MediaQuery.of(context).size.width,
                  ),
                  // if (orderResponseMessage != null) ...[
                  //   20.h.verticalSpace,
                  //   Container(
                  //     padding: EdgeInsets.all(12),
                  //     decoration: BoxDecoration(
                  //       color: Colors.green[50],
                  //       border: Border.all(color: Colors.green),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     child: Text(
                  //       orderResponseMessage!,
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         color: Colors.green[800],
                  //       ),
                  //     ),
                  //   ),
                  // ]
                ],
              ),
            ),
    );
  }
}

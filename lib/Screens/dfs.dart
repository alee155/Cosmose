import 'dart:convert';

import 'package:cosmose/Models/farmar_list_by_postalcode_model.dart';
import 'package:cosmose/Models/product_model.dart';
import 'package:cosmose/Screens/ItemsDetailsScreen/ietmdeatil.dart';
import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/widgets/farmer_products_shimmer.dart';
import 'package:cosmose/widgets/gradient_painter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FarmerProfileDetails extends StatefulWidget {
  final FarmarListByPostalCode farm;
  final LoginResponse loginResponse;
  const FarmerProfileDetails(
      {super.key, required this.farm, required this.loginResponse});

  static final _labelStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.sp,
    color: Colors.black,
    fontFamily: 'Roboto',
  );
  static final _valueStyle = TextStyle(
    fontSize: 13.sp,
    color: Colors.black,
    fontFamily: 'Roboto',
  );

  @override
  State<FarmerProfileDetails> createState() => _FarmerProfileDetailsState();
}

class _FarmerProfileDetailsState extends State<FarmerProfileDetails> {
  @override
  void initState() {
    super.initState();
    fetchFarmerProducts();
    // Print farm details when the widget is initialized
    print("Farm Details: ${widget.farm.id}");
  }

  List<Product> products = []; // Store fetched products
  bool isLoading = true; // Show loader until data is fetched

  Future<void> fetchFarmerProducts() async {
    final url = Uri.parse("https://cosmoseworld.fr/api/farmerproduct");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"vendor_id": widget.farm.id}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(
            "_____________Product By Framer ID API Response_____________: $data");

        // Convert JSON data to a list of Product objects
        List<Product> fetchedProducts = Product.fromJsonList(data);

        setState(() {
          products = fetchedProducts;
          isLoading = false;
        });
      } else {
        print("Error: ${response.statusCode}, ${response.body}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Exception: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Column(
      children: [
        Row(
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
                    style: FarmerProfileDetails._labelStyle
                        .copyWith(color: Colors.black)),
                Text(value,
                    style: FarmerProfileDetails._valueStyle
                        .copyWith(color: Colors.grey)),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.farm.farmName ?? "no farm name",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20.sp,
            fontFamily: 'Roboto',
            color: Colors.white,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 500.h),
              painter: WavyGradientPainter(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 130.h),
                Center(
                  child: Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        widget.farm.photo ?? '',
                        errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _infoTile(
                        Icons.person,
                        "Farm Name",
                        widget.farm.farmName ?? "no farm name",
                      ),
                      // _infoTile(Icons.email, "Email", widget.farm.email),
                      // _infoTile(Icons.call, "Phone Number",
                      //     widget.farm.phone ?? "no phone"),
                      _infoTile(Icons.flag, "City, Country",
                          "${widget.farm.city ?? 'No city'}, ${widget.farm.country ?? 'no country'}"),
                      _infoTile(
                          Icons.markunread_mailbox, "Postal Code", "59000"),
                      SizedBox(height: 10.h),
                      Text(
                        "Products",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      isLoading
                          ? FarmerProductShimmer()
                          // Show loader
                          : products.isEmpty
                              ? Center(
                                  child: Text("No Products Available",
                                      style: TextStyle(fontSize: 16.sp)),
                                )
                              : SizedBox(
                                  height: 150.h,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.zero,
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      final product = products[index];
                                      return Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(() => DetailsScreen(
                                                  product: product,
                                                  loginResponse:
                                                      widget.loginResponse));
                                              print(
                                                  "Tapped Product ID: ${product.id}");
                                            },
                                            child: FoodCard(
                                              imageUrl: product.photo,
                                              title: product.title,
                                              price: product.price,
                                              avatarUrl:
                                                  'assets/images/farm.png',
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String avatarUrl;

  const FoodCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      width: 200.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Stack(
        children: [
          // Background Image with Color Filter (Use Network Image)
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), // Dark overlay
                BlendMode.darken,
              ),
              child: Image.network(
                imageUrl.isNotEmpty
                    ? imageUrl
                    : 'https://via.placeholder.com/200',
                height: 150.h,
                width: 200.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.error, size: 50, color: Colors.red),
              ),
            ),
          ),

          // Food Title and Price
          Positioned(
            bottom: 10.h,
            left: 10.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "\$$price",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Avatar and Right Arrow (Use Network Image)
          Positioned(
            bottom: 10.h,
            right: 10.w,
            child: Row(
              children: [
                // Avatar
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 16.r,
                      backgroundColor: Colors.white,
                    ),
                    Icon(Icons.arrow_forward,
                        size: 16.r, color: AppColors.green),
                  ],
                ),

                SizedBox(width: 6.w),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cosmose/Models/product_model.dart';
import 'package:cosmose/controllers/image_controller.dart';
import 'package:cosmose/controllers/item_details_controller.dart';
import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/utils/text_styles.dart';
import 'package:cosmose/widgets/CustomElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;
  final LoginResponse loginResponse;
  const DetailsScreen(
      {super.key, required this.product, required this.loginResponse});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  VideoPlayerController? _controller;
  final ImageController imageController = Get.put(ImageController());

  @override
  void initState() {
    super.initState();
    imageController.selectedImage.value = widget.product.photo;
    print("**************USER TOKEN: ${widget.loginResponse.token}");

    if (widget.product.video != null && widget.product.video!.isNotEmpty) {
      _controller = VideoPlayerController.network(widget.product.video!)
        ..initialize().then((_) {
          setState(() {}); // Refresh the widget after initializing
        });
    }
  }

  @override
  void dispose() {
    imageController.resetToOriginal(widget.product.photo);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ItemDetailsController controller = Get.put(ItemDetailsController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            imageController
                .resetToOriginal(widget.product.photo); // Reset when leaving
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Obx(
              () => GestureDetector(
                onTap: () {
                  controller.toggleFavorite(
                      context, widget.product.id, widget.loginResponse.token);
                },
                child: CircleAvatar(
                  backgroundColor: controller.isFavorite(widget.product.id)
                      ? Colors.red.shade100
                      : Colors.grey.shade300,
                  child: Icon(
                    Icons.favorite,
                    color: controller.isFavorite(widget.product.id)
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => imageController.toggleOriginalContainer(),
              child: Stack(
                children: [
                  Obx(() => Container(
                        width: MediaQuery.of(context).size.width,
                        height: 353.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: NetworkImage(
                                imageController.selectedImage.value),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),
                  Obx(() => imageController.showOriginalContainer.value
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 353.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(widget.product.photo),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : SizedBox.shrink()),
                  if (widget.product.images.isNotEmpty)
                    Positioned(
                      bottom: 10.h,
                      right: 50.w,
                      left: 30.w,
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 2)),
                        child: SizedBox(
                          height: 100,
                          width: 300.w,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            itemCount: widget.product.images.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  imageController.setSelectedImage(
                                      widget.product.images[index], index);
                                },
                                child: Row(
                                  children: [
                                    Obx(() => Container(
                                          width: 50.w,
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.r)),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  widget.product.images[index]),
                                              fit: BoxFit.cover,
                                            ),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: imageController
                                                          .selectedImageIndex
                                                          .value ==
                                                      index
                                                  ? Colors.red
                                                  : AppColors.gray,
                                              width:
                                                  3, // Red border when selected
                                            ),
                                          ),
                                        )),
                                    SizedBox(width: 5.w)
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    widget.product.title,
                    style: TextStyles.bold(22.sp),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.product.price}/ ${widget.product.size}",
                        style: TextStyles.body(18.sp),
                      ),
                      if (widget.product.discount > 0)
                        Chip(
                          backgroundColor: AppColors.green,
                          label: Text(
                            "discount:${widget.product.discount}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text("Description", style: TextStyles.bold(18.sp)),
                  Text(
                    widget.product.description,
                    style: TextStyles.body(14.sp),
                  ),
                  SizedBox(height: 10.h),
                  Text("Summary", style: TextStyles.bold(18.sp)),
                  Text(
                    widget.product.summary,
                    style: TextStyles.body(14.sp),
                  ),
                  SizedBox(height: 10.h),
                  if (_controller != null) ...[
                    Text("Video Preview:", style: TextStyles.bold(18.sp)),
                    SizedBox(height: 8),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!),
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: Icon(
                              _controller!.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 40,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _controller!.value.isPlaying
                                    ? _controller!.pause()
                                    : _controller!.play();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            CustomElevatedButton(
              text: "Add To Cart",
              onPressed: () {
                controller.addToCart(
                  context,
                  widget.product.id,
                  widget.product.size,
                  widget.loginResponse.token,
                );
              },
              color: AppColors.green,
              borderRadius: 31.r,
              height: 48.h,
              width: 200,
            ),
            Spacer(),
            GestureDetector(
              onTap: () => controller.decrement(widget.product.id),
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: Icon(Icons.remove, color: Colors.black),
              ),
            ),
            SizedBox(width: 10.w),
            Obx(
              () => Text(
                "${controller.getQuantity(widget.product.id)}",
                style: TextStyles.bold(18.sp),
              ),
            ),
            SizedBox(width: 10.w),
            GestureDetector(
              onTap: () => controller.increment(widget.product.id),
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: Icon(Icons.add, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

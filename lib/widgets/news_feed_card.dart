import 'package:cosmose/Models/new_Interesting_Articles_model.dart';
import 'package:cosmose/Screens/NewsFeed/comment_screen.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/widgets/CustomElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class NewsFeedCard extends StatelessWidget {
  final String title;
  final String post;
  final String imageUrl;
  final Color avatarColor;
  final int commentCount;
  final int shareCount;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;
  final bool isFavorite; // To track the favorite state
  final VoidCallback onFavoriteTap;

  const NewsFeedCard({
    super.key,
    required this.title,
    required this.post,
    required this.imageUrl,
    required this.avatarColor,
    required this.onCommentTap,
    required this.onShareTap,
    required this.commentCount,
    required this.shareCount,
    required this.isFavorite, // Receiving the favorite state
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6.r)),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container
          Container(
            height: 164.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(6.r),
                topLeft: Radius.circular(6.r),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(6.r),
                topLeft: Radius.circular(6.r),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.blueAccent,
                    child:
                        Icon(Icons.broken_image, color: Colors.white, size: 50),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 5.h),

          Divider(
            thickness: 2,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onCommentTap, // Handle comment icon tap
                  child: SvgPicture.asset(
                    'assets/icons/comments.svg',
                    height: 35,
                    width: 35,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  "$commentCount", // Displaying the comment count
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway',
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: onShareTap, // Handle share icon tap
                  child: SvgPicture.asset(
                    'assets/icons/share.svg',
                    height: 35,
                    width: 35,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  "$shareCount", // Displaying the share count
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway',
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: onFavoriteTap, // Handle favorite icon tap
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: avatarColor,
                  radius: 10.r,
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    post,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Raleway',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Title
          Padding(
            padding: EdgeInsets.only(left: 30.w, right: 10.w),
            child: Text(
              title,
              maxLines: 3,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Raleway',
              ),
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

class FeaturedProductCard extends StatelessWidget {
  final String title;
  final String photoUrl;
  final String price;

  const FeaturedProductCard({
    super.key,
    required this.title,
    required this.photoUrl,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 164.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6.r)),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Product Image
          Container(
            height: 164.h,
            width: 164.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(6.r),
                topLeft: Radius.circular(6.r),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(6.r),
                topLeft: Radius.circular(6.r),
              ),
              child: Image.network(
                photoUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.blueAccent,
                    child:
                        Icon(Icons.broken_image, color: Colors.white, size: 50),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 10.h),

          /// Product Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway',
              ),
            ),
          ),

          /// Price
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              "\$ $price",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrendingPostCard extends StatelessWidget {
  final String title;
  final String summary;
  final String imageUrl;

  const TrendingPostCard({
    super.key,
    required this.title,
    required this.summary,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6.r)),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image Container
          Container(
            height: 164.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(6.r),
                topLeft: Radius.circular(6.r),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(6.r),
                topLeft: Radius.circular(6.r),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.blueAccent,
                    child:
                        Icon(Icons.broken_image, color: Colors.white, size: 50),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 15.h),

          /// Avatar Placeholder
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      Colors.green, // Adjust avatar color as needed
                  radius: 10.r,
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    summary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Raleway',
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Raleway',
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Center(
            child: CustomElevatedButton(
              text: "Submit Comment",
              onPressed: () {
                Get.to(() => CommentScreen());
              },
              color: Colors.black,
              borderRadius: 11.r,
              height: 48.h,
              width: 250.w,
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String user;
  final String product;
  final int rating;
  final String comment;
  final Color avatarColor;

  const ReviewCard({
    super.key,
    required this.user,
    required this.product,
    required this.rating,
    required this.comment,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 116.h,
      width: 220.w,
      decoration: BoxDecoration(
        color: AppColors.reviewscard,
        borderRadius: BorderRadius.all(Radius.circular(6.r)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// User Avatar and Name
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: avatarColor,
                  radius: 15.r,
                ),
                SizedBox(width: 5.w),
                Text(
                  user,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway',
                  ),
                ),
                Spacer(),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      color: index < rating ? Colors.yellow : Colors.grey,
                      size: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),

            /// Product Name
            Text(
              product,
              maxLines: 1,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway',
                color: Colors.green,
              ),
            ),

            /// Review Comment
            Text(
              comment,
              maxLines: 2,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway',
              ),
            ),

            /// Rating
          ],
        ),
      ),
    );
  }
}

class InterestingArticleCard extends StatelessWidget {
  final InterestingArticle article;

  const InterestingArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    // Debugging: Print the API image URL
    print(
        "__________________DEBUG: Article Image URL__________________ ${article.image}");

    // Check if the image URL is valid
    bool isValidUrl = Uri.tryParse(article.image)?.hasAbsolutePath ?? false;

    // Select the image provider
    ImageProvider imageProvider = isValidUrl
        ? NetworkImage(article.image) // Use network image if valid
        : const AssetImage('assets/images/applogo.png'); // Fallback asset image

    return Container(
      // height: 150.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120.h,
              width: 80.w,
              decoration: BoxDecoration(
                color: Colors.yellow,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Raleway',
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    article.summary,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                      fontFamily: 'Raleway',
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 10.r,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        article.createdAt.split("T")[0], // Show only date
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Center(
                    child: CustomElevatedButton(
                      text: "Submit Comment",
                      onPressed: () {
                        Get.to(() => CommentScreen());
                      },
                      color: Colors.black,
                      borderRadius: 11.r,
                      height: 48.h,
                      width: 250.w,
                    ),
                  ),
                  SizedBox(height: 5.h),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

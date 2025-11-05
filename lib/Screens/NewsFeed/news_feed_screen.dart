import 'package:cosmose/Models/get_profile_model.dart';
import 'package:cosmose/Screens/NewsFeed/interesting_articles_details.dart';
import 'package:cosmose/Screens/NewsFeed/latest_post_details.dart';
import 'package:cosmose/controllers/news_feed_controller.dart';
import 'package:cosmose/controllers/user_controller.dart';
import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/services/get_profile_service.dart';
import 'package:cosmose/widgets/latest_post_shimmer_widget.dart';
import 'package:cosmose/widgets/news_feed_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NewsFeedScreen extends StatefulWidget {
  final LoginResponse loginResponse;

  const NewsFeedScreen({super.key, required this.loginResponse});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final NewsFeedController controller = Get.put(NewsFeedController());

  final UserController userController = Get.find<UserController>();

  GetProfile? profileData;
  bool isLoading = true;
  List<bool> favoriteStates = [];

  @override
  void initState() {
    super.initState();
    fetchProfileData();
    userController.setUserName(widget.loginResponse.user.name);
  }

  Future<void> fetchProfileData() async {
    UserService userService = UserService();
    profileData =
        await userService.fetchUserProfile(widget.loginResponse.token);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Text(
          "Social Media News Feed",
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Raleway'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    backgroundImage: profileData?.photo != null &&
                            profileData!.photo!['url'] != null
                        ? NetworkImage(profileData!.photo!['url'])
                            as ImageProvider
                        : const AssetImage("assets/images/buyer.png"),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    profileData?.name ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                "Latest Posts",
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway'),
              ),
              SizedBox(height: 5.h),
              Obx(() {
                if (controller.isLoading.value) {
                  return LatestPostShimmer();
                }

                // Ensure there are posts before displaying
                if (controller.latestPosts.isEmpty) {
                  return Center(child: Text('No posts available'));
                }

                // Initialize the favoriteStates list based on the number of posts
                if (favoriteStates.length != controller.latestPosts.length) {
                  favoriteStates = List.generate(
                      controller.latestPosts.length, (index) => false);
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.latestPosts.length,
                  itemBuilder: (context, index) {
                    var post = controller.latestPosts[index];

                    // Assuming you have commentCount and shareCount properties in the post object
                    int commentCount = 30; // Replace with actual value
                    int shareCount = 230; // Replace with actual value

                    return GestureDetector(
                      onTap: () {
                        Get.to(() => LatestPostDetails(post: post));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: NewsFeedCard(
                          title: post.title,
                          post: post.slug,
                          imageUrl: post.image,
                          avatarColor: Colors.orange,
                          onCommentTap: () {
                            print(" Comment Tap");
                          },
                          onShareTap: () {
                            print(" Share Tap");
                          },
                          commentCount: commentCount,
                          shareCount: shareCount,
                          isFavorite: favoriteStates[index],
                          onFavoriteTap: () {
                            setState(() {
                              favoriteStates[index] = !favoriteStates[index];
                            });
                            print("Title: ${post.title}");
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
              SizedBox(height: 15.h),
              Text(
                "Featured Products",
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway'),
              ),
              SizedBox(height: 5.h),
              Obx(() {
                if (controller.isLoading.value) {
                  return LatestPostShimmer();
                }

                if (controller.featuredProducts.isEmpty) {
                  return Center(
                    child: Text(
                      "Sorry, no Featured Products available",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  );
                }

                return SizedBox(
                  height: 252.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.featuredProducts.length,
                    itemBuilder: (context, index) {
                      var product = controller.featuredProducts[index];
                      return Row(
                        children: [
                          FeaturedProductCard(
                            title: product.title,
                            photoUrl: product.photo,
                            price: product.price,
                          ),
                          SizedBox(
                            width: 10.w,
                          )
                        ],
                      );
                    },
                  ),
                );
              }),

              SizedBox(
                height: 15.h,
              ),
              Text(
                "Customer Reviews",
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway'),
              ),
              SizedBox(height: 5.h),
              SizedBox(
                height: 106.h,
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return LatestPostShimmer();
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.latestReviews.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final review = controller.latestReviews[index];
                      return Row(
                        children: [
                          ReviewCard(
                            user: review.user,
                            product: review.product,
                            rating: review.rating,
                            comment: review.comment,
                            avatarColor: Colors.green,
                          ),
                          SizedBox(width: 10.w),
                        ],
                      );
                    },
                  );
                }),
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                "Trending Posts",
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway'),
              ),
              SizedBox(height: 5.h),
              Obx(() {
                if (controller.isLoading.value) {
                  return LatestPostShimmer();
                }
                return ListView.builder(
                  shrinkWrap: true, // ✅ Allows dynamic height
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: controller.trendingPosts.length,
                  itemBuilder: (context, index) {
                    var post = controller.trendingPosts[index];
                    return Column(
                      children: [
                        TrendingPostCard(
                          title: post.title,
                          imageUrl: post.image,
                          summary: post.summary,
                        ),
                        SizedBox(
                          height: 10.w,
                        )
                      ],
                    );
                  },
                );
              }),
              SizedBox(height: 15.h),
              // Add this below "Trending Posts" section in NewsFeedScreen
              SizedBox(height: 15.h),
              Text(
                "Interesting Articles",
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway'),
              ),
              SizedBox(height: 5.h),
              Obx(() {
                if (controller.isLoading.value) {
                  return LatestPostShimmer();
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.interestingArticles.length,
                  itemBuilder: (context, index) {
                    var article = controller.interestingArticles[index];
                    return Column(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Get.to(() => InterestingArticlesDetails(
                                    post: article,
                                  ));
                            },
                            child: InterestingArticleCard(article: article)),
                        SizedBox(height: 10.h),
                      ],
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

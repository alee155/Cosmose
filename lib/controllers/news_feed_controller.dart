import 'dart:convert';

import 'package:cosmose/Models/new_FeaturedProduct_model.dart';
import 'package:cosmose/Models/new_Interesting_Articles_model.dart';
import 'package:cosmose/Models/new_LatestPost_model.dart';
import 'package:cosmose/Models/new_LatestReview_model.dart';
import 'package:cosmose/Models/new_TrendingPost_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NewsFeedController extends GetxController {
  var latestPosts = <LatestPost>[].obs;
  var featuredProducts = <FeaturedProduct>[].obs;
  var trendingPosts = <TrendingPost>[].obs;
  var latestReviews = <LatestReview>[].obs;
  var interestingArticles = <InterestingArticle>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchNewsFeedData();
    super.onInit();
  }

  void fetchNewsFeedData() async {
    try {
      isLoading(true);
      var response =
          await http.get(Uri.parse("https://cosmoseworld.fr/api/home"));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // ✅ Pretty-print only interesting articles in the requested format
        print("============ INTERESTING ARTICLES ============");
        for (var article in jsonData['interesting_articles']) {
          print("""
        {
          "id": ${article['id']},
          "title": "${article['title']}",
          "slug": "${article['slug']}",
          "summary": "${article['summary']}",
          "image": "${article['image']}",
          "created_at": "${article['created_at']}"
        }
        """);
        }
        // ✅ Pretty-print the entire JSON response
        print("============ FULL API RESPONSE ============");
        print(const JsonEncoder.withIndent("  ").convert(jsonData));

        // ✅ Pretty-print only trending posts
        print("============ TRENDING POSTS ============");
        print(const JsonEncoder.withIndent("  ")
            .convert(jsonData['trending_posts']));

        latestPosts.value = (jsonData['latest_posts'] as List)
            .map((data) => LatestPost.fromJson(data))
            .toList();

        featuredProducts.value = (jsonData['featured_products'] as List)
            .map((data) => FeaturedProduct.fromJson(data))
            .toList();

        trendingPosts.value = (jsonData['trending_posts'] as List)
            .map((data) => TrendingPost.fromJson(data))
            .toList();

        latestReviews.value = (jsonData['latest_reviews'] as List)
            .map((data) => LatestReview.fromJson(data))
            .toList();

        interestingArticles.value = (jsonData['interesting_articles'] as List)
            .map((data) => InterestingArticle.fromJson(data))
            .toList();
      } else {
        print("❌ Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching data: $e");
    } finally {
      isLoading(false);
    }
  }
}

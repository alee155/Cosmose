import 'package:cosmose/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Comment {
  final String user;
  final String text;
  final String time;

  Comment({required this.user, required this.text, required this.time});
}

class CommentController extends GetxController {
  var comments = <Comment>[].obs;
  TextEditingController commentController = TextEditingController();

  void addComment(String user, String text) {
    if (text.isNotEmpty) {
      comments.add(Comment(
        user: user,
        text: text,
        time: "Just now",
      ));
      commentController.clear();
    }
  }
}

class CommentScreen extends StatelessWidget {
  final CommentController commentController = Get.put(CommentController());

  CommentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Comments"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: commentController.comments.length,
                  itemBuilder: (context, index) {
                    final comment = commentController.comments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(comment.user[0]),
                      ),
                      title: Text(comment.user,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment.text),
                          Text(comment.time,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    );
                  },
                )),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorColor: AppColors.green,
                    controller: commentController.commentController,
                    decoration: InputDecoration(
                      hintText: "Type your comment here...",
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Color(0xFFEFF1F5),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: AppColors.green,
                  ),
                  onPressed: () => commentController.addComment(
                      "User", commentController.commentController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

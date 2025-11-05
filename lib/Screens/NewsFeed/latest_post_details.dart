import 'package:cosmose/Models/new_LatestPost_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LatestPostDetails extends StatefulWidget {
  final LatestPost post;

  const LatestPostDetails({super.key, required this.post});

  @override
  State<LatestPostDetails> createState() => _LatestPostDetailsState();
}

class _LatestPostDetailsState extends State<LatestPostDetails> {
  // Extract only the date (YYYY-MM-DD) from "created_at"
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    formattedDate = widget.post.createdAt.split('T')[0];
  }

  // 📌 Show Full Image Dialog
  void _viewFullImage() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Stack(
            children: [
              Positioned.fill(
                child: InteractiveViewer(
                  child: Image.network(
                    widget.post.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Light background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "News Details",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Raleway',
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🖼️ News Image with "View Full Image" Icon
              Stack(
                children: [
                  Container(
                    height: 220.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                      image: widget.post.image.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(widget.post.image),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color:
                          widget.post.image.isEmpty ? Colors.grey[300] : null,
                    ),
                    child: widget.post.image.isEmpty
                        ? Icon(Icons.image_not_supported,
                            size: 50, color: Colors.grey)
                        : null,
                  ),

                  // 🔍 "View Full Image" Icon Button
                  if (widget.post.image.isNotEmpty)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: _viewFullImage,
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.fullscreen,
                              color: Colors.white, size: 24),
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 15.h),

              // 📅 Date with Icon
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 18, color: Colors.blueGrey),
                  SizedBox(width: 5.w),
                  Text(
                    "Published on: $formattedDate",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Raleway',
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15.h),

              // 📰 News Title
              Text(
                widget.post.title,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Raleway',
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: 10.h),

              // 📖 News Summary
              Text(
                widget.post.summary.isNotEmpty
                    ? widget.post.summary
                    : "No description available for this news.",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Raleway',
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

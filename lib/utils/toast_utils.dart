import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class ToastUtils {
  /// **Show Error Toast**
  static void showErrorToast(BuildContext context, String message) {
    MotionToast.error(
      description: Text(message),
      position: MotionToastPosition.bottom,
    ).show(context);
  }

  /// **Show Success Toast**
  static void showSuccessToast(BuildContext context, String message) {
    MotionToast.success(
      description: Text(message),
      position: MotionToastPosition.bottom,
    ).show(context);
  }
}

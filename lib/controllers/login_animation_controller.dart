import 'package:flutter/material.dart';

class LoginAnimationController extends ChangeNotifier {
  late AnimationController animationController;

  late Animation<double> logoFadeAnimation; // Fade animation for the logo
  late Animation<Offset> emailAnimation; // Slide animation for email field
  late Animation<Offset>
      passwordAnimation; // Slide animation for password field
  late Animation<Offset> buttonAnimation; // Slide animation for button

  LoginAnimationController(TickerProvider vsync) {
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1500),
    );

    // Logo fades in
    logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    ));

    // Email field slides in
    emailAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    ));

    // Password field slides in after email
    passwordAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
    ));

    // Button slides in last
    buttonAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    ));
  }

  void startAnimation() {
    animationController.forward();
  }

  void disposeController() {
    animationController.dispose();
  }
}

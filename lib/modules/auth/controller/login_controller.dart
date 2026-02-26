import 'package:fixmate/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Add your login controller code here
  final PageController controller = PageController();
  int index = 0;

  final phoneCtrl = TextEditingController();
  final otpCtrl = TextEditingController();

  final FocusNode otpFocus = FocusNode();

  void goToOtp(BuildContext context) {
    if (phoneCtrl.text.length == 10) {
      index = 1;
      update();

      controller.animateToPage(
        1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        FocusScope.of(context).requestFocus(otpFocus);
      });
    }
  }

  void verifyOtp() {
    if (otpCtrl.text.length == 4) {
      Get.snackbar("Success", "OTP Verified Successfully");
      Get.offAllNamed(AppRoutes.home);
    }
  }
}

import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';

class SplashController extends GetxController {
  /// Public method called from the UI to navigate forward.
  /// Keeps navigation logic out of the view.
  void goNext() {
    // small delay to allow animations to finish if needed
    Future.delayed(const Duration(milliseconds: 300), () {
      // replace with your target route
      Get.offAllNamed(AppRoutes.home);
    });
  }

  @override
  void onClose() {
    // cancel any timers / subscriptions here if you add them later
    super.onClose();
  }
}

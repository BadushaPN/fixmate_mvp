import 'package:get/get.dart';
import 'controller/request_controller.dart';

class RequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RequestController());
  }
}

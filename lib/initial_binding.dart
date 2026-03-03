import 'package:get/get.dart';
import '../modules/request/controller/request_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RequestController(), permanent: true);
  }
}

import 'package:fixmate/modules/addComplaint/controller/add_complaint_controller.dart';
import 'package:get/get.dart';

class AddComplaintBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddComplaintController());
  }
}

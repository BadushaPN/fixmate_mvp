import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum RequestStatus { none, waiting, accepted, cancelled }

class RequestController extends GetxController {
  final box = GetStorage();

  final Rx<RequestStatus> status = RequestStatus.none.obs;
  final RxString requestId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _restoreState();
  }

  void startRequest(String id) {
    requestId.value = id;
    status.value = RequestStatus.waiting;

    box.write('requestId', id);
    box.write('requestStatus', 'waiting');
  }

  void cancelRequest(String reason) {
    status.value = RequestStatus.cancelled;
    box.remove('requestId');
    box.remove('requestStatus');

    // TODO: API call with reason
  }

  void technicianAccepted() {
    status.value = RequestStatus.accepted;
    box.write('requestStatus', 'accepted');
  }

  void _restoreState() {
    final savedStatus = box.read('requestStatus');
    final savedId = box.read('requestId');

    if (savedStatus == 'waiting' && savedId != null) {
      requestId.value = savedId;
      status.value = RequestStatus.waiting;
    }
  }
}

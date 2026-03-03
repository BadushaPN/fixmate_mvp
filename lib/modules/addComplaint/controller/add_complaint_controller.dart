import 'dart:io';
import 'package:fixmate/modules/request/controller/request_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class AddComplaintController extends GetxController {
  final descriptionController = TextEditingController();

  final Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  void pickFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  void pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  void submitComplaint() {
    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter complaint description",
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    if (selectedImage.value == null) {
      Get.snackbar(
        "Error",
        "Please add a photo",
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    // TODO: API call / Firebase upload
    // descriptionController.text
    // selectedImage.value

    Get.snackbar(
      "Success",
      "Complaint submitted successfully",
      backgroundColor: Colors.green.shade100,
    );
    final requestController = Get.find<RequestController>();

    requestController.startRequest(
      "REQ_${DateTime.now().millisecondsSinceEpoch}",
    );

    Get.offNamed('/request-active');

    descriptionController.clear();
    selectedImage.value = null;
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}

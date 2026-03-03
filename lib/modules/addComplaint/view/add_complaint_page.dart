import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixmate/modules/addComplaint/controller/add_complaint_controller.dart';
import '../../../core/constants/app_colors.dart';

class AddComplaintPage extends GetView<AddComplaintController> {
  const AddComplaintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBackgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.brandBackgroundLight,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Raise a Complaint",
          style: TextStyle(
            color: AppColors.brandPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.brandPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Describe the issue"),
            const SizedBox(height: 8),
            _descriptionField(),

            const SizedBox(height: 28),

            _sectionTitle("Add a photo (optional)"),
            const SizedBox(height: 8),
            _photoPicker(),

            const SizedBox(height: 36),

            _submitButton(),
          ],
        ),
      ),
    );
  }

  // ================= TEXT =================

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.brandTextDark,
      ),
    );
  }

  Widget _descriptionField() {
    return TextField(
      controller: controller.descriptionController,
      maxLines: 5,
      style: const TextStyle(color: AppColors.brandTextDark),
      decoration: InputDecoration(
        hintText: "Explain the problem clearly...",
        hintStyle: const TextStyle(color: AppColors.brandTextSubtle),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ================= PHOTO =================

  Widget _photoPicker() {
    return Obx(() {
      final File? image = controller.selectedImage.value;

      return Column(
        children: [
          GestureDetector(
            onTap: controller.pickFromGallery,
            child: Container(
              height: 170,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.brandBorder),
              ),
              child: image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(
                        image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 32,
                          color: AppColors.brandSecondary,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Tap to upload a photo",
                          style: TextStyle(color: AppColors.brandTextSubtle),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _photoAction(
                  icon: Icons.camera_alt,
                  label: "Camera",
                  onTap: controller.pickFromCamera,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _photoAction(
                  icon: Icons.photo_library,
                  label: "Gallery",
                  onTap: controller.pickFromGallery,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _photoAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: AppColors.brandPrimary),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.brandPrimary,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.brandBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  // ================= SUBMIT =================

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: controller.submitComplaint,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          "Submit Complaint",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

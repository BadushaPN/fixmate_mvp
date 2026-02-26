import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixmate/modules/request/controller/request_controller.dart';
import 'package:fixmate/modules/request/widgets/cancel_reason_sheet.dart';
import '../../../core/constants/app_colors.dart';

class RequestActivePage extends GetView<RequestController> {
  const RequestActivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBackgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.brandBackgroundLight,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Finding Technician",
          style: TextStyle(
            color: AppColors.brandPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.brandPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _statusCard(),
            const SizedBox(height: 40),
            _cancelButton(context),
          ],
        ),
      ),
    );
  }

  // ================= STATUS CARD =================

  Widget _statusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: AppColors.brandShadowLight,
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Branded loader
          const SizedBox(
            height: 48,
            width: 48,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation(AppColors.brandHighlight),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Searching for nearby technicians",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.brandPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "This usually takes less than a minute.\nPlease stay on this screen.",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.brandTextSubtle,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ================= CANCEL =================

  Widget _cancelButton(BuildContext context) {
    return TextButton(
      onPressed: () => _showCancelSheet(context),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.error,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: const Text(
        "Cancel Request",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  void _showCancelSheet(BuildContext context) {
    Get.bottomSheet(
      const CancelReasonSheet(),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }
}

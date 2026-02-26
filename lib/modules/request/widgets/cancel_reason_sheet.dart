import 'package:fixmate/modules/request/controller/request_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancelReasonSheet extends StatefulWidget {
  const CancelReasonSheet({super.key});

  @override
  State<CancelReasonSheet> createState() => _CancelReasonSheetState();
}

class _CancelReasonSheetState extends State<CancelReasonSheet> {
  String? selectedReason;
  final commentController = TextEditingController();

  final reasons = [
    "Booked by mistake",
    "Technician taking too long",
    "Issue resolved",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Cancel Reason",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          ...reasons.map(
            (r) => RadioListTile(
              title: Text(r),
              value: r,
              groupValue: selectedReason,
              onChanged: (v) => setState(() => selectedReason = v),
            ),
          ),

          if (selectedReason == "Other")
            TextField(
              controller: commentController,
              decoration: const InputDecoration(hintText: "Enter reason"),
            ),

          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _submitCancel,
            child: const Text("Confirm Cancel"),
          ),
        ],
      ),
    );
  }

  void _submitCancel() {
    if (selectedReason == null) {
      Get.snackbar("Error", "Select a reason");
      return;
    }

    if (selectedReason == "Other" && commentController.text.trim().isEmpty) {
      Get.snackbar("Error", "Comment is required");
      return;
    }

    final controller = Get.find<RequestController>();
    controller.cancelRequest(
      selectedReason == "Other" ? commentController.text : selectedReason!,
    );

    Get.back(); // close sheet
    Get.offAllNamed('/home');
  }
}

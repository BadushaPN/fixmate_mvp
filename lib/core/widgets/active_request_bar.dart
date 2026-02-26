import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../modules/request/controller/request_controller.dart';

class ActiveRequestBar extends StatelessWidget {
  const ActiveRequestBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RequestController>();

    return Obx(() {
      if (controller.status.value != RequestStatus.waiting) {
        return const SizedBox.shrink();
      }

      return Positioned(
        bottom: 16,
        left: 16,
        right: 16,
        child: GestureDetector(
          onTap: () => Get.toNamed('/request-active'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              children: const [
                SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Request active · Waiting for technician",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

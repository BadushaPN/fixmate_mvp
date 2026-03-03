import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/home_controller.dart';

class LocationHeader extends GetView<HomeController> {
  const LocationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [AppColors.brandAccent, AppColors.brandPrimary],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandShadowLight,
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: _content(),
      );
    });
  }

  Widget _content() {
    if (controller.isLoading.value) {
      return _loading();
    }

    if (controller.error.isNotEmpty) {
      return _error();
    }

    return _address();
  }

  Widget _loading() {
    return Row(
      children: const [
        Icon(Icons.location_searching, color: Colors.white),
        SizedBox(width: 10),
        Text(
          "Fetching your location...",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _error() {
    return Row(
      children: const [
        Icon(Icons.location_off, color: Colors.white),
        SizedBox(width: 10),
        Text("Location unavailable", style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _address() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.location_pin, color: Colors.white, size: 20),
            SizedBox(width: 6),
            Text(
              "Your Location",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          controller.address.value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

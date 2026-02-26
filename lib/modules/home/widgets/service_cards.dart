import 'package:fixmate/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:fixmate/core/constants/app_colors.dart';
import 'package:get/get.dart';

class ServiceCards extends StatelessWidget {
  const ServiceCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to Electrician Service Page
              Get.toNamed(AppRoutes.addComplaint);
            },
            child: _serviceCard("Electrician", Icons.electrical_services),
          ),
          const SizedBox(width: 14),
          _serviceCard("Plumber", Icons.plumbing),
        ],
      ),
    );
  }

  Widget _serviceCard(String title, IconData icon) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 34, color: AppColors.brandSecondary),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.brandBackgroundDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

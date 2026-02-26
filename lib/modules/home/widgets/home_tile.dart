import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixmate/core/constants/app_colors.dart';

class HomeTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? route;
  final bool enabled;

  const HomeTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.route,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: enabled && route != null ? () => Get.toNamed(route!) : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : AppColors.brandBackgroundLight,
          borderRadius: BorderRadius.circular(16),
          border: enabled ? null : Border.all(color: AppColors.brandBorder),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.shadowSoft.withValues(alpha: 0.08),
                    blurRadius: 8,
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: enabled
                      ? AppColors.brandPrimary
                      : AppColors.brandTextSubtle,
                ),
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: enabled
                        ? AppColors.brandTextDark
                        : AppColors.brandTextSubtle,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.brandTextSubtle,
                  ),
                ),
              ],
            ),

            // 🔒 Coming Soon badge
            if (!enabled)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brandSecondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Soon",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

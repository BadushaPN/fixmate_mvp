import 'package:fixmate/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class OnboardData {
  final String title;
  final String subtitle;

  OnboardData({required this.title, required this.subtitle});
}

class OnboardingSlide extends StatelessWidget {
  final OnboardData data;

  const OnboardingSlide({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Card(
        shadowColor: AppColors.brandBackgroundLight,
        color: AppColors.brandAccent,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 120),
              Text(
                data.title,
                style: const TextStyle(
                  fontSize: 32,
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                data.subtitle,
                style: const TextStyle(
                  fontSize: 17,
                  color: AppColors.textLight,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

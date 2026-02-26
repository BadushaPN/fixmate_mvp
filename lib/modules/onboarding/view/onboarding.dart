import 'package:fixmate/modules/onboarding/widgets/onboarding_card.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _controller = PageController();
  int currentPage = 0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<OnboardData> pages = [
    OnboardData(
      title: "Fast Home Services",
      subtitle: "Electricians, plumbers & cleaners anytime you need.",
    ),
    OnboardData(
      title: "Verified Technicians",
      subtitle: "We ensure quality, safety and professionalism.",
    ),
    OnboardData(
      title: "Track & Relax",
      subtitle: "Live updates, secure payments and trusted work.",
    ),
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void goNext() {
    if (currentPage == pages.length - 1) {
      Get.offAllNamed(AppRoutes.login);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myWhite,
      body: SafeArea(
        child: Stack(
          children: [
            // ---------------- PAGE VIEW ----------------
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) {
                  setState(() => currentPage = i);
                  _fadeController.forward(from: 0);
                },
                itemBuilder: (_, i) => FadeTransition(
                  opacity: _fadeAnimation,
                  child: OnboardingSlide(data: pages[i]),
                ),
              ),
            ),

            // ---------------- PAGE DOTS (BOTTOM-LEFT) ----------------
            Positioned(
              left: 24,
              bottom: 32,
              child: Row(
                children: List.generate(
                  pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 6),
                    height: 10,
                    width: currentPage == i ? 22 : 10,
                    decoration: BoxDecoration(
                      color: currentPage == i
                          ? AppColors.dotActive
                          : AppColors.dotInactive,
                      borderRadius: BorderRadius.circular(20),
                      gradient: currentPage == i
                          ? LinearGradient(
                              colors: [
                                AppColors.brandSecondary,
                                AppColors.brandHighlight,
                              ],
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),

            // ---------------- FORWARD BUTTON (BOTTOM-RIGHT) ----------------
            Positioned(
              right: 24,
              bottom: 20,
              child: GestureDetector(
                onTap: goNext,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.brandSecondary,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brandSecondary.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 24,
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

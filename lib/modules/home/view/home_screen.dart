import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/active_request_bar.dart';
import '../controller/home_controller.dart';
import '../widgets/location_header.dart';
import '../widgets/home_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.brandBackgroundLight,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topBar(),
                  const SizedBox(height: 14),
                  const LocationHeader(),
                  const SizedBox(height: 22),
                  _dashboard(),
                ],
              ),
            ),
          ),
          const ActiveRequestBar(),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, Welcome",
                style: GoogleFonts.sora(
                  fontSize: 14,
                  color: AppColors.brandTextSubtle,
                ),
              ),
              Text(
                "Home",
                style: GoogleFonts.sora(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.brandPrimary,
                ),
              ),
            ],
          ),
        ),
        _icon(Icons.notifications_none, '/notifications'),
        _icon(Icons.person_outline, '/profile'),
      ],
    );
  }

  Widget _icon(IconData icon, String route) {
    return IconButton(
      icon: Icon(icon),
      color: AppColors.brandPrimary,
      onPressed: () => Get.toNamed(route),
    );
  }

  Widget _dashboard() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.05,
        children: const [
          // ✅ ACTIVE
          HomeTile(
            title: "Book Service",
            subtitle: "Plumber, Electrician",
            icon: Icons.build,
            route: '/add-complaint',
            enabled: true,
          ),
          HomeTile(
            title: "My Requests",
            subtitle: "Active & past",
            icon: Icons.assignment,
            route: '/tasks',
            enabled: true,
          ),

          // ⛔ COMING SOON
          HomeTile(
            title: "Services",
            subtitle: "All categories",
            icon: Icons.grid_view,
            enabled: false,
          ),
          HomeTile(
            title: "Support",
            subtitle: "Help & FAQ",
            icon: Icons.support_agent,
            enabled: false,
          ),
          HomeTile(
            title: "Location",
            subtitle: "Saved places",
            icon: Icons.location_on,
            enabled: false,
          ),
          HomeTile(
            title: "Settings",
            subtitle: "Profile & app",
            icon: Icons.settings,
            enabled: false,
          ),
        ],
      ),
    );
  }
}

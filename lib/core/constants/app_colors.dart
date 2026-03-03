import 'package:flutter/material.dart';

class AppColors {
  // ===============================
  // BRAND COLORS (Blue system)
  // ===============================

  /// Primary brand blue (trust, core actions)
  static const Color brandPrimary = Color(0xFF0D47A1); // Deep Blue

  /// Secondary blue (accents, highlights)
  static const Color brandSecondary = Color(0xFF42A5F5); // Sky Blue

  /// Accent blue (cards, headers, gradients)
  static const Color brandAccent = Color(0xFF1565C0); // Medium Blue

  /// Soft highlight (chips, subtle emphasis)
  static const Color brandHighlight = Color(0xFF90CAF9); // Light Blue

  // ===============================
  // BACKGROUNDS
  // ===============================

  /// Main app background
  static const Color brandBackgroundLight = Color(0xFFF9FBFF); // Near-white

  /// Dark mode background
  static const Color brandBackgroundDark = Color(0xFF0B1220); // Navy-black

  // ===============================
  // SURFACES / CARDS
  // ===============================

  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color darkCard = Color(0xFF121A2F);

  // ===============================
  // TEXT COLORS
  // ===============================

  static const Color textLight = Colors.white;
  static const Color textMutedLight = Color(0xFFB0BEC5);

  static const Color brandTextDark = Color(0xFF1F2933); // Primary text
  static const Color brandTextSubtle = Color(0xFF6B7280); // Secondary text

  // ===============================
  // BORDERS & SHADOWS
  // ===============================

  static const Color brandBorder = Color(0xFFE2E8F0); // Light grey-blue

  static const Color shadowSoft = Color.fromRGBO(
    13,
    71,
    161,
    0.12,
  ); // Blue shadow

  static const Color brandShadowLight = Color.fromRGBO(13, 71, 161, 0.06);

  // ===============================
  // PAGE INDICATORS
  // ===============================

  static const Color dotActive = brandPrimary;
  static const Color dotInactive = Color(0xFFCBD5E1);

  // ===============================
  // SYSTEM / STATUS COLORS
  // ===============================

  // Waiting / in progress
  static const Color requestWaiting = Color(0xFF1E88E5);
  static const Color requestWaitingBg = Color(0xFFE3F2FD);

  // Success
  static const Color success = Color(0xFF2E7D32);
  static const Color successBg = Color(0xFFE6F4EA);

  // Error
  static const Color error = Color(0xFFD32F2F);
  static const Color errorBg = Color(0xFFFDECEA);

  // Info
  static const Color info = Color(0xFF1976D2);
  static const Color infoBg = Color(0xFFE3F2FD);

  // ===============================
  // LEGACY / COMPAT
  // ===============================

  static const Color myBlue = brandPrimary;
  static const Color myWhite = Colors.white;
}

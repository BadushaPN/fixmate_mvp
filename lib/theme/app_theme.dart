import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF0E5BFF);
  static const Color secondary = Color(0xFF17C7A5);
  static const Color accent = Color(0xFFFF7A59);
  static const Color deep = Color(0xFF0B1330);
  static const Color ink = Color(0xFF111633);
  static const Color subtext = Color(0xFF5A6285);
  static const Color softBlue = Color(0xFFE8EEFF);
  static const Color stroke = Color(0xFFDCE4FF);
  static const Color card = Colors.white;

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color inkFor(BuildContext context) =>
      isDark(context) ? const Color(0xFFEAF0FF) : const Color(0xFF111633);
  static Color subtextFor(BuildContext context) =>
      isDark(context) ? const Color(0xFF95A2C7) : const Color(0xFF5A6285);
  static Color cardFor(BuildContext context) =>
      isDark(context) ? const Color(0xFF181F33) : Colors.white;
  static Color softBlueFor(BuildContext context) =>
      isDark(context) ? const Color(0xFF1E2B4D) : const Color(0xFFE8EEFF);
  static Color strokeFor(BuildContext context) =>
      isDark(context) ? const Color(0xFF2C3858) : const Color(0xFFDCE4FF);
}

class AppGradients {
  static Gradient backgroundFor(BuildContext context) {
    if (AppColors.isDark(context)) {
      return const LinearGradient(
        colors: [Color(0xFF0E1220), Color(0xFF111A2E), Color(0xFF171C2B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return const LinearGradient(
      colors: [Color(0xFFEDF2FF), Color(0xFFE8FAF7), Color(0xFFFFF3ED)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

class AppRadii {
  static const double md = 16;
}

class AppShadows {
  static List<BoxShadow> card(BuildContext context) => [
    BoxShadow(
      color: Colors.black.withValues(alpha: AppColors.isDark(context) ? 0.35 : 0.08),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}

class AppTheme {
  static TextStyle heroHeadline(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
      height: 1.1,
    );
  }

  static ThemeData light(BuildContext context) => _build(context, Brightness.light);
  static ThemeData dark(BuildContext context) => _build(context, Brightness.dark);

  static ThemeData _build(BuildContext context, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final base = ThemeData(brightness: brightness).textTheme;
    final ink = isDark ? const Color(0xFFEAF0FF) : const Color(0xFF111633);
    final subtext = isDark ? const Color(0xFF95A2C7) : const Color(0xFF5A6285);
    final background = isDark ? const Color(0xFF0F1423) : const Color(0xFFF5F7FF);
    final card = isDark ? const Color(0xFF181F33) : Colors.white;
    final stroke = isDark ? const Color(0xFF2C3858) : const Color(0xFFDCE4FF);
    final softBlue = isDark ? const Color(0xFF1E2B4D) : const Color(0xFFE8EEFF);

    final textTheme = GoogleFonts.dmSansTextTheme(base).copyWith(
      headlineLarge: GoogleFonts.outfit(fontSize: 34, fontWeight: FontWeight.w700, color: ink),
      headlineMedium: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w700, color: ink),
      headlineSmall: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: ink),
    );

    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: background,
      ),
      textTheme: textTheme.apply(bodyColor: ink, displayColor: ink),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: ink,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        hintStyle: textTheme.bodyMedium?.copyWith(color: subtext),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: BorderSide(color: stroke),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppColors.primary : AppColors.deep,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
          elevation: 0,
          textStyle: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          side: BorderSide(color: stroke),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        selectedColor: softBlue,
        side: BorderSide(color: stroke),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? const Color(0xFF1F2A44) : const Color(0xFF1B243D),
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}

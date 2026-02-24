import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF2559A7);
  static const Color secondary = Color(0xFF3E8B84);
  static const Color accent = Color(0xFFE08163);
  static const Color deep = Color(0xFF1D2C45);
  static const Color ink = Color(0xFF1A2436);
  static const Color subtext = Color(0xFF607089);
  static const Color softBlue = Color(0xFFEAF0FA);
  static const Color stroke = Color(0xFFD3DEED);
  static const Color card = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF4F7FB);

  static Color inkFor(BuildContext context) => ink;
  static Color subtextFor(BuildContext context) => subtext;
  static Color cardFor(BuildContext context) => card;
  static Color softBlueFor(BuildContext context) => softBlue;
  static Color strokeFor(BuildContext context) => stroke;
}

class AppGradients {
  static Gradient backgroundFor(BuildContext context) {
    return const LinearGradient(
      colors: [Color(0xFFF7FAFF), Color(0xFFF3F8F6), Color(0xFFFFF8F3)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

class AppRadii {
  static const double sm = 8;
  static const double md = 16;
}

class AppShadows {
  static List<BoxShadow> card(BuildContext context) => [
    BoxShadow(
      color: AppColors.deep.withValues(alpha: 0.08),
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

  static ThemeData light(BuildContext context) {
    final base = ThemeData(brightness: Brightness.light).textTheme;
    final ink = AppColors.ink;
    final subtext = AppColors.subtext;
    final background = AppColors.surface;
    final card = AppColors.card;
    final stroke = AppColors.stroke;
    final softBlue = AppColors.softBlue;

    final textTheme = GoogleFonts.dmSansTextTheme(base).copyWith(
      headlineLarge: GoogleFonts.outfit(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
    );

    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
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
          backgroundColor: AppColors.deep,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
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
        backgroundColor: const Color(0xFF1B243D),
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}

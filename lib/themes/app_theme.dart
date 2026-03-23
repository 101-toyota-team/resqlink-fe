import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const tealDeep    = Color(0xFF0F5C63);
  static const teal        = Color(0xFF1A7F87);
  static const tealMuted   = Color(0xFF5FA8AE);
  static const tealSoft    = Color(0xFFEAF5F6);
  static const tealBorder  = Color(0xFFC7E8EB);

  static const orange      = Color(0xFFE07B3A);
  static const orangeBorder = Color(0x59E07B3A);

  static const surface     = Color(0xFFFFFFFF);
  static const bg          = Color(0xFFF2F2F7);
  static const fill        = Color(0xFFF2F2F7);
  static const sep         = Color(0xFFE5E5EA);

  static const text        = Color(0xFF1C1C1E);
  static const text2       = Color(0xFF636366);
  static const text3       = Color(0xFFAEAEB2);

  static const red         = Color(0xFFFF3B30);
  static const redSoft     = Color(0xFFFFF5F5);
  static const redBorder   = Color(0xFFFFCCCB);

  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [tealDeep, teal],
    stops: [0.0, 1.0],
  );
}

class AppTheme {
  AppTheme._();

  // Plus Jakarta Sans — clean, rounded, modern, very close to SF Pro feel
  static TextTheme get _textTheme => GoogleFonts.plusJakartaSansTextTheme().copyWith(
    displayLarge: GoogleFonts.plusJakartaSans(
      fontSize: 34, fontWeight: FontWeight.w700,
      color: AppColors.text, letterSpacing: -0.8, height: 1.12,
    ),
    displayMedium: GoogleFonts.plusJakartaSans(
      fontSize: 28, fontWeight: FontWeight.w700,
      color: AppColors.text, letterSpacing: -0.6, height: 1.15,
    ),
    headlineLarge: GoogleFonts.plusJakartaSans(
      fontSize: 24, fontWeight: FontWeight.w600,
      color: AppColors.text, letterSpacing: -0.5,
    ),
    headlineMedium: GoogleFonts.plusJakartaSans(
      fontSize: 20, fontWeight: FontWeight.w600,
      color: AppColors.text, letterSpacing: -0.4,
    ),
    titleLarge: GoogleFonts.plusJakartaSans(
      fontSize: 17, fontWeight: FontWeight.w600,
      color: AppColors.text, letterSpacing: -0.3,
    ),
    titleMedium: GoogleFonts.plusJakartaSans(
      fontSize: 15, fontWeight: FontWeight.w500,
      color: AppColors.text, letterSpacing: -0.2,
    ),
    bodyLarge: GoogleFonts.plusJakartaSans(
      fontSize: 16, fontWeight: FontWeight.w400,
      color: AppColors.text, letterSpacing: -0.2, height: 1.5,
    ),
    bodyMedium: GoogleFonts.plusJakartaSans(
      fontSize: 14, fontWeight: FontWeight.w400,
      color: AppColors.text2, letterSpacing: -0.1, height: 1.5,
    ),
    bodySmall: GoogleFonts.plusJakartaSans(
      fontSize: 12, fontWeight: FontWeight.w400,
      color: AppColors.text3, letterSpacing: 0,
    ),
    labelLarge: GoogleFonts.plusJakartaSans(
      fontSize: 16, fontWeight: FontWeight.w600,
      color: AppColors.surface, letterSpacing: -0.2,
    ),
    labelMedium: GoogleFonts.plusJakartaSans(
      fontSize: 13, fontWeight: FontWeight.w500,
      color: AppColors.text2, letterSpacing: -0.1,
    ),
    labelSmall: GoogleFonts.plusJakartaSans(
      fontSize: 11, fontWeight: FontWeight.w500,
      color: AppColors.text3, letterSpacing: 0.2,
    ),
  );

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.teal,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.bg,
      textTheme: _textTheme,
      // Apply font globally — no fontFamily string needed
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: AppColors.surface),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 17, fontWeight: FontWeight.w600,
          color: AppColors.surface, letterSpacing: -0.3,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -0.2,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: GoogleFonts.plusJakartaSans(
          fontSize: 16, fontWeight: FontWeight.w400,
          color: AppColors.text3, letterSpacing: -0.2,
        ),
      ),
    );
  }
}

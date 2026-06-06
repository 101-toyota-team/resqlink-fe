import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Main Theme Configuration for ResQLink
class AppTheme {
  AppTheme._();

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────
// Legacy aliases for backwards compatibility
// ─────────────────────────────────────────────────────────────────────────

class C {
  C._();

  // Primary
  static const bg = AppColors.darkBrown;
  static const bgCard = AppColors.cardBg;
  static const bgSheet = AppColors.white;
  static const teal900 = Color(0xFF0A3A3E);
  static const teal700 = AppColors.primary;
  static const teal500 = AppColors.primary;
  static const teal300 = AppColors.primaryLight;
  static const teal100 = AppColors.primaryLight;
  static const tealGlow = Color(0x33B5351A); // primary with opacity

  // Accent
  static const amber = AppColors.amber;
  static const amberSoft = Color(0x33C8821A); // amber with opacity
  static const amberBorder = AppColors.divider;

  // Neutrals
  static const ink = AppColors.textDark;
  static const ink2 = AppColors.textGrey;
  static const ink3 = AppColors.textGrey;
  static const ghost = AppColors.white;
  static const ghostBorder = AppColors.divider;
  static const white = AppColors.white;
  static const white60 = Color(0x99FFFFFF);
  static const white20 = Color(0x33FFFFFF);
  static const white08 = Color(0x14FFFFFF);

  // Semantic
  static const red = AppColors.primary;
  static const redSoft = Color(0x1AB5351A);
  static const redBorder = AppColors.primaryLight;
  static const green = AppColors.ambulanceJenazah;

  // Gradients
  static const heroGrad = AppColors.gradient;
  static const cardGrad = AppColors.gradient2;
}

class T {
  T._();

  static TextStyle h1 = AppTypography.h1;
  static TextStyle h2 = AppTypography.h2;
  static TextStyle h3 = AppTypography.h3;
  static TextStyle title = AppTypography.title;
  static TextStyle body = AppTypography.body;
  static TextStyle bodyWhite = AppTypography.bodyWhite;
  static TextStyle label = AppTypography.label;
  static TextStyle caption = AppTypography.caption;
  static TextStyle btn = AppTypography.button;
  static TextStyle btnSm = AppTypography.buttonSmall;

  static TextStyle c(TextStyle s, Color col) => s.copyWith(color: col);
}


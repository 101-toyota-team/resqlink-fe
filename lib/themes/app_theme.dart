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
        scaffoldBackgroundColor: AppColors.bgLight,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
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
  static const bg = AppColors.bgDarkest;
  static const bgCard = AppColors.bgDark;
  static const bgSheet = AppColors.bgLight;
  static const teal900 = Color(0xFF0A3A3E);
  static const teal700 = AppColors.primaryDark;
  static const teal500 = AppColors.primary;
  static const teal300 = AppColors.primaryLight;
  static const teal100 = AppColors.primaryLighter;
  static const tealGlow = AppColors.primaryGlow;

  // Accent
  static const amber = AppColors.accent;
  static const amberSoft = AppColors.accentSoft;
  static const amberBorder = AppColors.accentBorder;

  // Neutrals
  static const ink = AppColors.textPrimary;
  static const ink2 = AppColors.textSecondary;
  static const ink3 = AppColors.textTertiary;
  static const ghost = AppColors.bgLighter;
  static const ghostBorder = AppColors.border;
  static const white = AppColors.white;
  static const white60 = AppColors.white60;
  static const white20 = AppColors.white20;
  static const white08 = AppColors.white08;

  // Semantic
  static const red = AppColors.error;
  static const redSoft = AppColors.errorSoft;
  static const redBorder = AppColors.errorBorder;
  static const green = AppColors.success;

  // Gradients
  static const heroGrad = AppColors.heroGradient;
  static const cardGrad = AppColors.cardGradient;
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


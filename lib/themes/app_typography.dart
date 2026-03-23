import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography - Plus Jakarta Sans with consistent sizing and spacing
class AppTypography {
  AppTypography._();

  // ─────────────────────────────────────────
  // Heading Styles
  // ─────────────────────────────────────────
  static TextStyle get h1 => GoogleFonts.plusJakartaSans(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: AppColors.white,
        letterSpacing: -1.2,
        height: 1.1,
      );

  static TextStyle get h2 => GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
        letterSpacing: -0.8,
        height: 1.15,
      );

  static TextStyle get h3 => GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.6,
        height: 1.2,
      );

  // ─────────────────────────────────────────
  // Descriptive Styles
  // ─────────────────────────────────────────
  static TextStyle get title => GoogleFonts.plusJakartaSans(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.4,
      );

  static TextStyle get body => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        letterSpacing: -0.2,
        height: 1.55,
      );

  static TextStyle get bodyWhite => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.white60,
        letterSpacing: -0.2,
        height: 1.55,
      );

  // ─────────────────────────────────────────
  // Button Styles
  // ─────────────────────────────────────────
  static TextStyle get button => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
        letterSpacing: -0.3,
      );

  static TextStyle get buttonSmall => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
        letterSpacing: -0.2,
      );

  // ─────────────────────────────────────────
  // Label & Caption Styles
  // ─────────────────────────────────────────
  static TextStyle get label => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.1,
      );

  static TextStyle get caption => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
        letterSpacing: 0,
      );

  static TextStyle get captionSmall => GoogleFonts.plusJakartaSans(
        fontSize: 11.5,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
        letterSpacing: 0,
      );

  // ─────────────────────────────────────────
  // Utility method for dynamic color
  // ─────────────────────────────────────────
  static TextStyle withColor(TextStyle style, Color color) =>
      style.copyWith(color: color);
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography - Plus Jakarta Sans for a modern and clean look
class AppTypography {
  AppTypography._();

  // ─────────────────────────────────────────
  // Heading Styles
  // ─────────────────────────────────────────
  static TextStyle get h1 => GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
        letterSpacing: -1.0,
        height: 1.2,
      );

  static TextStyle get h2 => GoogleFonts.plusJakartaSans(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
        letterSpacing: -0.6,
        height: 1.2,
      );

  static TextStyle get h3 => GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
        letterSpacing: -0.4,
        height: 1.3,
      );

  // ─────────────────────────────────────────
  // Descriptive Styles
  // ─────────────────────────────────────────
  static TextStyle get title => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
        letterSpacing: -0.2,
      );

  static TextStyle get body => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textGrey,
        letterSpacing: 0,
        height: 1.5,
      );

  static TextStyle get bodyWhite => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.white.withOpacity(0.8),
        letterSpacing: 0,
        height: 1.5,
      );

  // ─────────────────────────────────────────
  // Button Styles
  // ─────────────────────────────────────────
  static TextStyle get button => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
        letterSpacing: 0.2,
      );

  static TextStyle get buttonSmall => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
        letterSpacing: 0.1,
      );

  // ─────────────────────────────────────────
  // Label & Caption Styles
  // ─────────────────────────────────────────
  static TextStyle get label => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textGrey,
        letterSpacing: 0.2,
      );

  static TextStyle get caption => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textGrey,
        letterSpacing: 0,
      );

  static TextStyle get captionSmall => GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.textGrey,
        letterSpacing: 0,
      );

  // ─────────────────────────────────────────
  // Utility method for dynamic color
  // ─────────────────────────────────────────
  static TextStyle withColor(TextStyle style, Color color) =>
      style.copyWith(color: color);
}

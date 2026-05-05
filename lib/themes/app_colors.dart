import 'package:flutter/material.dart';

/// Color Palette — deep teal dark theme with warm amber accent
class AppColors {
  AppColors._();

  // ─────────────────────────────────────────
  // Primary Palette — Deep Teal
  // ─────────────────────────────────────────
  static const Color primary = Color(0xFF1A7F87);
  static const Color primaryDark = Color(0xFF0A3A3E);
  static const Color primaryDarker = Color(0xFF061A1C);
  static const Color primaryLight = Color(0xFF3BA8B0);
  static const Color primaryLighter = Color(0xFFB8E8EC);
  static const Color primaryGlow = Color(0x331A7F87);

  // Background primitives
  static const Color bgDarkest = Color(0xFF061A1C);
  static const Color bgDark = Color(0xFF0C2628);
  static const Color bgLight = Color(0xFFFFFFFF);
  static const Color bgLighter = Color(0xFFF0F6F7);

  // ─────────────────────────────────────────
  // Accent — Warm Amber
  // ─────────────────────────────────────────
  static const Color accent = Color(0xFFE07B3A);
  static const Color accentSoft = Color(0x1AE07B3A);
  static const Color accentBorder = Color(0x40E07B3A);

  // ─────────────────────────────────────────
  // Semantic Colors
  // ─────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color errorSoft = Color(0x0FEF4444);
  static const Color errorBorder = Color(0x40EF4444);

  // ─────────────────────────────────────────
  // Neutral — Text & Backgrounds
  // ─────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0D1F21);
  static const Color textSecondary = Color(0xFF3D5558);
  static const Color textTertiary = Color(0xFF8AADB0);
  static const Color textHint = Color(0xFF8AADB0);

  static const Color white = Color(0xFFFFFFFF);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white08 = Color(0x14FFFFFF);

  static const Color border = Color(0xFFE0EBED);

  // ─────────────────────────────────────────
  // Gradients
  // ─────────────────────────────────────────
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF061A1C), Color(0xFF0D3A3F)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0C2628), Color(0xFF082022)],
  );
}

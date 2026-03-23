import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Color palette — deep teal dark theme with warm amber accent
// ─────────────────────────────────────────────────────────────────────────────
class C {
  C._();

  // Primary deep teal
  static const bg         = Color(0xFF061A1C);   // darkest bg
  static const bgCard     = Color(0xFF0C2628);   // card bg
  static const bgSheet    = Color(0xFFFFFFFF);   // white sheet
  static const teal900    = Color(0xFF0A3A3E);
  static const teal700    = Color(0xFF0F5C63);
  static const teal500    = Color(0xFF1A7F87);
  static const teal300    = Color(0xFF3BA8B0);
  static const teal100    = Color(0xFFB8E8EC);
  static const tealGlow   = Color(0x331A7F87);

  // Accent — warm ember
  static const amber      = Color(0xFFE07B3A);
  static const amberSoft  = Color(0x1AE07B3A);
  static const amberBorder= Color(0x40E07B3A);

  // Neutrals
  static const ink        = Color(0xFF0D1F21);   // near black text on white
  static const ink2       = Color(0xFF3D5558);
  static const ink3       = Color(0xFF8AADB0);
  static const ghost      = Color(0xFFF0F6F7);   // light fill
  static const ghostBorder= Color(0xFFE0EBED);
  static const white      = Color(0xFFFFFFFF);
  static const white60    = Color(0x99FFFFFF);
  static const white20    = Color(0x33FFFFFF);
  static const white08    = Color(0x14FFFFFF);

  // Semantic
  static const red        = Color(0xFFEF4444);
  static const redSoft    = Color(0x0FEF4444);
  static const redBorder  = Color(0x40EF4444);
  static const green      = Color(0xFF22C55E);

  // Gradients
  static const heroGrad = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF061A1C), Color(0xFF0D3A3F)],
  );

  static const cardGrad = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0C2628), Color(0xFF082022)],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  Typography — Plus Jakarta Sans (apple-like geometry)
// ─────────────────────────────────────────────────────────────────────────────
class T {
  T._();

  static TextStyle h1 = GoogleFonts.plusJakartaSans(
    fontSize: 36, fontWeight: FontWeight.w800,
    color: C.white, letterSpacing: -1.2, height: 1.1,
  );

  static TextStyle h2 = GoogleFonts.plusJakartaSans(
    fontSize: 28, fontWeight: FontWeight.w700,
    color: C.white, letterSpacing: -0.8, height: 1.15,
  );

  static TextStyle h3 = GoogleFonts.plusJakartaSans(
    fontSize: 22, fontWeight: FontWeight.w700,
    color: C.ink, letterSpacing: -0.6, height: 1.2,
  );

  static TextStyle title = GoogleFonts.plusJakartaSans(
    fontSize: 17, fontWeight: FontWeight.w700,
    color: C.ink, letterSpacing: -0.4,
  );

  static TextStyle body = GoogleFonts.plusJakartaSans(
    fontSize: 15, fontWeight: FontWeight.w400,
    color: C.ink2, letterSpacing: -0.2, height: 1.55,
  );

  static TextStyle bodyWhite = GoogleFonts.plusJakartaSans(
    fontSize: 15, fontWeight: FontWeight.w400,
    color: C.white60, letterSpacing: -0.2, height: 1.55,
  );

  static TextStyle label = GoogleFonts.plusJakartaSans(
    fontSize: 12, fontWeight: FontWeight.w600,
    color: C.ink2, letterSpacing: 0.1,
  );

  static TextStyle caption = GoogleFonts.plusJakartaSans(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: C.ink3, letterSpacing: 0,
  );

  static TextStyle btn = GoogleFonts.plusJakartaSans(
    fontSize: 16, fontWeight: FontWeight.w700,
    color: C.white, letterSpacing: -0.3,
  );

  static TextStyle btnSm = GoogleFonts.plusJakartaSans(
    fontSize: 14, fontWeight: FontWeight.w600,
    color: C.white, letterSpacing: -0.2,
  );

  // Convenience: copy with different color
  static TextStyle c(TextStyle s, Color col) => s.copyWith(color: col);
}

// ─────────────────────────────────────────────────────────────────────────────
//  Theme
// ─────────────────────────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: C.bgSheet,
    colorScheme: ColorScheme.fromSeed(
      seedColor: C.teal500, brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
  );
}

// Legacy alias so old imports still compile
class AppColors {
  AppColors._();
  static const tealDeep  = C.teal700;
  static const teal      = C.teal500;
  static const tealMuted = C.teal300;
  static const tealSoft  = Color(0xFFEAF5F6);
  static const tealBorder= C.teal100;
  static const orange    = C.amber;
  static const surface   = C.bgSheet;
  static const bg        = C.ghost;
  static const fill      = C.ghost;
  static const sep       = C.ghostBorder;
  static const text      = C.ink;
  static const text2     = C.ink2;
  static const text3     = C.ink3;
  static const red       = C.red;
  static const redSoft   = C.redSoft;
  static const redBorder = C.redBorder;
}

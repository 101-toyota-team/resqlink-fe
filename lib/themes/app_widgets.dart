import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

TextStyle _t(double size, FontWeight w, Color c,
        {double ls = -0.2, double? h}) =>
    GoogleFonts.plusJakartaSans(
        fontSize: size, fontWeight: w, color: c, letterSpacing: ls, height: h);

enum FieldState { idle, filled, error }

// ─────────────────────────────────────────
//  AppTextField
// ─────────────────────────────────────────
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.fieldState = FieldState.idle,
    this.errorText,
    this.suffixIcon,
    this.onSuffixTap,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final FieldState fieldState;
  final String? errorText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _focused = false;

  Color get _border {
    if (_focused) return AppColors.teal;
    switch (widget.fieldState) {
      case FieldState.filled: return AppColors.tealBorder;
      case FieldState.error:  return AppColors.redBorder;
      case FieldState.idle:   return AppColors.sep;
    }
  }

  Color get _bg {
    if (_focused) return AppColors.surface;
    switch (widget.fieldState) {
      case FieldState.filled: return AppColors.tealSoft;
      case FieldState.error:  return AppColors.redSoft;
      case FieldState.idle:   return AppColors.fill;
    }
  }

  Color get _textC {
    if (widget.fieldState == FieldState.filled && !_focused) return AppColors.tealDeep;
    return AppColors.text;
  }

  Color get _iconC {
    if (widget.fieldState == FieldState.error)  return AppColors.red;
    if (widget.fieldState == FieldState.filled) return AppColors.tealMuted;
    return AppColors.text3;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.label,
            style: _t(13, FontWeight.w500, AppColors.text2, ls: -0.1)),
        const SizedBox(height: 7),
        Focus(
          onFocusChange: (v) => setState(() => _focused = v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 52,
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: _border, width: _focused ? 1.5 : 1),
              boxShadow: _focused
                  ? [BoxShadow(
                      color: AppColors.teal.withOpacity(0.10),
                      blurRadius: 0, spreadRadius: 4)]
                  : [],
            ),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              textInputAction: widget.textInputAction,
              onFieldSubmitted: widget.onFieldSubmitted,
              style: _t(16, FontWeight.w400, _textC),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: _t(16, FontWeight.w400, AppColors.text3),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                border: InputBorder.none,
                suffixIcon: widget.suffixIcon != null
                    ? GestureDetector(
                        onTap: widget.onSuffixTap,
                        child: Icon(widget.suffixIcon,
                            size: 18, color: _iconC),
                      )
                    : null,
              ),
            ),
          ),
        ),
        if (widget.errorText != null && widget.fieldState == FieldState.error)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(children: [
              const Icon(Icons.info_outline_rounded,
                  size: 13, color: AppColors.red),
              const SizedBox(width: 5),
              Text(widget.errorText!,
                  style: _t(12, FontWeight.w400, AppColors.red, ls: 0)),
            ]),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────
//  AppButton
// ─────────────────────────────────────────
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tealDeep,
          disabledBackgroundColor: AppColors.tealDeep.withOpacity(0.5),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label,
                      style: _t(16, FontWeight.w600, Colors.white,
                          ls: -0.3)),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(icon, size: 18),
                  ],
                ],
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  AppSosButton
// ─────────────────────────────────────────
class AppSosButton extends StatelessWidget {
  const AppSosButton({super.key, required this.label, this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.orange,
          side:
              BorderSide(color: AppColors.orange.withOpacity(0.4), width: 1.5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          backgroundColor: AppColors.orange.withOpacity(0.04),
        ),
        icon: const Icon(Icons.warning_amber_rounded, size: 17),
        label: Text(label,
            style: _t(15, FontWeight.w600, AppColors.orange, ls: -0.2)),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  OrDivider
// ─────────────────────────────────────────
class OrDivider extends StatelessWidget {
  const OrDivider({super.key, this.label = 'atau'});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(children: [
        const Expanded(
            child: Divider(color: AppColors.sep, thickness: 1, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label,
              style: _t(13, FontWeight.w400, AppColors.text3, ls: 0)),
        ),
        const Expanded(
            child: Divider(color: AppColors.sep, thickness: 1, height: 1)),
      ]),
    );
  }
}

// ─────────────────────────────────────────
//  PasswordStrengthBar
// ─────────────────────────────────────────
class PasswordStrengthBar extends StatelessWidget {
  const PasswordStrengthBar({super.key, required this.password});
  final String password;

  int get _s {
    if (password.length < 6) return 1;
    if (password.length < 10) return 2;
    final u   = password.contains(RegExp(r'[A-Z]'));
    final sym = password.contains(RegExp(r'[!@#\$%^&*]'));
    return (u && sym) ? 4 : 3;
  }

  Color _c(int seg) {
    if (seg > _s) return AppColors.sep;
    switch (_s) {
      case 1: return AppColors.red;
      case 2: return AppColors.orange;
      case 3: return AppColors.tealMuted;
      case 4: return AppColors.teal;
      default: return AppColors.sep;
    }
  }

  String get _lbl {
    switch (_s) {
      case 1: return 'Lemah';
      case 2: return 'Sedang';
      case 3: return 'Cukup kuat';
      case 4: return 'Kuat';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 8),
        Row(
          children: List.generate(
            4,
            (i) => Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                height: 3,
                decoration: BoxDecoration(
                  color: _c(i + 1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(_lbl, style: _t(12, FontWeight.w400, AppColors.text3, ls: 0)),
      ],
    );
  }
}

// ─────────────────────────────────────────
//  AuthScreen
//  Logo asli (tidak ColorFiltered) di pojok kiri atas hero
// ─────────────────────────────────────────
class AuthScreen extends StatelessWidget {
  const AuthScreen({
    super.key,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.formContent,
    this.heroFraction = 0.38,
    this.backButton = false,
  });

  final String heroTitle;
  final String heroSubtitle;
  final Widget formContent;
  final double heroFraction;
  final bool backButton;

  @override
  Widget build(BuildContext context) {
    final mq      = MediaQuery.of(context);
    final screenH = mq.size.height;
    final topPad  = mq.padding.top;
    final heroH   = screenH * heroFraction;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.tealDeep,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Stack(
            children: [
              // Teal hero
              Container(
                height: heroH + 32,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.tealDeep, Color(0xFF1D8E97)],
                  ),
                ),
                child: Stack(children: [
                  Positioned(
                      right: -70, top: topPad - 80,
                      child: _ring(280, 0.07)),
                  Positioned(
                      right: -20, top: topPad - 20,
                      child: _ring(160, 0.05)),
                  Positioned(
                    left: -50, bottom: 20,
                    child: Container(
                      width: 200, height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.orange.withOpacity(0.12),
                      ),
                    ),
                  ),
                ]),
              ),

              // Hero content
              Positioned(
                left: 24, right: 24,
                top: topPad + 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back + logo row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (backButton)
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: 38, height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(11),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 0.5),
                                ),
                                child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        // Logo ASLI — background teal gelap sudah kontras
                        Image.asset(
                          'assets/images/ResQLink_Logo.png',
                          height: 40,
                        ),
                      ],
                    ),

                    SizedBox(height: heroH * 0.15),

                    Text(
                      heroTitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.15,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      heroSubtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.62),
                        letterSpacing: -0.1,
                      ),
                    ),
                  ],
                ),
              ),

              // White form card
              Container(
                margin: EdgeInsets.only(top: heroH),
                constraints: BoxConstraints(minHeight: screenH - heroH),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 38, height: 4,
                      margin: const EdgeInsets.only(top: 12, bottom: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1D1D6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
                      child: formContent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ring(double s, double o) => Container(
        width: s, height: s,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              Border.all(color: Colors.white.withOpacity(o), width: 1),
        ),
      );
}

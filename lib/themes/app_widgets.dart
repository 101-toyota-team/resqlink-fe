import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

// ─────────────────────────────────────────
//  Field state
// ─────────────────────────────────────────
enum FieldState { idle, filled, error }

// ─────────────────────────────────────────
//  RqTextField  — clean light-mode field
// ─────────────────────────────────────────
class RqTextField extends StatefulWidget {
  const RqTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.obscure = false,
    this.keyboard,
    this.validator,
    this.state = FieldState.idle,
    this.error,
    this.suffix,
    this.onSuffixTap,
    this.action,
    this.onSubmit,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;
  final FieldState state;
  final String? error;
  final IconData? suffix;
  final VoidCallback? onSuffixTap;
  final TextInputAction? action;
  final ValueChanged<String>? onSubmit;

  @override
  State<RqTextField> createState() => _RqTextFieldState();
}

class _RqTextFieldState extends State<RqTextField> {
  bool _focused = false;

  Color get _border {
    if (_focused) return C.teal500;
    return switch (widget.state) {
      FieldState.filled => C.teal100,
      FieldState.error  => C.redBorder,
      FieldState.idle   => C.ghostBorder,
    };
  }

  Color get _bg {
    if (_focused) return C.bgSheet;
    return switch (widget.state) {
      FieldState.filled => const Color(0xFFEAF5F6),
      FieldState.error  => C.redSoft,
      FieldState.idle   => C.ghost,
    };
  }

  Color get _textColor => widget.state == FieldState.filled && !_focused
      ? C.teal700
      : C.ink;

  Color get _iconColor => switch (widget.state) {
    FieldState.error  => C.red,
    FieldState.filled => C.teal500,
    FieldState.idle   => C.ink3,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.label,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 12, fontWeight: FontWeight.w600,
                color: C.ink2, letterSpacing: 0.1)),
        const SizedBox(height: 7),
        Focus(
          onFocusChange: (v) => setState(() => _focused = v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            height: 52,
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: _border, width: _focused ? 1.5 : 1),
              boxShadow: _focused
                  ? [BoxShadow(
                      color: C.teal500.withOpacity(0.12),
                      blurRadius: 0, spreadRadius: 4)]
                  : [],
            ),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.obscure,
              keyboardType: widget.keyboard,
              validator: widget.validator,
              textInputAction: widget.action,
              onFieldSubmitted: widget.onSubmit,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 15, fontWeight: FontWeight.w500,
                  color: _textColor, letterSpacing: -0.2),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 15, color: C.ink3, letterSpacing: -0.2),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16),
                border: InputBorder.none,
                suffixIcon: widget.suffix != null
                    ? GestureDetector(
                        onTap: widget.onSuffixTap,
                        child: Icon(widget.suffix,
                            size: 18, color: _iconColor),
                      )
                    : null,
              ),
            ),
          ),
        ),
        if (widget.error != null && widget.state == FieldState.error)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(children: [
              Icon(Icons.info_outline_rounded,
                  size: 12, color: C.red),
              const SizedBox(width: 5),
              Text(widget.error!,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5, color: C.red)),
            ]),
          ),
      ],
    );
  }
}

// Backwards compat alias
typedef AppTextField = RqTextField;

// ─────────────────────────────────────────
//  RqButton  — primary teal CTA
// ─────────────────────────────────────────
class RqButton extends StatelessWidget {
  const RqButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return SizedBox(
        width: double.infinity, height: 54,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: C.teal700,
            side: const BorderSide(color: C.ghostBorder, width: 1.5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(label,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 15, fontWeight: FontWeight.w700,
                  letterSpacing: -0.3, color: C.teal700)),
        ),
      );
    }

    return SizedBox(
      width: double.infinity, height: 54,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: C.teal700,
          disabledBackgroundColor: C.teal700.withOpacity(0.5),
          foregroundColor: C.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
        ),
        child: loading
            ? const SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 16, fontWeight: FontWeight.w700,
                          letterSpacing: -0.3, color: C.white)),
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

typedef AppButton = RqButton;

// ─────────────────────────────────────────
//  RqSosButton  — amber emergency
// ─────────────────────────────────────────
class RqSosButton extends StatelessWidget {
  const RqSosButton({super.key, required this.label, this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, height: 52,
      child: Material(
        color: C.amberSoft,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: C.amberBorder, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: C.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.emergency_rounded,
                      color: Colors.white, size: 16),
                ),
                const SizedBox(width: 10),
                Text(label,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14, fontWeight: FontWeight.w700,
                        color: C.amber, letterSpacing: -0.2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

typedef AppSosButton = RqSosButton;

// ─────────────────────────────────────────
//  OrDivider
// ─────────────────────────────────────────
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(children: [
        const Expanded(
            child: Divider(color: C.ghostBorder, thickness: 1, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text('atau',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 12, color: C.ink3)),
        ),
        const Expanded(
            child: Divider(color: C.ghostBorder, thickness: 1, height: 1)),
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
    if (seg > _s) return C.ghostBorder;
    return switch (_s) {
      1 => C.red,
      2 => C.amber,
      3 => C.teal300,
      4 => C.teal500,
      _ => C.ghostBorder,
    };
  }

  String get _lbl => switch (_s) {
    1 => 'Lemah',
    2 => 'Sedang',
    3 => 'Cukup kuat',
    4 => 'Kuat',
    _ => '',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 8),
        Row(
          children: List.generate(4, (i) => Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
              height: 3,
              decoration: BoxDecoration(
                  color: _c(i + 1),
                  borderRadius: BorderRadius.circular(2)),
            ),
          )),
        ),
        const SizedBox(height: 5),
        Text(_lbl,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5, color: C.ink3)),
      ],
    );
  }
}

// ─────────────────────────────────────────
//  HeroShell — dark hero + white sheet
//  Completely new layout concept:
//  - Full dark background
//  - Logo large, centered top
//  - Title big and bold
//  - White sheet slides up from bottom
// ─────────────────────────────────────────
class HeroShell extends StatelessWidget {
  const HeroShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.body,
    this.heroFrac = 0.44,
    this.back = false,
    this.centerLogo = false,
  });

  final String title;
  final String subtitle;
  final Widget body;
  final double heroFrac;
  final bool back;
  final bool centerLogo;

  @override
  Widget build(BuildContext context) {
    final mq      = MediaQuery.of(context);
    final sh      = mq.size.height;
    final topPad  = mq.padding.top;
    final heroH   = sh * heroFrac;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: C.bg,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Stack(
            children: [
              // ── Dark hero background ──────────────────
              Container(
                height: heroH + 32,
                decoration: const BoxDecoration(gradient: C.heroGrad),
                child: Stack(children: [
                  // Glow blob top-right
                  Positioned(
                    right: -60, top: -60,
                    child: Container(
                      width: 280, height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: C.teal500.withOpacity(0.18),
                      ),
                    ),
                  ),
                  // Glow blob bottom-left
                  Positioned(
                    left: -40, bottom: 0,
                    child: Container(
                      width: 200, height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: C.amber.withOpacity(0.10),
                      ),
                    ),
                  ),
                  // Fine grid texture
                  Positioned.fill(
                    child: CustomPaint(painter: _DotPainter()),
                  ),
                ]),
              ),

              // ── Hero content ──────────────────────────
              Positioned(
                left: 24, right: 24,
                top: topPad + 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button row
                    if (back)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: C.white08,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: C.white20, width: 0.5),
                            ),
                            child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ),

                    // Logo — full color, no filter
                    Image.asset(
                      'assets/images/ResQLink_Logo.png',
                      height: 44,
                    ),

                    SizedBox(height: heroH * 0.11),

                    // Big title
                    Text(title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: C.white,
                          height: 1.1,
                          letterSpacing: -1.0,
                        )),
                    const SizedBox(height: 8),
                    Text(subtitle,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          color: C.white60,
                          letterSpacing: -0.2,
                          height: 1.4,
                        )),
                  ],
                ),
              ),

              // ── White sheet ───────────────────────────
              Container(
                margin: EdgeInsets.only(top: heroH),
                constraints: BoxConstraints(minHeight: sh - heroH),
                decoration: const BoxDecoration(
                  color: C.bgSheet,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // pill knob
                    Container(
                      width: 40, height: 4,
                      margin: const EdgeInsets.only(top: 12, bottom: 28),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDE4E5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 52),
                      child: body,
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
}

// ── Subtle dot grid texture ───────────────────────────────────────────────────
class _DotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.fill;
    const gap = 24.0;
    for (double x = 0; x < size.width; x += gap) {
      for (double y = 0; y < size.height; y += gap) {
        canvas.drawCircle(Offset(x, y), 1, p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

// ── Step indicator ────────────────────────────────────────────────────────────
class StepBar extends StatelessWidget {
  const StepBar({super.key, required this.current, required this.labels});
  final int current;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (i) {
        final active = i == current;
        final done   = i < current;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < labels.length - 1 ? 10 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: done || active ? C.teal500 : C.ghostBorder,
                  ),
                ),
                const SizedBox(height: 5),
                Text(labels[i],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight:
                          active ? FontWeight.w700 : FontWeight.w400,
                      color: active ? C.teal500 : C.ink3,
                      letterSpacing: -0.1,
                    )),
              ],
            ),
          ),
        );
      }),
    );
  }
}

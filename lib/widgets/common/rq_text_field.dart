import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../themes/app_theme.dart';

enum FieldState { idle, filled, error }

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

  Color get _borderColor {
    if (_focused) return C.teal500;
    return switch (widget.state) {
      FieldState.filled => C.teal100,
      FieldState.error => C.redBorder,
      FieldState.idle => C.ghostBorder,
    };
  }

  Color get _backgroundColor {
    if (_focused) return C.bgSheet;
    return switch (widget.state) {
      FieldState.filled => const Color(0xFFEAF5F6),
      FieldState.error => C.redSoft,
      FieldState.idle => C.ghost,
    };
  }

  Color get _textColor => widget.state == FieldState.filled && !_focused
      ? C.teal700
      : C.ink;

  Color get _iconColor => switch (widget.state) {
    FieldState.error => C.red,
    FieldState.filled => C.teal500,
    FieldState.idle => C.ink3,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLabel(),
        const SizedBox(height: 7),
        _buildInputField(),
        if (widget.error != null && widget.state == FieldState.error)
          _buildErrorMessage(),
      ],
    );
  }

  Widget _buildLabel() => Text(
    widget.label,
    style: GoogleFonts.plusJakartaSans(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: C.ink2,
      letterSpacing: 0.1,
    ),
  );

  Widget _buildInputField() => Focus(
    onFocusChange: (focused) => setState(() => _focused = focused),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      height: 52,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor, width: _focused ? 1.5 : 1),
        boxShadow: _focused
            ? [
          BoxShadow(
            color: C.teal500.withValues(alpha: 0.12),
            blurRadius: 0,
            spreadRadius: 4,
          )
        ]
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
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: _textColor,
          letterSpacing: -0.2,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            color: C.ink3,
            letterSpacing: -0.2,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: InputBorder.none,
          suffixIcon: widget.suffix != null
              ? GestureDetector(
            onTap: widget.onSuffixTap,
            child: Icon(widget.suffix, size: 18, color: _iconColor),
          )
              : null,
        ),
      ),
    ),
  );

  Widget _buildErrorMessage() => Padding(
    padding: const EdgeInsets.only(top: 5),
    child: Row(
      children: [
        Icon(Icons.info_outline_rounded, size: 12, color: C.red),
        const SizedBox(width: 5),
        Text(
          widget.error!,
          style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: C.red),
        ),
      ],
    ),
  );
}

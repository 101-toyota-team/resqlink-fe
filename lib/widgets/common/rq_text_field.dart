import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

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
    if (_focused) return AppColors.primary;
    return switch (widget.state) {
      FieldState.filled => AppColors.divider,
      FieldState.error => Colors.red,
      FieldState.idle => AppColors.divider.withOpacity(0.5),
    };
  }

  Color get _backgroundColor {
    if (_focused) return AppColors.white;
    return switch (widget.state) {
      FieldState.filled => AppColors.secondary.withOpacity(0.1),
      FieldState.error => Colors.red.withOpacity(0.05),
      FieldState.idle => const Color(0xFFF8F8F8),
    };
  }

  Color get _textColor => AppColors.textDark;

  Color get _iconColor => switch (widget.state) {
    FieldState.error => Colors.red,
    _ => AppColors.textGrey,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLabel(),
        const SizedBox(height: 8),
        _buildInputField(),
        if (widget.error != null && widget.state == FieldState.error)
          _buildErrorMessage(),
      ],
    );
  }

  Widget _buildLabel() => Text(
    widget.label,
    style: AppTypography.label.copyWith(
      color: AppColors.textDark.withOpacity(0.6),
      fontWeight: FontWeight.w700,
      fontSize: 11,
      letterSpacing: 1.0,
    ),
  );

  Widget _buildInputField() => Focus(
    onFocusChange: (focused) => setState(() => _focused = focused),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 56,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: _focused ? 1.5 : 1),
        boxShadow: _focused
            ? [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
        style: AppTypography.body.copyWith(
          color: _textColor,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: AppTypography.body.copyWith(
            color: AppColors.textGrey.withOpacity(0.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18),
          border: InputBorder.none,
          suffixIcon: widget.suffix != null
              ? GestureDetector(
            onTap: widget.onSuffixTap,
            child: Icon(widget.suffix, size: 20, color: _focused ? AppColors.primary : _iconColor),
          )
              : null,
        ),
      ),
    ),
  );

  Widget _buildErrorMessage() => Padding(
    padding: const EdgeInsets.only(top: 6, left: 4),
    child: Row(
      children: [
        const Icon(Icons.error_outline_rounded, size: 14, color: Colors.red),
        const SizedBox(width: 6),
        Text(
          widget.error!,
          style: AppTypography.caption.copyWith(color: Colors.red, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

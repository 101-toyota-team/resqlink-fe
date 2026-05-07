import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../themes/app_theme.dart';

/// Displays password strength indicator with visual feedback
class PasswordStrengthBar extends StatelessWidget {
  const PasswordStrengthBar({
    super.key,
    required this.password,
  });

  final String password;

  /// Calculate password strength level (1-4)
  int get _strengthLevel {
    if (password.length < 6) return 1;
    if (password.length < 10) return 2;
    
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasSpecial = password.contains(RegExp(r'[!@#\$%^&*]'));
    
    return (hasUppercase && hasSpecial) ? 4 : 3;
  }

  /// Get color for specific segment
  Color _getSegmentColor(int segment) {
    if (segment > _strengthLevel) return C.ghostBorder;
    
    return switch (_strengthLevel) {
      1 => C.red,
      2 => C.amber,
      3 => C.teal300,
      4 => C.teal500,
      _ => C.ghostBorder,
    };
  }

  /// Get strength label text
  String get _label => switch (_strengthLevel) {
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
        _buildStrengthBars(),
        const SizedBox(height: 5),
        _buildLabel(),
      ],
    );
  }

  Widget _buildStrengthBars() => Row(
    children: List.generate(
      4,
      (index) => Expanded(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
          height: 3,
          decoration: BoxDecoration(
            color: _getSegmentColor(index + 1),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    ),
  );

  Widget _buildLabel() => Text(
    _label,
    style: GoogleFonts.poppins(
      fontSize: 11.5,
      color: C.ink3,
    ),
  );
}

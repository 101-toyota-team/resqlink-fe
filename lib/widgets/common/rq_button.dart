import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../themes/app_theme.dart';

/// A full-width primary action button component
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
    return outlined ? _buildOutlined() : _buildFilled();
  }

  Widget _buildOutlined() => SizedBox(
    width: double.infinity,
    height: 54,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: C.teal700,
        side: const BorderSide(color: C.ghostBorder, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: C.teal700,
        ),
      ),
    ),
  );

  Widget _buildFilled() => SizedBox(
    width: double.infinity,
    height: 54,
    child: ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: C.teal700,
        disabledBackgroundColor: C.teal700.withValues(alpha: 0.5),
        foregroundColor: C.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: loading ? _buildLoadingIndicator() : _buildContent(),
    ),
  );

  Widget _buildLoadingIndicator() => const SizedBox(
    width: 20,
    height: 20,
    child: CircularProgressIndicator(
      strokeWidth: 2,
      color: Colors.white,
    ),
  );

  Widget _buildContent() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: C.white,
        ),
      ),
      if (icon != null) ...[
        const SizedBox(width: 8),
        Icon(icon, size: 18),
      ],
    ],
  );
}

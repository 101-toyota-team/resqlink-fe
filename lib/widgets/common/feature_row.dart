import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../themes/app_theme.dart';

/// A row component displaying a feature with icon, title, and description
class FeatureRow extends StatelessWidget {
  const FeatureRow({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIcon(),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: _buildContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildIcon() => Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Icon(icon, color: color, size: 22),
  );

  Widget _buildContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: C.ink,
          letterSpacing: -0.2,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        description,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13.5,
          color: C.ink2,
          height: 1.55,
          letterSpacing: -0.05,
        ),
      ),
    ],
  );
}

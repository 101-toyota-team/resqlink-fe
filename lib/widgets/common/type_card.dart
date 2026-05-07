import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../themes/app_theme.dart';

/// A card component displaying a registration type option with features
class TypeCard extends StatefulWidget {
  const TypeCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.accentColor,
    required this.title,
    required this.badge,
    required this.badgeColor,
    required this.description,
    required this.features,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final Color accentColor;
  final String title;
  final String badge;
  final Color badgeColor;
  final String description;
  final List<String> features;
  final VoidCallback onTap;

  @override
  State<TypeCard> createState() => _TypeCardState();
}

class _TypeCardState extends State<TypeCard> {
  bool _isPressed = false;

  void _handleTapDown() {
    setState(() => _isPressed = true);
  }

  void _handleTapUp() {
    setState(() => _isPressed = false);
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _handleTapDown(),
      onTapUp: (_) => _handleTapUp(),
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.985 : 1.0,
        duration: const Duration(milliseconds: 110),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2ECEC)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.045),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildDivider(),
              const SizedBox(height: 14),
              _buildDescription(),
              const SizedBox(height: 14),
              _buildFeaturesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildIcon(),
      const SizedBox(width: 14),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: _buildTitleAndBadge(),
        ),
      ),
      const SizedBox(width: 10),
      _buildArrowIcon(),
    ],
  );

  Widget _buildIcon() => Container(
    width: 54,
    height: 54,
    decoration: BoxDecoration(
      color: widget.iconBg,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Icon(
      widget.icon,
      color: widget.iconColor,
      size: 26,
    ),
  );

  Widget _buildTitleAndBadge() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        widget.title,
        style: GoogleFonts.poppins(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: C.ink,
          letterSpacing: -0.4,
        ),
      ),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: widget.badgeColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          widget.badge,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: widget.badgeColor,
            letterSpacing: 0.1,
          ),
        ),
      ),
    ],
  );

  Widget _buildArrowIcon() => Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      color: widget.accentColor.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(11),
    ),
    child: Icon(
      Icons.arrow_forward_rounded,
      size: 18,
      color: widget.accentColor,
    ),
  );

  Widget _buildDivider() => Container(
    height: 1,
    color: const Color(0xFFE8EFEF),
  );

  Widget _buildDescription() => Text(
    widget.description,
    style: GoogleFonts.poppins(
      fontSize: 13.5,
      color: C.ink2,
      height: 1.6,
      letterSpacing: -0.1,
    ),
  );

  Widget _buildFeaturesList() => Column(
    children: widget.features
        .map((feature) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _buildFeatureItem(feature),
    ))
        .toList(),
  );

  Widget _buildFeatureItem(String feature) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 18,
        height: 18,
        margin: const EdgeInsets.only(top: 1),
        decoration: BoxDecoration(
          color: widget.accentColor.withValues(alpha: 0.10),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check_rounded,
          size: 11,
          color: widget.accentColor,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          feature,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: C.ink,
            letterSpacing: -0.1,
            height: 1.45,
          ),
        ),
      ),
    ],
  );
}

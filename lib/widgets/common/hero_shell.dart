import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';

/// Used for authentication screens
class HeroShell extends StatelessWidget {
  const HeroShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.body,
    this.heroFrac = 0.44,
    this.back = false,
    this.logoRight = false,
  });

  final String title;
  final String subtitle;
  final Widget body;
  final double heroFrac;
  final bool back;
  final bool logoRight;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final topPadding = mediaQuery.padding.top;
    final heroHeight = screenHeight * heroFrac;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        body: Column(
          children: [
            SizedBox(
              height: heroHeight + 32,
              width: double.infinity,
              child: Stack(
                children: [
                  _buildHeroBackground(heroHeight),
                  _buildHeroContent(context, topPadding, heroHeight),
                ],
              ),
            ),
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -32),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
                    child: SingleChildScrollView(
                      child: body,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBackground(double heroHeight) => Container(
        height: heroHeight + 32,
        decoration: const BoxDecoration(color: Color(0xFFFFF9E9)),

      );

  Widget _buildHeroContent(
    BuildContext context,
    double topPadding,
    double heroHeight,
  ) =>
      Positioned(
        left: 24,
        right: 24,
        top: topPadding + 56, // Increased from 16 to 56 for lower placement
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context),
            const SizedBox(height: 36), // Increased from 20 to 36 for more space
            _buildHeroText(),
          ],
        ),
      );

  Widget _buildTopBar(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            if (back)
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: _buildBackButton(),
              ),
            const Spacer(),
            Image.asset(
              'assets/images/ResQLink_Logo.png',
              height: 60,
            ),
          ],
        ),
      );

  Widget _buildBackButton() => Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.white, width: 0.5),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Color(0xFFCCA058),
          size: 16,
        ),
      );

  Widget _buildHeroText() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF9E1411),
              letterSpacing: -0.8,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 14.5,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9E1411),
              letterSpacing: -0.15,
              height: 1.5,
            ),
          ),
        ],
      );
}

/// Back button component for hero shell
class BackBtn extends StatelessWidget {
  const BackBtn({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFF9E1411),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: const Color(0xFF9E1411).withValues(alpha: 0.12),
            width: 0.8,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Color(0xFF9E1411),
          size: 16,
        ),
      ),
    );
  }
}

/// Step progress bar component
class StepBar extends StatelessWidget {
  const StepBar({
    super.key,
    required this.current,
    required this.labels,
  });

  final int current;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (int index = 0; index < labels.length; index++) {
      children.add(
        Expanded(
          child: Column(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: index <= current ? AppColors.divider : AppColors.textGrey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                labels[index],
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight:
                      index <= current ? FontWeight.w600 : FontWeight.w400,
                  color: index <= current ? AppColors.divider : AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
      );

      if (index != labels.length - 1) {
        children.add(const SizedBox(width: 8));
      }
    }

    return Row(children: children);
  }
}
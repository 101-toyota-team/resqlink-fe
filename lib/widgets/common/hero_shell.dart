import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

/// Used for authentication screens
class HeroShell extends StatelessWidget {
  const HeroShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.body,
    this.heroFrac = 0.4,
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
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.heroBg,
        body: Column(
          children: [
            SizedBox(
              height: heroHeight + 40,
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
                offset: const Offset(0, -40),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
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
        height: heroHeight + 40,
        decoration: const BoxDecoration(color: AppColors.heroBg),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/images/medic_pattern.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildHeroContent(
    BuildContext context,
    double topPadding,
    double heroHeight,
  ) =>
      Positioned(
        left: 24,
        right: 24,
        top: topPadding + 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context),
            const SizedBox(height: 24),
            _buildHeroText(),
          ],
        ),
      );

  Widget _buildTopBar(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (back)
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: _buildBackButton(),
            )
          else
            const SizedBox(width: 44),
          Image.asset(
            'assets/images/ResQLink_Logo.png',
            height: 48,
          ),
          const SizedBox(width: 44),
        ],
      );

  Widget _buildBackButton() => Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.textDark,
          size: 18,
        ),
      );

  Widget _buildHeroText() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.h1.copyWith(
              color: AppColors.primary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: AppTypography.body.copyWith(
              color: AppColors.textDark.withOpacity(0.6),
              fontWeight: FontWeight.w600,
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
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.textDark,
          size: 18,
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
                  color: index <= current ? AppColors.primary : AppColors.divider,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                labels[index],
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(
                  fontWeight:
                      index <= current ? FontWeight.w700 : FontWeight.w500,
                  color: index <= current ? AppColors.primary : AppColors.textGrey,
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
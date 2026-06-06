import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

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
    height: 56,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      child: Text(
        label,
        style: AppTypography.button.copyWith(color: AppColors.primary),
      ),
    ),
  );

  Widget _buildFilled() => Container(
    width: double.infinity,
    height: 56,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: onPressed != null && !loading ? AppColors.gradient : null,
      boxShadow: onPressed != null && !loading
          ? [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ]
          : null,
    ),
    child: ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed != null && !loading ? Colors.transparent : Colors.grey.shade300,
        foregroundColor: AppColors.white,
        shadowColor: Colors.transparent,
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
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        label,
        style: AppTypography.button,
      ),
      if (icon != null) ...[
        const SizedBox(width: 10),
        Icon(icon, size: 20),
      ],
    ],
  );
}

import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class RqErrorState extends StatelessWidget {
  final String? title;
  final String message;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final IconData? icon;
  final bool fullScreen;

  const RqErrorState({
    super.key,
    this.title,
    required this.message,
    this.onRetry,
    this.retryLabel,
    this.icon,
    this.fullScreen = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.error_outline_rounded,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            
            // Title
            Text(
              title ?? 'Terjadi Kesalahan',
              style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // Message
            Text(
              message,
              style: AppTypography.body.copyWith(color: AppColors.textGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            
            // Retry Button
            if (onRetry != null)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    retryLabel ?? 'Coba Lagi',
                    style: AppTypography.button,
                  ),
                ),
              ),
            
            // Optional Back Button (if fullScreen)
            if (fullScreen && Navigator.canPop(context))
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Kembali',
                    style: AppTypography.button.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    if (fullScreen) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: Navigator.canPop(context) 
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
                  onPressed: () => Navigator.pop(context),
                )
              : null,
        ),
        body: content,
      );
    }

    return content;
  }
}

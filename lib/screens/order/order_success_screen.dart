import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';
import '../home/home_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String providerName;
  final String serviceType;
  final String bookingDate;

  const OrderSuccessScreen({
    super.key,
    required this.providerName,
    required this.serviceType,
    required this.bookingDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/medic_pattern.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Success Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 64,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Thank You Message
                  Text(
                    "Terima Kasih!",
                    style: AppTypography.h1.copyWith(color: AppColors.textDark),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Pesanan Anda telah berhasil dikonfirmasi dan sedang diproses oleh provider.",
                    style: AppTypography.body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Order Details Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow("Provider", providerName),
                        const SizedBox(height: 12),
                        _buildDetailRow("Layanan", serviceType),
                        const SizedBox(height: 12),
                        _buildDetailRow("Tanggal", bookingDate),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Back to Home Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Kembali ke Beranda",
                        style: AppTypography.button,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          value,
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

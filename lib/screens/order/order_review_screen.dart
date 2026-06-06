import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class OrderReviewScreen extends StatefulWidget {
  final String providerName;

  const OrderReviewScreen({
    super.key,
    required this.providerName,
  });

  @override
  State<OrderReviewScreen> createState() => _OrderReviewScreenState();
}

class _OrderReviewScreenState extends State<OrderReviewScreen> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih rating terlebih dahulu')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulasi pengiriman review
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Berhasil"),
          content: const Text("Terima kasih atas ulasan Anda!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
              },
              child: const Text("Tutup"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          "Beri Ulasan",
          style: AppTypography.title.copyWith(color: AppColors.textDark),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Provider Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.divider),
              ),
              child: const Center(
                child: Icon(
                  Icons.local_hospital,
                  color: AppColors.primary,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.providerName,
              style: AppTypography.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Bagaimana pengalaman Anda menggunakan layanan ini?",
              style: AppTypography.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Rating Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 48,
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            // Comment Field
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Tulis komentar (opsional)",
                style: AppTypography.label.copyWith(color: AppColors.textDark),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Ceritakan pengalaman Anda...",
                hintStyle: AppTypography.caption,
                filled: true,
                fillColor: AppColors.cardBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 48),
            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  disabledBackgroundColor: AppColors.textGrey.withValues(alpha: 0.3),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: AppColors.white)
                    : Text(
                        "Kirim Ulasan",
                        style: AppTypography.button,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';
import '../order/order_review_screen.dart';

class HistoryDetailScreen extends StatelessWidget {
  const HistoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.cardBg,
      appBar: AppBar(
        title: Text(
          "Detail Riwayat", 
          style: AppTypography.title.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w800)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/medic_pattern.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSectionCard(
                    title: "Informasi Petugas",
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.local_hospital_rounded, "Provider", "RS Bunda Margonda"),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Divider(height: 1, color: AppColors.divider),
                        ),
                        _buildInfoRow(Icons.person_rounded, "Driver", "Amel Carla"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildSectionCard(
                    title: "Detail Perjalanan",
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.location_on, color: Colors.orange, size: 20),
                              ),
                              Expanded(
                                child: Container(
                                  width: 1.5,
                                  color: AppColors.divider,
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.pin_drop, color: Colors.red, size: 20),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLocationItem(
                                  "Lokasi Jemput", 
                                  "Jl. Margonda Raya No.12, Depok"
                                ),
                                const SizedBox(height: 28),
                                _buildLocationItem(
                                  "Lokasi Tujuan", 
                                  "IGD RS Universitas Indonesia"
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: AppColors.gradient2,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Metode Pembayaran",
                              style: AppTypography.caption.copyWith(color: Colors.white.withOpacity(0.8)),
                            ),
                            Text(
                              "Tunai",
                              style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Divider(color: Colors.white.withOpacity(0.2), height: 1),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Pembayaran",
                              style: AppTypography.body.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Rp300.000",
                              style: AppTypography.h2.copyWith(color: Colors.white, fontSize: 28),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.file_download_outlined, size: 20),
                      label: const Text("Download Invoice"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        elevation: 0,
                        textStyle: AppTypography.button,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderReviewScreen(
                              providerName: "RS Bunda Margonda",
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        textStyle: AppTypography.button,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text("Beri Ulasan"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem(String label, String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: AppTypography.caption.copyWith(color: AppColors.textGrey, fontWeight: FontWeight.w700)
        ),
        const SizedBox(height: 4),
        Text(
          address, 
          style: AppTypography.body.copyWith(fontWeight: FontWeight.w700, color: AppColors.textDark)
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04), 
            blurRadius: 12, 
            offset: const Offset(0, 6)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(), 
            style: AppTypography.label.copyWith(
              fontWeight: FontWeight.w800, 
              fontSize: 11, 
              color: AppColors.amber,
              letterSpacing: 1.2,
            )
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.4),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, size: 22, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label, 
                style: AppTypography.caption.copyWith(color: AppColors.textGrey, fontWeight: FontWeight.w600)
              ),
              Text(
                value, 
                style: AppTypography.body.copyWith(fontWeight: FontWeight.w800, color: AppColors.textDark)
              ),
            ],
          ),
        ),
      ],
    );
  }
}
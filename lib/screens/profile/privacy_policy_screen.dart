import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Kebijakan Privasi',
          style: AppTypography.title.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: Image.asset(
                'assets/images/medic_pattern.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terakhir Diperbarui: 1 Juni 2026',
                  style: AppTypography.caption.copyWith(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  '1. Pendahuluan',
                  'Selamat datang di ResQLink. Kami berkomitmen untuk melindungi privasi Anda dan memastikan data pribadi Anda dikelola dengan aman dan bertanggung jawab. Kebijakan Privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi Anda.',
                ),
                _buildSection(
                  '2. Informasi yang Kami Kumpulkan',
                  'Kami mengumpulkan informasi yang Anda berikan secara langsung saat mendaftar, seperti nama, alamat email, nomor telepon, dan data lokasi saat Anda menggunakan layanan ambulans kami untuk memastikan akurasi penjemputan.',
                ),
                _buildSection(
                  '3. Penggunaan Informasi',
                  'Informasi yang kami kumpulkan digunakan untuk:\n• Menyediakan dan mengelola layanan ResQLink.\n• Menghubungkan Anda dengan provider ambulans terdekat.\n• Mengirimkan notifikasi penting terkait pesanan Anda.\n• Meningkatkan kualitas layanan dan pengalaman pengguna.',
                ),
                _buildSection(
                  '4. Berbagi Informasi',
                  'Kami hanya membagikan data lokasi dan informasi kontak Anda kepada provider ambulans yang Anda pilih untuk memfasilitasi layanan penjemputan dan perawatan medis. Kami tidak menjual data pribadi Anda kepada pihak ketiga.',
                ),
                _buildSection(
                  '5. Keamanan Data',
                  'Kami menerapkan langkah-langkah keamanan teknis dan organisasional untuk melindungi data Anda dari akses yang tidak sah, pengungkapan, atau perubahan.',
                ),
                _buildSection(
                  '6. Hak Anda',
                  'Anda berhak untuk mengakses, memperbarui, atau menghapus informasi pribadi Anda kapan saja melalui pengaturan profil dalam aplikasi atau dengan menghubungi tim dukungan kami.',
                ),
                _buildSection(
                  '7. Perubahan Kebijakan',
                  'Kami dapat memperbarui kebijakan privasi ini dari waktu ke waktu. Kami akan memberikan notifikasi melalui aplikasi jika terdapat perubahan signifikan.',
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'Hubungi Kami: support@resqlink.com',
                    style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.h3.copyWith(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: AppTypography.body.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}

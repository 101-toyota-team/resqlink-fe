import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy notifications data
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Pesanan Dikonfirmasi',
        'body': 'Provider RS Bunda Margonda telah mengonfirmasi pesanan ambulans Anda.',
        'time': '5 menit yang lalu',
        'isRead': false,
        'icon': Icons.check_circle_rounded,
        'color': Colors.green,
      },
      {
        'title': 'Ambulan Menuju Lokasi',
        'body': 'Driver sedang dalam perjalanan menuju lokasi penjemputan Anda.',
        'time': '10 menit yang lalu',
        'isRead': false,
        'icon': Icons.local_shipping_rounded,
        'color': AppColors.primary,
      },
      {
        'title': 'Promo Spesial!',
        'body': 'Dapatkan potongan biaya layanan untuk pemesanan ambulans sosial hari ini.',
        'time': '2 jam yang lalu',
        'isRead': true,
        'icon': Icons.local_offer_rounded,
        'color': AppColors.amber,
      },
      {
        'title': 'Update Layanan',
        'body': 'Kini ResQLink melayani area Depok dan sekitarnya 24/7.',
        'time': '1 hari yang lalu',
        'isRead': true,
        'icon': Icons.info_rounded,
        'color': Colors.blue,
      },
      {
        'title': 'Tips Kesehatan',
        'body': 'Kenali gejala awal serangan jantung dan cara penanganan pertama.',
        'time': '2 hari yang lalu',
        'isRead': true,
        'icon': Icons.health_and_safety_rounded,
        'color': Colors.teal,
      },
    ];

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
          'Notifikasi',
          style: AppTypography.title.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Tandai Baca',
              style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return _buildNotificationItem(item);
              },
            ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> item) {
    final bool isRead = item['isRead'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isRead ? Colors.transparent : AppColors.primary.withValues(alpha: 0.03),
        border: Border(
          bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.5), width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: item['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item['icon'],
              color: item['color'],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['title'],
                        style: AppTypography.body.copyWith(
                          fontWeight: isRead ? FontWeight.w600 : FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item['body'],
                  style: AppTypography.caption.copyWith(
                    color: isRead ? AppColors.textGrey : AppColors.textDark.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['time'],
                  style: AppTypography.captionSmall.copyWith(
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_rounded,
            size: 80,
            color: AppColors.textGrey.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 24),
          Text(
            'Belum ada notifikasi',
            style: AppTypography.title.copyWith(color: AppColors.textGrey),
          ),
          const SizedBox(height: 8),
          Text(
            'Semua pemberitahuan Anda akan muncul di sini',
            style: AppTypography.body.copyWith(color: AppColors.textGrey.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}

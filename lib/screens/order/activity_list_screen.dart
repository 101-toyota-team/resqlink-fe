import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../themes/app_colors.dart';
import '../tracking/tracking_screen.dart'; 
import '../history/history_detail_screen.dart';

class ActivityListScreen extends StatelessWidget {
  const ActivityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data Riwayat Aktivitas
    final List<Map<String, dynamic>> activityData = [
      {
        "type": "Ambulans Medis",
        "date": "7 Mei 2026, 10:30",
        "status": "Sedang Berjalan",
        "statusColor": Colors.blue,
        "icon": "assets/images/ambulance_medis.svg",
        "price": "Rp300.000",
      },
      {
        "type": "Ambulans Jenazah",
        "date": "5 Mei 2026, 14:20",
        "status": "Selesai",
        "statusColor": Colors.green,
        "icon": "assets/images/ambulance_jenazah.svg",
        "price": "Rp550.000",
      },
      {
        "type": "Ambulans Sosial",
        "date": "1 Mei 2026, 09:00",
        "status": "Selesai",
        "statusColor": Colors.green,
        "icon": "assets/images/ambulance_sosial.svg",
        "price": "Rp0 (Gratis)",
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.cardBg,
      appBar: AppBar(
        title: const Text(
          "Aktivitas",
          style: TextStyle(
            color: AppColors.darkBrown, 
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
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
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: activityData.length,
            itemBuilder: (context, index) {
              final activity = activityData[index];
              return _buildActivityCard(context, activity);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, Map<String, dynamic> data) {
    final bool isCompleted = data['status'] == "Selesai";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        onTap: () {
            if (isCompleted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryDetailScreen()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TrackingScreen(
                    bookingId: "ac852e0f-b287-471d-b9b8-bb6c01a92681",
                  ),
                ),
              );
            }
          },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SvgPicture.asset(
                      data['icon'],
                      semanticsLabel: data['type'],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data['type'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.textDark,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: data['statusColor'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                data['status'],
                                style: TextStyle(
                                  color: data['statusColor'],
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              data['date'],
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data['price'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    "Lihat Detail",
                    style: TextStyle(
                      color: AppColors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: AppColors.amber,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
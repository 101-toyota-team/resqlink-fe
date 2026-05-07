import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../tracking/tracking_screen.dart'; 

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Aktivitas",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFF3DE),
          image: DecorationImage(
            image: AssetImage('assets/images/medic_pattern.png'),
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: activityData.length,
          itemBuilder: (context, index) {
            final activity = activityData[index];
            return _buildActivityCard(context, activity);
          },
        ),
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TrackingScreen()),
          );
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
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3DE),
                      borderRadius: BorderRadius.circular(12),
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
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: data['statusColor'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
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
                        const SizedBox(height: 4),
                        Text(
                          data['date'],
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data['price'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    "Lihat Detail",
                    style: TextStyle(
                      color: Color(0xFF9E5C11),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Color(0xFF9E5C11),
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
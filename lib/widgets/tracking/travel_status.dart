import 'dart:ui' as ui; 
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../constants/app_colors.dart'; // Pastikan path ini sesuai dengan constants proyekmu

class TravelStatusWidget extends StatelessWidget {
  // 0 = Menuju Lokasi Anda, 1 = Tiba di Lokasi, 2 = Menuju RS Tujuan, 3 = Sampai di RS
  final int currentStatus; 

  const TravelStatusWidget({
    super.key, 
    required this.currentStatus, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3DE), // Warna krem mewah aslimu
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: AssetImage('assets/images/medic_pattern.png'), // Corak pattern aslimu
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Status Perjalanan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Titik 1: Menuju Lokasi Anda (Aktif jika status >= 0)
              _buildStatusItem(
                Icons.location_on,
                "Menuju Lokasi\nAnda",
                currentStatus >= 0,
              ),
              _buildLine(currentStatus >= 1),
              
              // Titik 2: Tiba di Lokasi (Aktif jika status >= 1)
              _buildStatusItem(
                FontAwesomeIcons.truckMedical,
                "Tiba \ndi Lokasi",
                currentStatus >= 1,
              ),
              _buildLine(currentStatus >= 2),
              
              // Titik 3: Menuju RS Tujuan (Aktif jika status >= 2)
              _buildStatusItem(
                Icons.local_hospital,
                "Menuju RS\nTujuan",
                currentStatus >= 2,
              ),
              _buildLine(currentStatus >= 3),

              // Titik 4: TAMBAHAN STATUS FINAL (Sampai di RS Tujuan)
              _buildStatusItem(
                Icons.check_circle,
                "Sampai \ndi RS",
                currentStatus == 3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Builder lingkaran penanda status dengan warna gradien oranye/merah aslimu
  Widget _buildStatusItem(IconData icon, String label, bool isActive) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: isActive ? AppColors.gradient : null,
            color: isActive ? null : Colors.grey[400],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? Colors.black : Colors.grey[600],
            fontWeight: isActive ? FontWeight.bold : ui.FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // Builder garis penghubung antar lingkaran dengan warna gradien ojol aslimu
  Widget _buildLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 34), // Menyesuaikan tinggi posisi garis agar pas di tengah bulatan
        decoration: BoxDecoration(
          gradient: isActive ? AppColors.gradient2 : null,
          color: isActive ? null : Colors.grey[300],
        ),
      ),
    );
  }
}
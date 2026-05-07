import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../constants/app_colors.dart'; 

class TravelStatusWidget extends StatelessWidget {
  const TravelStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3DE),
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: AssetImage('assets/images/medic_pattern.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Status Perjalanan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusItem(
                Icons.location_on,
                "Menuju Lokasi\nAnda",
                true,
              ),
              _buildLine(true),
              _buildStatusItem(
                FontAwesomeIcons.truckMedical,
                "Tiba \ndi Lokasi",
                false,
              ),
              _buildLine(false),
              _buildStatusItem(
                Icons.local_hospital,
                "Menuju RS\nTujuan",
                false,
              ),
            ],
          ),
        ],
      ),
    );
  }

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
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.black : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          gradient: isActive ? AppColors.gradient2 : null,
          color: isActive ? null : Colors.grey[300],
        ),
      ),
    );
  }
}
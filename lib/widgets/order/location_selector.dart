import 'package:flutter/material.dart';

class LocationSelector extends StatelessWidget {
  const LocationSelector({super.key});

  @override
  Widget build(BuildContext context) {
    const Color borderColor = Color(0xFFCC9E60); 

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 3),
      ),
      child: Column(
        children: [
          _buildLocationItem(
            color: const Color(0xFF88B39F), 
            hint: "Cari Lokasi Jemput",
          ),
          Divider(height: 1, thickness: 3, color: borderColor),
          _buildLocationItem(
            color: const Color(0xFFCC9E60),
            hint: "Cari Lokasi Rumah Sakit Tujuan",
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem({required Color color, required String hint}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            hint,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
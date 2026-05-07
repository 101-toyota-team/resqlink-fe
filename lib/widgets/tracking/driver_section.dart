import 'package:flutter/material.dart';

class DriverSectionWidget extends StatelessWidget {
  const DriverSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const Color borderColor = Color(0xFFCC9E60);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 2.5),
      ),
      child: Column(
        children: [
          // Info Driver
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/driver_profile.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Amel Carla", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text("Pengemudi Ambulan", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text("B 1234 AMB", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 2, color: borderColor),
          // Tombol Hubungi
          IntrinsicHeight(
            child: Row(
              children: [
                _buildCallButton(Icons.phone_in_talk, "Hubungi\nPengemudi"),
                VerticalDivider(width: 1, thickness: 2, color: borderColor),
                _buildCallButton(Icons.emergency, "Hubungi\nRS Tujuan"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallButton(IconData icon, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFCC9E60)),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.black, size: 20),
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
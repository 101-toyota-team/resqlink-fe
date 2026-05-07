import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AmbulanceCard extends StatelessWidget {
  final String name;
  final String distance;
  final String duration;
  final String price;
  final String treatment;

  const AmbulanceCard({
    super.key,
    required this.name,
    required this.distance,
    required this.duration,
    required this.price,
    required this.treatment,
  });

  @override
  Widget build(BuildContext context) {
    const Color borderColor = Color(0xFFCC9E60);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2.5),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                SvgPicture.asset('assets/images/ambulance_medis.svg', width: 80, height: 50), 
                const SizedBox(width: 12),
                
                Expanded( 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                          Flexible(
                            child: Text(
                              " $distance dari posisi Anda",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 8), 

                // Badge Terdekat
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Terdekat", 
                    style: TextStyle(fontSize: 10, color: borderColor)
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, thickness: 2, color: borderColor.withOpacity(0.5)),

          IntrinsicHeight(
            child: Row(
              children: [
                _buildInfoSection(Icons.access_time, "Tiba dalam", duration),
                VerticalDivider(width: 1, thickness: 2, color: borderColor.withOpacity(0.5)),
                _buildInfoSection(Icons.medical_services_outlined, treatment, ""),
                VerticalDivider(width: 1, thickness: 2, color: borderColor.withOpacity(0.5)),
                _buildInfoSection(null, "Estimasi Biaya", price, isPrice: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(IconData? icon, String title, String value, {bool isPrice = false}) {
    return Expanded( 
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox( 
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) Icon(icon, size: 12, color: Colors.black54),
                  if (icon != null) const SizedBox(width: 4),
                  Text(
                    title, 
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            FittedBox( 
              fit: BoxFit.scaleDown,
              child: Text(
                value.isEmpty ? title : value, 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isPrice ? Colors.orange[800] : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
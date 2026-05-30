import 'package:flutter/material.dart';

class EtaInfoWidget extends StatelessWidget {
  final String eta;
  final String distance;

  const EtaInfoWidget({
    super.key,
    required this.eta,
    required this.distance,
  });
  @override
  Widget build(BuildContext context) {
    const Color borderColor = Color(0xFFCC9E60);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2.5),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _buildItem(Icons.access_time, "Estimasi Waktu Tiba", eta),
            VerticalDivider(width: 1, thickness: 2, color: borderColor),
            _buildItem(Icons.location_on_outlined, "Jarak", distance),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 22),
            const SizedBox(width: 8),
            Expanded( 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title, 
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value, 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
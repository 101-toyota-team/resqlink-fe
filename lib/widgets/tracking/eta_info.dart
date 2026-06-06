import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _buildItem(Icons.access_time_rounded, "Waktu Tiba", eta, Colors.blue),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: VerticalDivider(width: 1, thickness: 1, color: AppColors.divider.withValues(alpha: 0.5)),
            ),
            _buildItem(Icons.location_on_rounded, "Jarak Lokasi", distance, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, String value, Color iconColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded( 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title, 
                    style: AppTypography.captionSmall.copyWith(
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value, 
                    style: AppTypography.title.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
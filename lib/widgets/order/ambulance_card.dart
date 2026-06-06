import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class AmbulanceCard extends StatelessWidget {
  final String name;
  final String distance;
  final String duration;
  final String price;
  final String treatment;
  final VoidCallback? onTap;
  final VoidCallback? onSelect;
  final bool isNearest;
  final bool isSelected;

  const AmbulanceCard({
    super.key,
    required this.name,
    required this.distance,
    required this.duration,
    required this.price,
    required this.treatment,
    this.onTap,
    this.onSelect,
    this.isNearest = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : AppColors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider, 
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  // Radio button style selection
                  GestureDetector(
                    onTap: onSelect,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? AppColors.primary : AppColors.white,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.divider,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Center(
                              child: Icon(Icons.check, size: 16, color: Colors.white),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTypography.title.copyWith(height: 1.1),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, size: 14, color: AppColors.textGrey),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                "$distance dari posisi Anda",
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.caption,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  if (isNearest)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Terdekat", 
                        style: AppTypography.captionSmall.copyWith(
                          color: AppColors.amber,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1, color: AppColors.divider),
            ),

            IntrinsicHeight(
              child: Row(
                children: [
                  _buildInfoSection(Icons.access_time_rounded, "Estimasi", duration),
                  _buildDivider(),
                  _buildInfoSection(Icons.medical_services_rounded, "Layanan", treatment),
                  _buildDivider(),
                  _buildInfoSection(null, "Harga", price, isPrice: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 24,
      color: AppColors.divider,
      margin: const EdgeInsets.symmetric(vertical: 12),
    );
  }

  Widget _buildInfoSection(IconData? icon, String title, String value, {bool isPrice = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) Icon(icon, size: 12, color: AppColors.textGrey),
                if (icon != null) const SizedBox(width: 4),
                Text(
                  title,
                  style: AppTypography.captionSmall.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value.isEmpty ? '-' : value,
              textAlign: TextAlign.center,
              style: AppTypography.label.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                color: isPrice ? AppColors.primary : AppColors.textDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

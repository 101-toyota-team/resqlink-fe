import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class TravelStatusWidget extends StatelessWidget {
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Status Perjalanan",
            style: AppTypography.title.copyWith(fontSize: 15, color: AppColors.textDark),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusItem(
                Icons.location_on_rounded,
                "Penjemputan",
                currentStatus >= 0,
              ),
              _buildLine(currentStatus >= 1),
              _buildStatusItem(
                FontAwesomeIcons.truckMedical,
                "Tiba",
                currentStatus >= 1,
              ),
              _buildLine(currentStatus >= 2),
              _buildStatusItem(
                Icons.local_hospital_rounded,
                "Menuju RS",
                currentStatus >= 2,
              ),
              _buildLine(currentStatus >= 3),
              _buildStatusItem(
                Icons.check_circle_rounded,
                "Selesai",
                currentStatus == 3,
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
            color: isActive ? null : const Color(0xFFF5F5F5),
            shape: BoxShape.circle,
            boxShadow: isActive ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ] : null,
          ),
          child: Icon(
            icon, 
            color: isActive ? Colors.white : Colors.grey.shade400, 
            size: 18
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.captionSmall.copyWith(
            fontSize: 10,
            color: isActive ? AppColors.textDark : Colors.grey.shade500,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2.5,
        margin: const EdgeInsets.only(bottom: 38), 
        decoration: BoxDecoration(
          color: isActive ? AppColors.amber : const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
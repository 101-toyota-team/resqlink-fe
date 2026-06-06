import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class LocationSelector extends StatelessWidget {
  final TextEditingController? pickupController;
  final TextEditingController? destinationController;
  final FocusNode? pickupFocusNode;
  final FocusNode? destinationFocusNode;
  final String? initialPickup;
  final String? initialDestination;
  final ValueChanged<String>? onPickupChanged;
  final ValueChanged<String>? onDestinationChanged;
  
  // Additional functionality
  final VoidCallback? onCurrentLocationTap;
  final bool isGettingLocation;
  final bool isReadOnly;
  final String? pickupHint;
  final String? destinationHint;

  const LocationSelector({
    super.key,
    this.pickupController,
    this.destinationController,
    this.pickupFocusNode,
    this.destinationFocusNode,
    this.initialPickup,
    this.initialDestination,
    this.onPickupChanged,
    this.onDestinationChanged,
    this.onCurrentLocationTap,
    this.isGettingLocation = false,
    this.isReadOnly = false,
    this.pickupHint,
    this.destinationHint,
  });

  @override
  Widget build(BuildContext context) {
    final bool readOnly = isReadOnly || pickupController == null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          _buildLocationItem(
            color: const Color(0xFF097B45),
            hint: pickupHint ?? 'Cari Lokasi Jemput',
            controller: pickupController ?? TextEditingController(text: initialPickup),
            focusNode: pickupFocusNode,
            onChanged: onPickupChanged,
            showMyLocationButton: !readOnly && onCurrentLocationTap != null,
            isGettingLocation: isGettingLocation,
            onMyLocationTap: onCurrentLocationTap,
            readOnly: readOnly,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, thickness: 1, color: AppColors.divider),
          ),
          _buildLocationItem(
            color: AppColors.primary,
            hint: destinationHint ?? 'Cari Lokasi Rumah Sakit Tujuan',
            controller: destinationController ?? TextEditingController(text: initialDestination),
            focusNode: destinationFocusNode,
            onChanged: onDestinationChanged,
            showMyLocationButton: false,
            readOnly: readOnly,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem({
    required Color color,
    required String hint,
    required TextEditingController controller,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    bool showMyLocationButton = false,
    bool isGettingLocation = false,
    VoidCallback? onMyLocationTap,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.3), width: 4),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: readOnly
                ? Text(
                    controller.text.isNotEmpty ? controller.text : hint,
                    style: AppTypography.body.copyWith(
                      color: controller.text.isNotEmpty ? AppColors.textDark : AppColors.textGrey.withValues(alpha: 0.5),
                      fontWeight: controller.text.isNotEmpty ? FontWeight.w600 : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : TextField(
                    focusNode: focusNode,
                    controller: controller,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: AppTypography.body.copyWith(
                        color: AppColors.textGrey.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppTypography.body.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
          if (showMyLocationButton)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: GestureDetector(
                onTap: isGettingLocation ? null : onMyLocationTap,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: isGettingLocation
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                        )
                      : const Icon(
                          Icons.my_location_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

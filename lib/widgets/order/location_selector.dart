import 'package:flutter/material.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    const Color borderColor = Color(0xFFCC9E60);
    
    final bool readOnly = isReadOnly || pickupController == null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          _buildLocationItem(
            color: const Color(0xFF88B39F),
            hint: 'Cari Lokasi Jemput',
            controller: pickupController ?? TextEditingController(text: initialPickup),
            focusNode: pickupFocusNode,
            onChanged: onPickupChanged,
            showMyLocationButton: !readOnly && onCurrentLocationTap != null,
            isGettingLocation: isGettingLocation,
            onMyLocationTap: onCurrentLocationTap,
            readOnly: readOnly,
          ),
          const Divider(height: 1, thickness: 3, color: borderColor),
          _buildLocationItem(
            color: const Color(0xFFCC9E60),
            hint: 'Cari Lokasi Rumah Sakit Tujuan',
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
          Expanded(
            child: readOnly
                ? Text(
                    controller.text.isNotEmpty ? controller.text : hint,
                    style: TextStyle(
                      color: controller.text.isNotEmpty ? Colors.black87 : Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : TextField(
                    focusNode: focusNode,
                    controller: controller,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
          ),
          if (showMyLocationButton)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: GestureDetector(
                onTap: isGettingLocation ? null : onMyLocationTap,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: isGettingLocation
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFCC9E60)),
                        )
                      : const Icon(
                          Icons.my_location,
                          color: Color(0xFFCC9E60),
                          size: 22,
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
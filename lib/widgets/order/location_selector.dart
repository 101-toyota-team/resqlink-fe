import 'package:flutter/material.dart';

class LocationSelector extends StatelessWidget {
  final TextEditingController? pickupController;
  final TextEditingController? destinationController;
  final FocusNode? pickupFocusNode;
  final FocusNode? destinationFocusNode;
  final String? initialPickup;
  final String? initialDestination;

  const LocationSelector({
    super.key,
    this.pickupController,
    this.destinationController,
    this.pickupFocusNode,
    this.destinationFocusNode,
    this.initialPickup,
    this.initialDestination,
  });

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
        mainAxisSize: MainAxisSize.min, // Penting agar container tidak makan tempat berlebih
        children: [
          _buildLocationItem(
            color: const Color(0xFF88B39F),
            hint: 'Cari Lokasi Jemput',
            controller: pickupController ?? TextEditingController(text: initialPickup),
            focusNode: pickupFocusNode,
          ),
          Divider(height: 1, thickness: 3, color: borderColor),
          _buildLocationItem(
            color: const Color(0xFFCC9E60),
            hint: 'Cari Lokasi Rumah Sakit Tujuan',
            controller: destinationController ?? TextEditingController(text: initialDestination),
            focusNode: destinationFocusNode,
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
            child: TextField(
              focusNode: focusNode,
              controller: controller,
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
        ],
      ),
    );
  }
}
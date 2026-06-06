import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class PatientConditionWidget extends StatefulWidget {
  final Function(String description)? onConditionChanged;
  
  const PatientConditionWidget({
    super.key, 
    this.onConditionChanged,
  });

  @override
  State<PatientConditionWidget> createState() => _PatientConditionWidgetState();
}

class _PatientConditionWidgetState extends State<PatientConditionWidget> {
  final TextEditingController _descriptionController = TextEditingController();
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_updateCharCount);
  }

  @override
  void dispose() {
    _descriptionController.removeListener(_updateCharCount);
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateCharCount() {
    setState(() {
      _charCount = _descriptionController.text.length;
    });
    widget.onConditionChanged?.call(_descriptionController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0), 
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.medical_information_rounded, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kondisi Pasien',
                      style: AppTypography.title.copyWith(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'Informasi akurat sangat membantu tim medis',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Deskripsi Singkat',
                style: AppTypography.label.copyWith(fontWeight: FontWeight.w700, color: AppColors.textDark),
              ),
              Text(
                '$_charCount/150',
                style: AppTypography.captionSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _charCount >= 140 ? Colors.red : AppColors.textGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Input Field Box
          Container(
            height: 120, 
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: AppColors.divider, width: 1.5), 
            ),
            child: TextField(
              controller: _descriptionController,
              maxLines: null,
              maxLength: 150,
              style: AppTypography.body.copyWith(color: AppColors.textDark), 
              decoration: InputDecoration(
                hintText: 'Contoh: Sesak napas tiba-tiba, nyeri dada, atau luka kecelakaan...',
                hintStyle: AppTypography.caption.copyWith(color: AppColors.textGrey.withOpacity(0.5)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16.0),
                counterText: '',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '* Kerahasiaan data medis pasien terjamin',
            style: AppTypography.captionSmall.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

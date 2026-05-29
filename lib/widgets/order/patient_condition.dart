import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.all(18.0), 
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3DE),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Kondisi Pasien',
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Mohon berikan informasi kondisi secara akurat',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Deskripsi Kondisi Pasien',
                style: TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                '$_charCount/150',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Contoh: sesak napas, serangan jantung, dll', 
            style: TextStyle(
              fontSize: 12, 
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          // Input Field Box
          Container(
            height: 100, 
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: const Color(0xFFA9A9A9), width: 2.0), 
            ),
            child: TextField(
              controller: _descriptionController,
              maxLines: null,
              maxLength: 150,
              style: const TextStyle(fontSize: 14), 
              decoration: const InputDecoration(
                hintText: 'Tulis kondisi di sini...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12.0),
                counterText: '',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
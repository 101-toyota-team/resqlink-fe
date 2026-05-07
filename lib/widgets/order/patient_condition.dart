import 'package:flutter/material.dart';

class PatientConditionWidget extends StatelessWidget {
  const PatientConditionWidget({super.key});

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
              fontSize: 13, // Sebelumnya 16
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Deskripsi Kondisi Pasien',
                style: TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                '0/150',
                style: TextStyle(
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
            child: const TextField(
              maxLines: null,
              style: TextStyle(fontSize: 14), 
              decoration: InputDecoration(
                hintText: 'Tulis kondisi di sini...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
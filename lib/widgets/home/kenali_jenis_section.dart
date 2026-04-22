import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class _AmbulanceTypeData {
  final String name;
  final String desc;
  final bool showButton;
  final String imagePath;
  const _AmbulanceTypeData({
    required this.name,
    required this.desc,
    required this.showButton,
    required this.imagePath,
  });
}

class KenaliJenisSection extends StatelessWidget {
  const KenaliJenisSection({super.key});

  final List<_AmbulanceTypeData> types = const [
    _AmbulanceTypeData(
      name: 'Ambulan Darurat',
      desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
      showButton: true,
      imagePath: 'assets/images/ambulance_darurat.png',
    ),
    _AmbulanceTypeData(
      name: 'Ambulan Medis',
      desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
      showButton: false,
      imagePath: 'assets/images/ambulance_medis.png',
    ),
    _AmbulanceTypeData(
      name: 'Ambulan Sosial',
      desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
      showButton: false,
      imagePath: 'assets/images/ambulance_sosial.png',
    ),
    _AmbulanceTypeData(
      name: 'Ambulan Jenazah',
      desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
      showButton: false,
      imagePath: 'assets/images/ambulance_jenazah.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.gradient2,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 18, 16, 4),
              child: Column(
                children: [
                  Text(
                    'Kenali Jenis-Jenis Ambulan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Pilih ambulans sesuai kebutuhan Anda',
                    style: TextStyle(
                      color: Color(0xFFDDC8A8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...types.asMap().entries.map((entry) {
              final index = entry.key;
              final t = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: _AmbulanceTypeCard(data: t, index: index),
              );
            }),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

class _AmbulanceTypeCard extends StatelessWidget {
  final _AmbulanceTypeData data;
  final int index;
  const _AmbulanceTypeCard({required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    final hasButton = data.showButton;
    final isEven = index % 2 == 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: hasButton
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (isEven) ...[
                      Image.asset(data.imagePath, width: 100, height: 70, fit: BoxFit.contain),
                      const SizedBox(width: 12),
                    ],

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                          const SizedBox(height: 4),
                          Text(data.desc, style: const TextStyle(fontSize: 11, color: AppColors.textGrey, height: 1.4)),
                          
                          const SizedBox(height: 12),
                          
                          // button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.phone, size: 15),
                              label: const Text('Hubungi Sekarang', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (!isEven) ...[
                      const SizedBox(width: 12),
                      Image.asset(data.imagePath, width: 100, height: 70, fit: BoxFit.contain),
                    ],
                  ],
                ),
              ],
            )
          : Row(
              children: [
                if (isEven) ...[
                  Image.asset(data.imagePath, width: 100, height: 70, fit: BoxFit.contain),
                  const SizedBox(width: 12),
                ],

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      const SizedBox(height: 4),
                      Text(data.desc, style: const TextStyle(fontSize: 11, color: AppColors.textGrey, height: 1.4)),
                    ],
                  ),
                ),

                if (!isEven) ...[
                  const SizedBox(width: 12),
                  Image.asset(data.imagePath, width: 100, height: 70, fit: BoxFit.contain),
                ],
              ],
            ),
    );
  }
}
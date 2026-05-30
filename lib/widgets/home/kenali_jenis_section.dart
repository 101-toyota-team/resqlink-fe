import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  static const _types = <_AmbulanceTypeData>[
    _AmbulanceTypeData(
      name: 'Ambulan Darurat',
      desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
      showButton: true,
      imagePath: 'assets/images/ambulance_darurat.svg',
    ),
    _AmbulanceTypeData(
      name: 'Ambulan Medis',
      desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
      showButton: false,
      imagePath: 'assets/images/ambulance_medis.svg',
    ),
    _AmbulanceTypeData(
      name: 'Ambulan Sosial',
      desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
      showButton: false,
      imagePath: 'assets/images/ambulance_sosial.svg',
    ),
    _AmbulanceTypeData(
      name: 'Ambulan Jenazah',
      desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
      showButton: false,
      imagePath: 'assets/images/ambulance_jenazah.svg',
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
            ..._types.asMap().entries.map((entry) {
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
                  crossAxisAlignment: CrossAxisAlignment.start, // Diubah ke start agar teks & gambar sejajar atas saat ada tombol
                  children: [
                    if (isEven) ...[
                      SvgPicture.asset(data.imagePath, width: 100, height: 70, fit: BoxFit.contain),
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
                          
                          GestureDetector(
                            onTap: () {
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                gradient: AppColors.gradient, 
                                borderRadius: BorderRadius.circular(12), 
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center, // Ikon dan teks berada di tengah tombol
                                children: const [
                                  Icon(
                                    Icons.phone,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Hubungi Sekarang',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (!isEven) ...[
                      const SizedBox(width: 12),
                      SvgPicture.asset(data.imagePath, width: 100, height: 70, fit: BoxFit.contain),
                    ],
                  ],
                ),
              ],
            )
          : Row(
              children: [
                if (isEven) ...[
                  SvgPicture.asset(data.imagePath, width: 100, height: 70, fit: BoxFit.contain),
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
                  SvgPicture.asset(data.imagePath, width: 100, height: 70, fit: BoxFit.contain),
                ],
              ],
            ),
    );
  }
}
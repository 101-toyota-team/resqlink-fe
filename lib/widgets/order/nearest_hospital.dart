import 'package:flutter/material.dart';

class HospitalItem {
  final String name;
  final String distance;
  final bool isNearest;

  const HospitalItem({
    required this.name,
    required this.distance,
    this.isNearest = false,
  });
}

class NearestHospitalWidget extends StatelessWidget {
  final List<HospitalItem> hospitals;

  const NearestHospitalWidget({
    super.key,
    required this.hospitals,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Rekomendasi RS Terdekat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFD4A843), // golden border
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(hospitals.length, (index) {
              final hospital = hospitals[index];
              final isLast = index == hospitals.length - 1;
              return Column(
                children: [
                  HospitalTile(hospital: hospital),
                  if (!isLast)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFEEEEEE),
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class HospitalTile extends StatelessWidget {
  final HospitalItem hospital;

  const HospitalTile({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Hospital Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(
                Icons.local_hospital,
                color: Color(0xFF555555),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name & Distance
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hospital.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  hospital.distance,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),

          // "Terdekat" Badge (only for the nearest hospital)
          if (hospital.isNearest) ...[
            const SizedBox(width: 8),
            const _NearestBadge(),
          ],
        ],
      ),
    );
  }
}

class _NearestBadge extends StatelessWidget {
  const _NearestBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD4503A), // reddish-orange border
          width: 1.5,
        ),
      ),
      child: const Text(
        'Terdekat',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFFD4503A),
        ),
      ),
    );
  }
}
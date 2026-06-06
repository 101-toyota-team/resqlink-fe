import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';
import '../../screens/chat/chat_page.dart';

class DriverSectionWidget extends StatelessWidget {
  const DriverSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage('assets/images/driver_profile.png'),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Amel Carla",
                        style: AppTypography.title.copyWith(fontSize: 18, fontWeight: FontWeight.w800)
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Pengemudi Ambulans",
                        style: AppTypography.caption.copyWith(color: AppColors.textGrey, fontWeight: FontWeight.w600)
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider.withOpacity(0.5)),
                  ),
                  child: Text(
                    "B 1234 AMB",
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkBrown,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, color: AppColors.divider.withOpacity(0.5)),
          ),

          IntrinsicHeight(
            child: Row(
              children: [
                _buildCallButton(Icons.phone_in_talk_rounded, "Hubungi\nDriver", AppColors.primary),
                VerticalDivider(width: 1, indent: 16, endIndent: 16, color: AppColors.divider.withOpacity(0.5)),
                _buildCallButton(FontAwesomeIcons.truckMedical, "Hubungi\nRumah Sakit", AppColors.amber),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, color: AppColors.divider.withOpacity(0.5)),
          ),

          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatPage()),
              );
            },
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chat_bubble_rounded, color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      "Kirim pesan ke driver...",
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textGrey, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallButton(IconData icon, String label, Color color) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 12),
              Text(
                label,
                style: AppTypography.captionSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
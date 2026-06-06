import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTap,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedItemColor: const Color(0xFF9E5C11),
        unselectedItemColor: Colors.grey[400],
        showUnselectedLabels: true,
        items: [
          _buildNavbarItem(Icons.home_filled, "Beranda", 0),
          _buildNavbarItem(Icons.assignment, "Aktivitas", 1),
          _buildNavbarItem(Icons.chat_bubble, "Chat", 2),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavbarItem(IconData icon, String label, int index) {
    bool isActive = currentIndex == index;

    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: isActive
            ? ShaderMask(
                shaderCallback: (bounds) => AppColors.gradient.createShader(bounds),
                child: Icon(icon, color: Colors.white, size: 26),
              )
            : Icon(icon, color: Colors.grey[400], size: 26),
      ),
      label: label,
    );
  }
}
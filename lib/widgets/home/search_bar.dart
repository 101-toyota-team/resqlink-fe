import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';


// =============================================================
// SEARCH BAR
// =============================================================
class SearchCard extends StatelessWidget {
  const SearchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Color(0xFFCC9E60), // #CC9E60
          width: 4, // ✅ 4px
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Cari',
            hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 15),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            suffixIcon: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.gradient, // ✅ gradient di box
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.search,
                size: 20,
                color: Colors.white, // ✅ icon putih
              ),
            ),
          ),
        ),
      ),
    );
  }
}
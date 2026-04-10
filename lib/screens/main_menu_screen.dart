import 'package:flutter/material.dart';
import 'package:resqlink/themes/app_colors.dart';
import 'home/home_screen.dart';
import 'register/register_type_screen.dart';
import 'profile/profile_screen.dart';
import 'package:resqlink/services/token_storage.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ProfileScreen(),
  ];

  final List<IconData> _filledIcons = const [
    Icons.home_rounded,
    Icons.person_rounded,
  ];

  final List<IconData> _regularIcons = const [
    Icons.home_outlined,
    Icons.person_outline,
  ];

  final List<Color> _secondaryColors = const [
    AppColors.primaryDark,
    AppColors.primaryDark,
  ];

  void _onItemTapped(int index) async {
    final isLoggedIn = await TokenStorage.hasAccessToken();
    
    // Jika fitur butuh login dan user belum login, tampilkan snackbar dengan warna sesuai fitur
    if (index >= 2 && !isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login diperlukan untuk mengakses fitur ini'),
          backgroundColor: _secondaryColors[index],
          duration: const Duration(seconds: 3),
        ),
      );
      return; // Jangan ubah halaman
    }
    
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: _secondaryColors[_selectedIndex],
        items: List.generate(2, (index) {
          return BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == index ? _filledIcons[index] : _regularIcons[index],
              size: 28,
              color: _secondaryColors[index].withOpacity(_selectedIndex == index ? 1 : 0.5),
            ),
            label: [
              'Home',
              'Profile',
            ][index],
          );
        }),
        backgroundColor: Colors.white,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Tommy',
          fontWeight: FontWeight.w600,
          color: AppColors.primaryLighter,
        ),
      ),
    );
  }
}
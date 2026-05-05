import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants/app_colors.dart';
import '../../widgets/home/hero_container.dart';
import '../../widgets/home/balance_card.dart';
import '../../widgets/home/search_bar.dart'; // Buat file terpisah untuk widget lainnya
import '../../widgets/home/emergency_call_card.dart';
import '../../widgets/home/ambulance_tabs.dart';
import '../../widgets/home/kenali_jenis_section.dart';
import '../../widgets/home/health_mobility_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        // Get name from user metadata
        final name = user.userMetadata?['full_name'] as String? ?? user.email?.split('@')[0] ?? 'User';
        setState(() {
          _userName = name;
        });
      }
    } catch (e) {
      print('Error loading user name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeroContainer(userName: _userName),
              const BalanceCard(),
              const SizedBox(height: 16),
              const SearchCard(), 
              const SizedBox(height: 16),
              const EmergencyCallCard(),
              const SizedBox(height: 16),
              const AmbulanceTypeTabs(),
              const SizedBox(height: 16),
              const KenaliJenisSection(),
              const SizedBox(height: 16),
              const HealthMobilityCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
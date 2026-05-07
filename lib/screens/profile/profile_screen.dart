import 'package:flutter/material.dart';
import 'package:resqlink/screens/landing_screen.dart';
import 'package:resqlink/services/auth_helper.dart';
import 'package:resqlink/widgets/common/rq_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {
  late final Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<Map<String, dynamic>?> _loadProfile() async {
    final user = AuthHelper.currentUser;
    if (user == null) {
      return null;
    }

    final metadata = user.userMetadata ?? <String, dynamic>{};
    final firstName = metadata['first_name']?.toString() ?? '';
    final lastName = metadata['last_name']?.toString() ?? '';
    final fullName = metadata['full_name']?.toString() ??
        [firstName, lastName].where((value) => value.isNotEmpty).join(' ').trim();
    final username = metadata['username']?.toString() ??
        user.email?.split('@').first ??
        '-';

    return {
      'username': username,
      'email': user.email ?? '-',
      'first_name': firstName,
      'last_name': lastName,
      'display_name': fullName.isNotEmpty ? fullName : username,
    };
  }

  Future<void> _handleLogout() async {
    try {
      await AuthHelper.logout();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LandingScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout gagal. Silakan coba lagi.'),
          backgroundColor: Color(0xFFB91212),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ResQLink'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Gagal memuat profil: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final profile = snapshot.data;
          if (profile == null) {
            return const Center(
              child: Text('Silakan login untuk melihat informasi profil.'),
            );
          }

          final username = profile['username'] ?? '-';
          final email = profile['email'] ?? '-';
          final displayName = profile['display_name'] ?? username;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                'Profil Pengguna',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Nama'),
                      subtitle: Text(displayName.isEmpty ? '-' : displayName),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Username'),
                      subtitle: Text(username),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Email'),
                      subtitle: Text(email),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              RqButton(
                label: 'Logout',
                onPressed: _handleLogout,
              ),
            ],
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:resqlink/services/auth_service.dart';
import 'package:resqlink/services/token_storage.dart';

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
    final accessToken = await TokenStorage.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    return AuthService().getProfile(accessToken);
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
          final firstName = profile['first_name'] ?? '';
          final lastName = profile['last_name'] ?? '';
          final displayName = [firstName, lastName]
              .where((value) => value.isNotEmpty)
              .join(' ')
              .trim();

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
            ],
          );
        },
      ),
    );
  }
}
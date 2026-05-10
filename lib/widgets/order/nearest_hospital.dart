import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/nearby_provider_service.dart';
import '../../services/auth_helper.dart';
import 'dart:math' as Math;

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

class NearestHospitalWidget extends StatefulWidget {
  const NearestHospitalWidget({super.key});

  @override
  State<NearestHospitalWidget> createState() => _NearestHospitalWidgetState();
}

class _NearestHospitalWidgetState extends State<NearestHospitalWidget> {
  final NearbyProviderService _nearbyService = NearbyProviderService();
  List<HospitalItem> _hospitals = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNearbyHospitals();
  }

  Future<void> _fetchNearbyHospitals() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get token from AuthHelper
      final token = AuthHelper.token;
      
      if (token == null) {
        throw Exception('Token not found. Please login again.');
      }

      print('🔄 Fetching nearby hospitals...');
      print('Token: ${token.substring(0, Math.min(20, token.length))}...'); // Only show first 20 chars for safety

      // Call the API
      final result = await _nearbyService.getNearbyProviders(token);
      
      print('✅ API Response received: $result');

      // Parse the response based on your API structure
      // Adjust this based on your actual API response format
      List<dynamic> hospitalsData = [];
      
      if (result['data'] != null) {
        hospitalsData = result['data'];
      } else if (result['hospitals'] != null) {
        hospitalsData = result['hospitals'];
      } else if (result is List) {
        hospitalsData = result;
      } else {
        hospitalsData = [];
      }

      // Convert to HospitalItem objects
      final List<HospitalItem> fetchedHospitals = [];
      
      for (var i = 0; i < hospitalsData.length; i++) {
        final hospital = hospitalsData[i];
        fetchedHospitals.add(
          HospitalItem(
            name: hospital['name'] ?? hospital['hospital_name'] ?? 'Unknown Hospital',
            distance: _formatDistance(hospital['distance_km'] ?? hospital['distance']),
            isNearest: i == 0, // First item is nearest if sorted by distance
          ),
        );
      }

      setState(() {
        _hospitals = fetchedHospitals;
        _isLoading = false;
      });

      print('✅ Loaded ${fetchedHospitals.length} nearby hospitals');

      if (fetchedHospitals.isEmpty) {
        print('⚠️ No hospitals found nearby');
      }

    } catch (e, stackTrace) {
      print('❌ Error fetching nearby hospitals: $e');
      print('Stack trace: $stackTrace');
      
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _hospitals = [];
      });
    }
  }

  String _formatDistance(dynamic distance) {
    if (distance == null) return 'Distance unknown';
    
    double distInKm;
    if (distance is String) {
      distInKm = double.tryParse(distance) ?? 0;
    } else {
      distInKm = distance.toDouble();
    }
    
    return '${distInKm.toStringAsFixed(1)} km dari lokasi Anda';
  }

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

        // Loading state
        if (_isLoading)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD4A843), width: 1.5),
            ),
            child: const Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text(
                  'Mencari rumah sakit terdekat...',
                  style: TextStyle(color: Color(0xFF888888)),
                ),
              ],
            ),
          ),
        
        // Error state
        if (!_isLoading && _errorMessage != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.shade200, width: 1.5),
            ),
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 32),
                const SizedBox(height: 8),
                Text(
                  'Gagal memuat data: $_errorMessage',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _fetchNearbyHospitals,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A843),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        
        // Empty state
        if (!_isLoading && _errorMessage == null && _hospitals.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD4A843), width: 1.5),
            ),
            child: const Column(
              children: [
                Icon(Icons.local_hospital_outlined, size: 48, color: Color(0xFF888888)),
                SizedBox(height: 12),
                Text(
                  'Tidak ada rumah sakit ditemukan di sekitar Anda',
                  style: TextStyle(color: Color(0xFF888888)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        
        // Success state with hospitals list
        if (!_isLoading && _errorMessage == null && _hospitals.isNotEmpty)
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
              children: List.generate(_hospitals.length, (index) {
                final hospital = _hospitals[index];
                final isLast = index == _hospitals.length - 1;
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

// HospitalTile remains the same
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
              child: FaIcon(
                FontAwesomeIcons.kitMedical,
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
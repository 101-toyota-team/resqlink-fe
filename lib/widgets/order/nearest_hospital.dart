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
      final token = AuthHelper.token;
      
      if (token == null) {
        throw Exception('Token not found. Please login again.');
      }

      print('🔄 Fetching nearby hospitals...');
      
      final result = await _nearbyService.getNearbyProviders(token);
      
      print('✅ API Response received: $result');
      print('Response type: ${result.runtimeType}'); // Debug: see what type we got

      // Handle different response formats
      List<dynamic> hospitalsData = [];
      
      // Case 1: Response is an empty array
      if (result is List) {
        hospitalsData = result;
        print('Response is a List, length: ${result.length}');
      }
      // Case 2: Response is a Map/object with 'data' field
      else if (result is Map<String, dynamic>) {
        if (result.containsKey('data')) {
          hospitalsData = result['data'] is List ? result['data'] : [];
          print('Found data field with ${hospitalsData.length} items');
        } else if (result.containsKey('hospitals')) {
          hospitalsData = result['hospitals'] is List ? result['hospitals'] : [];
          print('Found hospitals field with ${hospitalsData.length} items');
        } else {
          // Try to use the map values
          hospitalsData = result.values.whereType<List>().expand((e) => e).toList();
          print('Extracted ${hospitalsData.length} items from map values');
        }
      }
      else {
        print('Unknown response format: ${result.runtimeType}');
        hospitalsData = [];
      }

      // Convert to HospitalItem objects safely
      final List<HospitalItem> fetchedHospitals = [];
      
      for (var i = 0; i < hospitalsData.length; i++) {
        final hospital = hospitalsData[i];
        
        // Safely extract values with null checks
        final name = hospital['name'] ?? 
                    hospital['hospital_name'] ?? 
                    hospital['nama_rs'] ?? 
                    'Unknown Hospital';
                    
        // Handle distance (could be string, int, double, or null)
        String distanceText = 'Distance unknown';
        final distanceValue = hospital['distance_km'] ?? hospital['distance'];
        
        if (distanceValue != null) {
          try {
            double distInKm;
            if (distanceValue is String) {
              distInKm = double.parse(distanceValue);
            } else if (distanceValue is int || distanceValue is double) {
              distInKm = distanceValue.toDouble();
            } else {
              distInKm = 0.0;
            }
            distanceText = '${distInKm.toStringAsFixed(1)} km dari lokasi Anda';
          } catch (e) {
            print('Error parsing distance: $e');
            distanceText = 'Jarak tidak diketahui';
          }
        }
        
        fetchedHospitals.add(
          HospitalItem(
            name: name,
            distance: distanceText,
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